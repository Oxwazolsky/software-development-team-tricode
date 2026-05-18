class ReportDateFilter {
  final DateTime startDate;
  final DateTime endDate;

  const ReportDateFilter({
    required this.startDate,
    required this.endDate,
  });

  factory ReportDateFilter.today() {
    final now = DateTime.now();

    return ReportDateFilter(
      startDate: DateTime(now.year, now.month, now.day),
      endDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  factory ReportDateFilter.thisMonth() {
    final now = DateTime.now();

    return ReportDateFilter(
      startDate: DateTime(now.year, now.month, 1),
      endDate: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
    );
  }

  factory ReportDateFilter.custom({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return ReportDateFilter(
      startDate: DateTime(startDate.year, startDate.month, startDate.day),
      endDate: DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59),
    );
  }

  bool contains(DateTime date) {
    return !date.isBefore(startDate) && !date.isAfter(endDate);
  }
}
