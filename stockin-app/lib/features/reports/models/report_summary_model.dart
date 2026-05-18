class ReportSummaryModel {
  final int totalItems;
  final int totalStock;
  final int totalLowStockItems;
  final int totalOutOfStockItems;
  final int totalStockIn;
  final int totalStockOut;
  final int totalStockValue;

  const ReportSummaryModel({
    required this.totalItems,
    required this.totalStock,
    required this.totalLowStockItems,
    required this.totalOutOfStockItems,
    required this.totalStockIn,
    required this.totalStockOut,
    required this.totalStockValue,
  });

  int get netStockMovement {
    return totalStockIn - totalStockOut;
  }

  bool get hasStockAlert {
    return totalLowStockItems > 0 || totalOutOfStockItems > 0;
  }

  String get stockHealthStatus {
    if (totalOutOfStockItems > 0) {
      return 'Ada barang habis';
    }

    if (totalLowStockItems > 0) {
      return 'Ada stok rendah';
    }

    return 'Stok aman';
  }

  factory ReportSummaryModel.empty() {
    return const ReportSummaryModel(
      totalItems: 0,
      totalStock: 0,
      totalLowStockItems: 0,
      totalOutOfStockItems: 0,
      totalStockIn: 0,
      totalStockOut: 0,
      totalStockValue: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalItems': totalItems,
      'totalStock': totalStock,
      'totalLowStockItems': totalLowStockItems,
      'totalOutOfStockItems': totalOutOfStockItems,
      'totalStockIn': totalStockIn,
      'totalStockOut': totalStockOut,
      'netStockMovement': netStockMovement,
      'totalStockValue': totalStockValue,
      'stockHealthStatus': stockHealthStatus,
    };
  }
}
