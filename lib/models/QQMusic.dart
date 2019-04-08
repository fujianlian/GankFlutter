class QQMusic {
  int code;
  Data data;

  QQMusic({this.code, this.data});

  QQMusic.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Sliders> slider;

  Data({this.slider});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['slider'] != null) {
      slider = new List<Sliders>();
      json['slider'].forEach((v) {
        slider.add(new Sliders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.slider != null) {
      data['slider'] = this.slider.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sliders {
  String linkUrl;
  String picUrl;
  int id;

  Sliders({this.linkUrl, this.picUrl, this.id});

  Sliders.fromJson(Map<String, dynamic> json) {
    linkUrl = json['linkUrl'];
    picUrl = json['picUrl'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['linkUrl'] = this.linkUrl;
    data['picUrl'] = this.picUrl;
    data['id'] = this.id;
    return data;
  }
}