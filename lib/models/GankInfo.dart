import 'dart:convert' show json;

class GankInfo {

  String id;
  String author;
  String category;
  String content;
  String createdAt;
  String desc;
  int likeCounts;
  String publishedAt;
  int stars;
  String title;
  String type;
  String url;
  int views;
  List<String> images;

  GankInfo.fromParams(
      {
      this.id,
      this.author,
      this.category,
      this.content,
      this.createdAt,
      this.desc,
      this.likeCounts,
      this.publishedAt,
      this.stars,
      this.title,
      this.type,
      this.url,
      this.views,
      this.images});

  GankInfo.fromJson(jsonRes) {
    id = jsonRes['_id'];
    author = jsonRes['author'];
    category = jsonRes['category'];
    content = jsonRes['content'];
    createdAt = jsonRes['createdAt'];
    desc = jsonRes['desc'];
    likeCounts = jsonRes['likeCounts'];
    publishedAt = jsonRes['publishedAt'];
    stars = jsonRes['stars'];
    title = jsonRes['title'];
    type = jsonRes['type'];
    url = jsonRes['url'];
    views = jsonRes['views'];
    images = jsonRes['images'] == null ? null : [];

    for (var imagesItem in images == null ? [] : jsonRes['images']) {
      images.add(imagesItem);
    }
  }

  @override
  String toString() {
    return json.toString();
  }
}