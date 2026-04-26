import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._(); // prevent instantiation

  static final _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
  );

  /// Format double ke string rupiah
  /// Contoh: 5000000 → "Rp 5.000.000,00"
  static String format(double amount) => _formatter.format(amount);

  /// Format tanpa desimal
  /// Contoh: 5000000 → "Rp 5.000.000"
  static String formatCompact(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }
}
