abstract class APIService {
  static const baseUrl = "https://gank.io/api/v2/";

  static String getGirlList(int index, int count) {
    return "data/category/Girl/type/Girl/page/$index/count/$count";
  }

  static String getListData(String type, int count, int pageIndex) {
    if (type == "app") {
      return "data/category/GanHuo/type/$type/page/$pageIndex/count/$count";
    } else {
      return "data/category/Article/type/$type/page/$pageIndex/count/$count";
    }
  }

  static const getHot = "hot/likes/category/GanHuo/count/10";

  static const getBanners = "banners";

}
