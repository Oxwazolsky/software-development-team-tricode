import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String itemId;
  final String itemName;
  final String itemSku;
  final String type;
  final int quantity;
  final int previousStock;
  final int latestStock;
  final String description;
  final String createdBy;
  final String referenceNumber;
  final Timestamp? createdAt;

  const TransactionModel({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.itemSku,
    required this.type,
    required this.quantity,
    required this.previousStock,
    required this.latestStock,
    required this.description,
    required this.createdBy,
    required this.referenceNumber,
    this.createdAt,
  });

  bool get isStockIn => type == 'in';

  bool get isStockOut => type == 'out';

  int get stockDelta {
    if (isStockIn) return quantity;
    if (isStockOut) return -quantity;
    return 0;
  }

  String get typeLabel {
    if (isStockIn) return 'Barang Masuk';
    if (isStockOut) return 'Barang Keluar';
    return 'Transaksi';
  }

  factory TransactionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? <String, dynamic>{};

    return TransactionModel(
      id: doc.id,
      itemId: (data['itemId'] ?? '').toString(),
      itemName: (data['itemName'] ?? '').toString(),
      itemSku: (data['itemSku'] ?? data['sku'] ?? '').toString(),
      type: (data['type'] ?? '').toString(),
      quantity: _toInt(data['quantity']),
      previousStock: _toInt(data['previousStock'] ?? data['beforeStock']),
      latestStock: _toInt(data['latestStock'] ?? data['afterStock']),
      description: (data['description'] ?? '').toString(),
      createdBy: (data['createdBy'] ?? '').toString(),
      referenceNumber: (data['referenceNumber'] ?? '').toString(),
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'itemSku': itemSku,
      'type': type,
      'quantity': quantity,
      'previousStock': previousStock,
      'latestStock': latestStock,
      'description': description,
      'createdBy': createdBy,
      'referenceNumber': referenceNumber,
      'createdAt': createdAt,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}