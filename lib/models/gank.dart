class Gank<T> {
  T results;
  bool error;

  @override
  String toString() {
    return '{"error": $error,"/n results": $results';
  }
}
