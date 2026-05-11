import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String name;
  final String sku;
  final String category;
  final String unit;
  final String description;
  final String supplierName;
  final int stock;
  final int minStock;
  final int purchasePrice;
  final int sellingPrice;
  final String ownerUid;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const ItemModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.unit,
    required this.description,
    required this.supplierName,
    required this.stock,
    required this.minStock,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.ownerUid,
    this.createdAt,
    this.updatedAt,
  });

  bool get isLowStock => stock <= minStock && stock > 0;

  bool get isOutOfStock => stock <= 0;

  String get stockStatus {
    if (isOutOfStock) return 'Stok Habis';
    if (isLowStock) return 'Stok Rendah';
    return 'Stok Aman';
  }

  int get stockValue => stock * purchasePrice;

  factory ItemModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return ItemModel(
      id: doc.id,
      name: data['name'] ?? '',
      sku: data['sku'] ?? '',
      category: data['category'] ?? 'Umum',
      unit: data['unit'] ?? '',
      description: data['description'] ?? '',
      supplierName: data['supplierName'] ?? '',
      stock: data['stock'] ?? 0,
      minStock: data['minStock'] ?? 0,
      purchasePrice: data['purchasePrice'] ?? 0,
      sellingPrice: data['sellingPrice'] ?? 0,
      ownerUid: data['ownerUid'] ?? '',
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      'name': name,
      'sku': sku,
      'category': category,
      'unit': unit,
      'description': description,
      'supplierName': supplierName,
      'stock': stock,
      'minStock': minStock,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'ownerUid': ownerUid,
      'keywords': _generateKeywords(name, sku, category),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'name': name,
      'sku': sku,
      'category': category,
      'unit': unit,
      'description': description,
      'supplierName': supplierName,
      'stock': stock,
      'minStock': minStock,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'keywords': _generateKeywords(name, sku, category),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  ItemModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? category,
    String? unit,
    String? description,
    String? supplierName,
    int? stock,
    int? minStock,
    int? purchasePrice,
    int? sellingPrice,
    String? ownerUid,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      supplierName: supplierName ?? this.supplierName,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      ownerUid: ownerUid ?? this.ownerUid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static List<String> _generateKeywords(String name, String sku, String category) {
    final rawText = '${name.toLowerCase()} ${sku.toLowerCase()} ${category.toLowerCase()}';
    return rawText
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .toSet()
        .toList();
  }
}
