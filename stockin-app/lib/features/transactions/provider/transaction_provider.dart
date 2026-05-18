import 'package:flutter/material.dart';

import '../../../models/item_model.dart';
import '../../../models/transaction_model.dart';
import '../data/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _transactionService = TransactionService();

  bool _isLoading = false;
  String? _errorMessage;
  String _selectedFilter = 'all';
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  Stream<List<TransactionModel>> getTransactions() {
    return _transactionService.getTransactions();
  }

  Future<List<TransactionModel>> getRecentTransactions({
    int limit = 10,
  }) async {
    try {
      return await _transactionService.getRecentTransactions(limit: limit);
    } catch (_) {
      _errorMessage = 'Gagal mengambil transaksi terbaru.';
      notifyListeners();
      return [];
    }
  }

  List<TransactionModel> filterTransactions(
    List<TransactionModel> transactions,
  ) {
    var result = transactions;

    if (_selectedFilter != 'all') {
      result = result.where((trx) => trx.type == _selectedFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();

      result = result.where((trx) {
        return trx.itemName.toLowerCase().contains(query) ||
            trx.itemSku.toLowerCase().contains(query) ||
            trx.description.toLowerCase().contains(query) ||
            trx.referenceNumber.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  TransactionSummary getSummary(List<TransactionModel> transactions) {
    final totalIn = transactions
        .where((trx) => trx.isStockIn)
        .fold<int>(0, (total, trx) => total + trx.quantity);

    final totalOut = transactions
        .where((trx) => trx.isStockOut)
        .fold<int>(0, (total, trx) => total + trx.quantity);

    return TransactionSummary(
      totalTransactions: transactions.length,
      totalStockIn: totalIn,
      totalStockOut: totalOut,
      netMovement: totalIn - totalOut,
    );
  }

  void updateFilter(String value) {
    _selectedFilter = value;
    notifyListeners();
  }

  void updateSearchQuery(String value) {
    _searchQuery = value.trim();
    notifyListeners();
  }

  Future<bool> addStockIn({
    required ItemModel item,
    required int quantity,
    required String description,
    required String createdBy,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _transactionService.addStockIn(
        item: item,
        quantity: quantity,
        description: description,
        createdBy: createdBy,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addStockOut({
    required ItemModel item,
    required int quantity,
    required String description,
    required String createdBy,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _transactionService.addStockOut(
        item: item,
        quantity: quantity,
        description: description,
        createdBy: createdBy,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteTransaction(String id) async {
    _setLoading(true);
    _clearError();

    try {
      await _transactionService.deleteTransaction(id);
      return true;
    } catch (_) {
      _errorMessage = 'Gagal menghapus transaksi.';
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

class TransactionSummary {
  final int totalTransactions;
  final int totalStockIn;
  final int totalStockOut;
  final int netMovement;

  const TransactionSummary({
    required this.totalTransactions,
    required this.totalStockIn,
    required this.totalStockOut,
    required this.netMovement,
  });
}
