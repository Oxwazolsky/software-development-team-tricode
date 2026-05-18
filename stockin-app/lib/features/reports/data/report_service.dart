import '../../../models/item_model.dart';
import '../../../models/transaction_model.dart';
import '../../items/data/item_service.dart';
import '../../transactions/data/transaction_service.dart';
import '../models/report_summary_model.dart';
import '../utils/report_date_filter.dart';

class ReportService {
  final ItemService _itemService = ItemService();
  final TransactionService _transactionService = TransactionService();

  Stream<ReportSummaryModel> getReportSummary() {
    return _itemService.getItems().asyncMap((items) async {
      final transactions = await _transactionService.getRecentTransactions(
        limit: 100,
      );

      return buildSummary(
        items: items,
        transactions: transactions,
      );
    });
  }

  ReportSummaryModel buildSummary({
    required List<ItemModel> items,
    required List<TransactionModel> transactions,
    ReportDateFilter? dateFilter,
  }) {
    final filteredTransactions = _filterTransactionsByDate(
      transactions: transactions,
      dateFilter: dateFilter,
    );

    final totalStock = items.fold<int>(
      0,
      (total, item) => total + item.stock,
    );

    final totalStockValue = items.fold<int>(
      0,
      (total, item) => total + item.stockValue,
    );

    final totalLowStockItems = items.where((item) => item.isLowStock).length;
    final totalOutOfStockItems = items.where((item) => item.isOutOfStock).length;

    final totalStockIn = filteredTransactions
        .where((transaction) => transaction.isStockIn)
        .fold<int>(0, (total, transaction) => total + transaction.quantity);

    final totalStockOut = filteredTransactions
        .where((transaction) => transaction.isStockOut)
        .fold<int>(0, (total, transaction) => total + transaction.quantity);

    return ReportSummaryModel(
      totalItems: items.length,
      totalStock: totalStock,
      totalLowStockItems: totalLowStockItems,
      totalOutOfStockItems: totalOutOfStockItems,
      totalStockIn: totalStockIn,
      totalStockOut: totalStockOut,
      totalStockValue: totalStockValue,
    );
  }

  List<TransactionModel> _filterTransactionsByDate({
    required List<TransactionModel> transactions,
    ReportDateFilter? dateFilter,
  }) {
    if (dateFilter == null) {
      return transactions;
    }

    return transactions.where((transaction) {
      final createdAt = transaction.createdAt?.toDate();

      if (createdAt == null) {
        return false;
      }

      return dateFilter.contains(createdAt);
    }).toList();
  }
}
