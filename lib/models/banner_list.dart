import 'dart:convert' show json;

class BannerInfo {

  String image;
  String title;
  String url;

  BannerInfo.fromParams(
      {
      this.image,
      this.title,
      this.url});

  BannerInfo.fromJson(jsonRes) {
    image = jsonRes['image'];
    title = jsonRes['title'];
    url = jsonRes['url'];
  }

  @override
  String toString() {
    return json.toString();
  }
}