import 'gank.dart';

/// 某个日期网站数据
class DailyInfo extends Gank<Map<String, dynamic>> {
  List<String> category;

  DailyInfo.fromJson(Map<String, dynamic> json) {
    category = json['category'].cast<String>();
    status = json['status'];
    results = json['data'] != null ? json['data'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['status'] = this.status;
    if (this.results != null) {
      data['data'] = this.results;
    }
    return data;
  }
}
