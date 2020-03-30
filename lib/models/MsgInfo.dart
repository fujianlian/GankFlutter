import 'gank.dart';

class MsgInfo extends Gank<String> {
  String msg;

  MsgInfo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}
