import 'package:flutter/material.dart';

import '../data/report_service.dart';
import '../models/report_summary_model.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Stream<ReportSummaryModel> getReportSummary() {
    return _reportService.getReportSummary();
  }

  Future<ReportSummaryModel> generateEmptyReportPreview() async {
    _setLoading(true);
    _clearError();

    try {
      return ReportSummaryModel.empty();
    } catch (_) {
      _errorMessage = 'Gagal membuat preview laporan.';
      return ReportSummaryModel.empty();
    } finally {
      _setLoading(false);
    }
  }

  String formatCurrency(int value) {
    return 'Rp$value';
  }

  String formatStockMovement(int value) {
    if (value > 0) {
      return '+$value';
    }

    return value.toString();
  }

  String getReportNote(ReportSummaryModel summary) {
    if (summary.totalItems == 0) {
      return 'Belum ada data barang yang dapat ditampilkan.';
    }

    if (summary.hasStockAlert) {
      return 'Terdapat barang yang perlu diperhatikan karena stok rendah atau habis.';
    }

    return 'Kondisi stok barang saat ini aman.';
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
