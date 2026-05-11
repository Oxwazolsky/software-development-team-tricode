import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/firestore_user_scope.dart';
import '../../../models/item_model.dart';

class ItemService {
  CollectionReference<Map<String, dynamic>> get _itemsCollection =>
      FirestoreUserScope.itemsCollection;

  Stream<List<ItemModel>> getItems() {
    return _itemsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(ItemModel.fromFirestore).toList();
    });
  }

  Future<ItemModel?> getItemById(String id) async {
    final doc = await _itemsCollection.doc(id).get();
    if (!doc.exists) return null;
    return ItemModel.fromFirestore(doc);
  }

  Future<bool> isSkuAlreadyUsed({
    required String sku,
    String? ignoredItemId,
  }) async {
    final query = await _itemsCollection
        .where('sku', isEqualTo: sku.trim().toUpperCase())
        .limit(1)
        .get();

    if (query.docs.isEmpty) return false;

    if (ignoredItemId != null && query.docs.first.id == ignoredItemId) {
      return false;
    }

    return true;
  }

  Future<void> addItem({
    required String name,
    required String sku,
    required int stock,
    required int minStock,
    required String unit,
    required String description,
    String category = 'Umum',
    String supplierName = '',
    int purchasePrice = 0,
    int sellingPrice = 0,
  }) async {
    final normalizedSku = sku.trim().toUpperCase();

    final skuUsed = await isSkuAlreadyUsed(sku: normalizedSku);
    if (skuUsed) {
      throw Exception('SKU sudah digunakan oleh barang lain.');
    }

    final item = ItemModel(
      id: '',
      name: name.trim(),
      sku: normalizedSku,
      category: category.trim().isEmpty ? 'Umum' : category.trim(),
      unit: unit.trim(),
      description: description.trim(),
      supplierName: supplierName.trim(),
      stock: stock,
      minStock: minStock,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      ownerUid: FirestoreUserScope.uid,
    );

    await _itemsCollection.add(item.toCreateMap());
  }

  Future<void> updateItem({
    required String id,
    required String name,
    required String sku,
    required int stock,
    required int minStock,
    required String unit,
    required String description,
    String category = 'Umum',
    String supplierName = '',
    int purchasePrice = 0,
    int sellingPrice = 0,
  }) async {
    final normalizedSku = sku.trim().toUpperCase();

    final skuUsed = await isSkuAlreadyUsed(
      sku: normalizedSku,
      ignoredItemId: id,
    );

    if (skuUsed) {
      throw Exception('SKU sudah digunakan oleh barang lain.');
    }

    final item = ItemModel(
      id: id,
      name: name.trim(),
      sku: normalizedSku,
      category: category.trim().isEmpty ? 'Umum' : category.trim(),
      unit: unit.trim(),
      description: description.trim(),
      supplierName: supplierName.trim(),
      stock: stock,
      minStock: minStock,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      ownerUid: FirestoreUserScope.uid,
    );

    await _itemsCollection.doc(id).update(item.toUpdateMap());
  }

  Future<void> updateStock({
    required String itemId,
    required int quantityChange,
  }) async {
    final itemRef = _itemsCollection.doc(itemId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(itemRef);

      if (!snapshot.exists) {
        throw Exception('Barang tidak ditemukan.');
      }

      final data = snapshot.data() ?? {};
      final currentStock = data['stock'] ?? 0;
      final newStock = currentStock + quantityChange;

      if (newStock < 0) {
        throw Exception('Stok tidak mencukupi.');
      }

      transaction.update(itemRef, {
        'stock': newStock,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> deleteItem(String id) async {
    await _itemsCollection.doc(id).delete();
  }
}
