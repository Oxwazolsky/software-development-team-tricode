import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/firestore_user_scope.dart';
import '../../../models/item_model.dart';
import '../../../models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _itemsCollection {
    return FirestoreUserScope.itemsCollection;
  }

  CollectionReference<Map<String, dynamic>> get _transactionsCollection {
    return FirestoreUserScope.transactionsCollection;
  }

  Stream<List<TransactionModel>> getTransactions() {
    return _transactionsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(TransactionModel.fromFirestore).toList();
    });
  }

  Future<List<TransactionModel>> getRecentTransactions({
    int limit = 10,
  }) async {
    final snapshot = await _transactionsCollection
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map(TransactionModel.fromFirestore).toList();
  }

  Future<void> addStockIn({
    required ItemModel item,
    required int quantity,
    required String description,
    required String createdBy,
  }) async {
    await _addStockMovement(
      item: item,
      quantity: quantity,
      type: 'in',
      description: description,
      createdBy: createdBy,
    );
  }

  Future<void> addStockOut({
    required ItemModel item,
    required int quantity,
    required String description,
    required String createdBy,
  }) async {
    await _addStockMovement(
      item: item,
      quantity: quantity,
      type: 'out',
      description: description,
      createdBy: createdBy,
    );
  }

  Future<void> _addStockMovement({
    required ItemModel item,
    required int quantity,
    required String type,
    required String description,
    required String createdBy,
  }) async {
    if (item.id.trim().isEmpty) {
      throw Exception('ID barang tidak valid.');
    }

    if (quantity <= 0) {
      throw Exception('Jumlah transaksi harus lebih dari 0.');
    }

    if (type != 'in' && type != 'out') {
      throw Exception('Tipe transaksi tidak valid.');
    }

    final itemRef = _itemsCollection.doc(item.id);
    final transactionRef = _transactionsCollection.doc();

    await _firestore.runTransaction((dbTransaction) async {
      final itemSnapshot = await dbTransaction.get(itemRef);

      if (!itemSnapshot.exists) {
        throw Exception('Barang tidak ditemukan.');
      }

      final itemData = itemSnapshot.data() ?? <String, dynamic>{};

      final currentStock = _toInt(itemData['stock']);
      final newStock = type == 'in'
          ? currentStock + quantity
          : currentStock - quantity;

      if (newStock < 0) {
        throw Exception('Stok tidak mencukupi.');
      }

      final referenceNumber = _generateReferenceNumber(type);

      dbTransaction.update(itemRef, {
        'stock': newStock,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      dbTransaction.set(transactionRef, {
        'itemId': item.id,
        'itemName': item.name,
        'itemSku': item.sku,
        'type': type,
        'quantity': quantity,
        'previousStock': currentStock,
        'latestStock': newStock,
        'description': description.trim().isEmpty
            ? _defaultDescription(type, quantity, item.name)
            : description.trim(),
        'createdBy': createdBy.trim().isEmpty ? 'System' : createdBy.trim(),
        'referenceNumber': referenceNumber,
        'ownerUid': FirestoreUserScope.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionsCollection.doc(id).delete();
  }

  String _generateReferenceNumber(String type) {
    final prefix = type == 'in' ? 'IN' : 'OUT';
    final now = DateTime.now();
    final timestamp =
        '${now.year}${_twoDigit(now.month)}${_twoDigit(now.day)}${_twoDigit(now.hour)}${_twoDigit(now.minute)}${_twoDigit(now.second)}';

    return '$prefix-$timestamp';
  }

  String _defaultDescription(String type, int quantity, String itemName) {
    if (type == 'in') {
      return 'Stok masuk $quantity untuk $itemName';
    }

    return 'Stok keluar $quantity untuk $itemName';
  }

  String _twoDigit(int value) {
    return value.toString().padLeft(2, '0');
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
