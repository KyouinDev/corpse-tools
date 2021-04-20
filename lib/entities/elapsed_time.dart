class ElapsedTime {
  final DateTime start;

  ElapsedTime() : start = DateTime.now();

  void end() {
    var elapsed = DateTime.now().difference(start);
    print('Elapsed time: ${elapsed.inMilliseconds} ms.');
  }
}
