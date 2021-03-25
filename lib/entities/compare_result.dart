class CompareResult {
  final bool success;
  final List<String> messages;
  final int changedLines;

  CompareResult({
    required this.success,
    required this.messages,
    required this.changedLines,
  });
}
