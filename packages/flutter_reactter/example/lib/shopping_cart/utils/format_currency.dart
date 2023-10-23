String formatCurrency(double value) {
  final valueFormatted = value.toStringAsFixed(2).replaceAll(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        ',',
      );

  return "\$$valueFormatted";
}
