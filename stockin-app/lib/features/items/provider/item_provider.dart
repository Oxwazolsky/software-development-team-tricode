import 'package:flutter/material.dart';

import '../../../models/item_model.dart';
import '../data/item_service.dart';

class ItemProvider with ChangeNotifier {
  final ItemService _itemService = ItemService();

  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Stream<List<ItemModel>> getItems() {
    return _itemService.getItems();
  }

  List<ItemModel> filterItems(List<ItemModel> items) {
    if (_searchQuery.isEmpty) return items;

    return items.where((item) {
      final query = _searchQuery.toLowerCase();
      return item.name.toLowerCase().contains(query) ||
          item.sku.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.supplierName.toLowerCase().contains(query);
    }).toList();
  }

  int countLowStock(List<ItemModel> items) {
    return items.where((item) => item.isLowStock).length;
  }

  int countOutOfStock(List<ItemModel> items) {
    return items.where((item) => item.isOutOfStock).length;
  }

  int countTotalStockValue(List<ItemModel> items) {
    return items.fold(0, (total, item) => total + item.stockValue);
  }

  void updateSearchQuery(String value) {
    _searchQuery = value.trim();
    notifyListeners();
  }

  Future<ItemModel?> getItemById(String id) async {
    try {
      return await _itemService.getItemById(id);
    } catch (_) {
      _errorMessage = 'Gagal mengambil detail barang.';
      notifyListeners();
      return null;
    }
  }

  Future<bool> addItem({
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
    _setLoading(true);
    _clearError();

    try {
      await _itemService.addItem(
        name: name,
        sku: sku,
        stock: stock,
        minStock: minStock,
        unit: unit,
        description: description,
        category: category,
        supplierName: supplierName,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateItem({
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
    _setLoading(true);
    _clearError();

    try {
      await _itemService.updateItem(
        id: id,
        name: name,
        sku: sku,
        stock: stock,
        minStock: minStock,
        unit: unit,
        description: description,
        category: category,
        supplierName: supplierName,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteItem(String id) async {
    _setLoading(true);
    _clearError();

    try {
      await _itemService.deleteItem(id);
      return true;
    } catch (_) {
      _errorMessage = 'Gagal menghapus barang.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateStock({
    required String itemId,
    required int quantityChange,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _itemService.updateStock(
        itemId: itemId,
        quantityChange: quantityChange,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
