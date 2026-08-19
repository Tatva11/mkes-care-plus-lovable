class SalaryDeductionConfig {
  final double dailyRate;

  const SalaryDeductionConfig({
    required this.dailyRate,
  });

  /// Abstract logic to compute deduction based on number of unpaid leave days.
  /// This isolates the business rule for future updates.
  double calculateDeduction(double unpaidLeaveDays) {
    if (unpaidLeaveDays <= 0) return 0.0;
    return unpaidLeaveDays * dailyRate;
  }
}
