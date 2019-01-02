import 'dart:convert' show json;

class GankInfo {

  bool error;
  List<Results> results;

  GankInfo.fromParams({this.error, this.results});

  factory GankInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new GankInfo.fromJson(json.decode(jsonStr)) : new GankInfo.fromJson(jsonStr);

  GankInfo.fromJson(jsonRes) {
    error = jsonRes['error'];
    results = jsonRes['results'] == null ? null : [];

    for (var resultsItem in results == null ? [] : jsonRes['results']){
      results.add(resultsItem == null ? null : new Results.fromJson(resultsItem));
    }
  }

  @override
  String toString() {
    return '{"error": $error,"results": $results}';
  }
}

class Results {

  bool used;
  String id;
  String createdAt;
  String desc;
  String publishedAt;
  String source;
  String type;
  String url;
  String who;
  List<String> images;

  Results.fromParams({this.used, this.id, this.createdAt, this.desc, this.publishedAt, this.source, this.type, this.url, this.who, this.images});

  Results.fromJson(jsonRes) {
    used = jsonRes['used'];
    id = jsonRes['_id'];
    createdAt = jsonRes['createdAt'];
    desc = jsonRes['desc'];
    publishedAt = jsonRes['publishedAt'];
    source = jsonRes['source'];
    type = jsonRes['type'];
    url = jsonRes['url'];
    who = jsonRes['who'];
    images = jsonRes['images'] == null ? null : [];

    for (var imagesItem in images == null ? [] : jsonRes['images']){
      images.add(imagesItem);
    }
  }

  @override
  String toString() {
    return '{"used": $used,"_id": ${id != null?'${json.encode(id)}':'null'},"createdAt": ${createdAt != null?'${json.encode(createdAt)}':'null'},"desc": ${desc != null?'${json.encode(desc)}':'null'},"publishedAt": ${publishedAt != null?'${json.encode(publishedAt)}':'null'},"source": ${source != null?'${json.encode(source)}':'null'},"type": ${type != null?'${json.encode(type)}':'null'},"url": ${url != null?'${json.encode(url)}':'null'},"who": ${who != null?'${json.encode(who)}':'null'},"images": $images}';
  }
}

