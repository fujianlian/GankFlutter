import 'gank.dart';

/// 某个日期网站数据
class DailyInfo extends Gank<Map<String, dynamic>> {
  List<String> category;

  DailyInfo.fromJson(Map<String, dynamic> json) {
    category = json['category'].cast<String>();
    results = json['data'] != null ? json['data'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    if (this.results != null) {
      data['data'] = this.results;
    }
    return data;
  }
}
