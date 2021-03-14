class CompareResult {
  final bool success;
  final List<String> messages;
  final int changedLines;

  CompareResult(this.success, this.messages, this.changedLines);
}
