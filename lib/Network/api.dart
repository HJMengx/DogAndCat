import 'http_request.dart';
import 'package:mxanimal/models/dog.dart';
import 'package:mxanimal/models/cat.dart';
import 'url.dart';

class DogApi {
  // 创建一个公共的请求管理器
  static HttpRequest httpManager = HttpRequest(DogUrl.baseURL);

  // 获取一张随机的图片
  static Future<dynamic> getRandomDog() async {
    var response = await httpManager.get(DogUrl.GetOneDog);
    SingleDogImgForBreed dog = SingleDogImgForBreed.loadFromJson(response);
    return dog;
  }

  // 获取所有的品种
  static Future<dynamic> getAllBreeds() async {
    var response = await httpManager.get(DogUrl.AllBreeds);
    return AllBreeds.loadFromJson(response);
  }

  // 获取种类的随机图
  static Future<dynamic> getRandomImageWithBreed(String breed) async {
    var response = await httpManager.get(DogUrl.buildGetDogWithBreed(breed));
    return SingleDogImgForBreed.loadFromJson(response);
  }

  // 子种类
  static Future<dynamic> getSubBreed(String breed) async {
    var response =
        await httpManager.get(DogUrl.buildGetDogsWithSubBreeds(breed));
    return DogSubBreedsInBreed.loadFromJson(response);
  }

  /** 获取一个种类的所有图片 */
  static Future<dynamic> getImageWithBreed(String breed) async {
    var response = await httpManager.get(DogUrl.buildGetDogWithBreeds(breed));
    return DogImageForIndicateBreed.loadFromJson(response);
  }
}

class CatApi {
  // 创建一个公共的请求管理器
  static HttpRequest httpManager = HttpRequest(CatUrl.BaseUrl);

  /** 获取随机一张图片 */
  static Future<dynamic> getRandomImage() async {
    var response =
        await httpManager.get(CatUrl.buildCatImgTypeUrl("gif,png,jpg"));
    return CatImage.loadFromJson(response);
  }

  /** 获取所有的种类 */
  static Future<dynamic> getAllCategories() async {
    var response = await httpManager.get(CatUrl.GetAllCategories);
    return CatCategory.getCategories(response);
  }

  /** 获取所有的品种 */
  static Future<dynamic> getAllBreeds() async {
    var response = await httpManager.get(CatUrl.BreedUrl);
    return CatBreed.getBreeds(response);
  }

  /** 分页查询 */
  static Future<dynamic> getCatImgsWithPage(int limit, int page) async {
    var response = await httpManager.get(CatUrl.buildCatPageUrl(limit, page));
    return CatImage.getPageCatImgs(response);
  }

  /** 获取某一个品种的所有 */
  static Future<dynamic> getCatImageWithCategory(
      String category, int page, int limit) async {
    var response = await httpManager
        .get(CatUrl.buildCatCategorySearch(category, page, limit));
    // To Model
    return CatDivide.loadFromJson(response);
  }

  /** 获取某一个种类的所有 */
  static Future<dynamic> getCatImageWithBreed(String breed, int page, int limit) async {
    var response = await httpManager
        .get(CatUrl.buildCatSearchWithBreed(breed, page, limit));
    // To Model
    return CatDivide.loadFromJson(response);
  }
}
