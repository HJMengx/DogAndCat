class CatUrl {
  // Headers
  static Map<String, String> apiKey = {
    "x-api-key": "d3c68bc6-79fc-4aa7-9696-dc9c7faac7a2"
  };

  // 基础 URL
  static const String BaseUrl = "https://api.thecatapi.com";

  // 翻页查询
  static const String PageUrl = "/v1/images/search?order=Desc&limit=10&page=1";

  static String buildCatPageUrl(int limit, int page) {
    return
        "/v1/images/search?order=Desc&" +
        "limit=$limit&" +
        "page=$page";
  }

  // 获取所有的种类
  static const String BreedUrl = "/v1/breeds";

  // 根据指定品种搜索
  static String buildCatSearchWithBreed(String breed, int page, int limit) {
    return
        "/v1/images/search?breed_ids=" +
        breed +
        "&page=$page&limit=$limit";
  }

  // 获取所有的品种
  static const String GetAllCategories = "/v1/categories";

  // 分品种查询
  // https://api.thecatapi.com/v1/images/search?category_ids=1
  static const String CategoriesUrl = "/com/v1/images/search?category_ids=";

  static String buildCatCategorySearch(String id, int page, int limit) {
    return
        CatUrl.CategoriesUrl +
        "&page=$page&limit=$limit" +
        id;
  }

  // 根据文件类型查询
  /**
   * gif - animated
   * jpg - static
   * png - static
   */
  static const String FileTypeUrl = "/v1/images/search?mime_types=";

  /** 构建获取指定图片类型所有图片, 在多个类型中搜索需要使用,分隔 */
  static String buildCatImgTypeUrl(String type) {
    return CatUrl.FileTypeUrl + type;
  }
}

class DogUrl {
  // 基础 URL
  static const String baseURL = "https://dog.ceo";

  // 获取所有的种类
  static const String AllBreeds = "/api/breeds/list/all";

  // 随机获取一张
  static const String GetOneDog = "/api/breeds/image/random";

  // 通过种类搜索
  // hound/images
  static const String GetDogWithBreeds = "/api/breed/";

  static String buildGetDogWithBreeds(String breed) {
    return DogUrl.GetDogWithBreeds + breed + "/images";
  }

  // 子种类
  // hound/list"
  static const String GetDogsWithSubBreeds = "/api/breed/";

  static String buildGetDogsWithSubBreeds(String breed) {
    return DogUrl.GetDogWithBreeds + breed + "/list";
  }

  // 获取种类的随机图
  static const String GetDogWithBreed = "/api/breed/";
  static const String GetDogWithBreedAfter = "/images/random";

  static String buildGetDogWithBreed(String breed) {
    return DogUrl.GetDogWithBreed + breed + DogUrl.GetDogWithBreedAfter;
  }
}
