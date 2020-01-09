import 'gank.dart';

class MsgInfo extends Gank<String> {
  String msg;

  MsgInfo.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['msg'] = this.msg;
    return data;
  }
}
