class Gank<T> {
  T results;
  int page;
  int page_count;
  int status;
  int total_counts;
  
  @override
  String toString() {
    return '{"status": $status,"/n results": $results';
  }
}
