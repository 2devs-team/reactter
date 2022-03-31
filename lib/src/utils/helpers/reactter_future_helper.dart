library reactter;

/// Returns a future with delay of [ms] given.
Future<void> delay(int ms) async {
  return await Future.delayed(Duration(milliseconds: ms));
}
