/** 随机获取一张猫的图片数据返回规则 */
class CatImage {
  String id;
  String url;
  int width;
  int height;
  List<CatBreed> breeds = new List<CatBreed>();

  CatImage.loadFromJson(Map json) {
    // 属性赋值
    if (json.containsKey("id")) {
      this.id = json["id"];
    }
    if (json.containsKey("url")) {
      this.url = json["url"];
    }
    if (json.containsKey("width")) {
      this.width = json["width"];
    }
    if (json.containsKey("height")) {
      this.height = json["height"];
    }
    if (json.containsKey("breeds")) {
      for (var breed in json["breeds"]) {
        this.breeds.add(CatBreed.loadFromJson(breed));
      }
    }
  }

  static List<CatImage> getPageCatImgs(List json) {
    List<CatImage> cats = new List<CatImage>();

    for(var ciJson in json) {
      cats.add(CatImage.loadFromJson(ciJson));
    }
    return cats;
  }
  // 按品种分类
  static List<CatImage> getCatImgsWithBreed(List json) {


  }
  // 按种类分类
  static List<CatImage> getCatImgsWithCategory(List json) {

  }
}
/** 分类查询 */
class CatDivide {
  List<String> urls = new List<String>();
  List<CatBreed> breeds = new List<CatBreed>();

  CatDivide.loadFromJson(List json) {
    for(Map item in json) {
      if(item.containsKey("url")) {
        this.urls.add(item["url"]);
      }
      // 如果添加一个, 就不用继续添加了
      if(item.containsKey("breeds") && this.breeds.length > 0) {
        this.breeds.add(CatBreed.loadFromJson(item["breeds"]));
      }
    }
  }
}
/** Category 的详细信息  */
class CatCategory {
  int id;
  String name;

  CatCategory.loadFromJson(Map json) {
    if(json.containsKey("id")) {
      this.id = json["id"];
    }
    if(json.containsKey("name")) {
      this.name = json["name"];
    }
  }
  // 获取所有 Category
  static List<CatCategory> getCategories(List json) {
    List<CatCategory> categories = new List<CatCategory>();

    for(var cateJson in json) {
      categories.add(CatCategory.loadFromJson(cateJson));
    }

    return categories;
  }
}

/** 种类的详细信息 */
class CatBreed {
  String name;
  String weightImperial;
  String weightMetric;
  String id;
  String cfa_url;
  String vetstreet_url;
  String vcahospitals_url;
  String temperament;
  String description;
  String origin;
  String life_span;
  int indoor;
  int lap;
  String alt_names;
  int adaptability;
  int affection_level;
  int child_friendly;
  int dog_friendly;
  int energy_level;
  int grooming;
  int health_issues;
  int intelligence;
  int shedding_level;
  int social_needs;
  int stranger_friendly;
  int vocalisation;
  int experimental;
  int hairless;
  int natural;
  int rare;
  int rex;
  int suppressed_tail;
  int short_legs;
  String wikipedia_url;
  int hypoallergenic;

  CatBreed.loadFromJson(Map json) {
    if (json.containsKey("name")) {
      this.name = json["name"];
    }
    if (json.containsKey("weight")) {
      if (json.containsKey("imperial")) {
        this.weightImperial = json["weight"]["imperial"];
      }
      if (json.containsKey("metric")) {
        this.weightMetric = json["weight"]["metric"];
      }
    }
    if (json.containsKey("id")) {
      this.id = json["id"];
    }
    if (json.containsKey("cfa_url")) {
      this.cfa_url = json["cfa_url"];
    }
    if (json.containsKey("vetstreet_url")) {
      this.vetstreet_url = json["vetstreet_url"];
    }
    if (json.containsKey("vcahospitals_url")) {
      this.vcahospitals_url = json["vcahospitals_url"];
    }
    if (json.containsKey("temperament")) {
      this.temperament = json["temperament"];
    }
    if (json.containsKey("description")) {
      this.description = json["description"];
    }
    if (json.containsKey("origin")) {
      this.origin = json["origin"];
    }
    if (json.containsKey("life_span")) {
      this.life_span = json["life_span"];
    }
    if (json.containsKey("indoor")) {
      this.indoor = json["indoor"];
    }
    if (json.containsKey("lap")) {
      this.lap = json["lap"];
    }
    if (json.containsKey("alt_names")) {
      this.alt_names = json["alt_names"];
    }
    if (json.containsKey("adaptability")) {
      this.adaptability = json["adaptability"];
    }
    if (json.containsKey("affection_level")) {
      this.affection_level = json["affection_level"];
    }
    if (json.containsKey("child_friendly")) {
      this.child_friendly = json["child_friendly"];
    }
    if (json.containsKey("dog_friendly")) {
      this.dog_friendly = json["dog_friendly"];
    }
    if (json.containsKey("energy_level")) {
      this.energy_level = json["energy_level"];
    }
    if (json.containsKey("grooming")) {
      this.grooming = json["grooming"];
    }
    if (json.containsKey("shedding_level")) {
      this.shedding_level = json["shedding_level"];
    }
    if (json.containsKey("intelligence")) {
      this.intelligence = json["intelligence"];
    }
    if (json.containsKey("social_needs")) {
      this.social_needs = json["social_needs"];
    }
    if (json.containsKey("stranger_friendly")) {
      this.stranger_friendly = json["stranger_friendly"];
    }
    if (json.containsKey("vocalisation")) {
      this.vocalisation = json["vocalisation"];
    }
    if (json.containsKey("experimental")) {
      this.experimental = json["experimental"];
    }
    if (json.containsKey("hairless")) {
      this.hairless = json["hairless"];
    }
    if (json.containsKey("natural")) {
      this.natural = json["natural"];
    }
    if (json.containsKey("rare")) {
      this.rare = json["rare"];
    }
    if (json.containsKey("suppressed_tail")) {
      this.suppressed_tail = json["suppressed_tail"];
    }
    if (json.containsKey("short_legs")) {
      this.short_legs = json["short_legs"];
    }
    if (json.containsKey("wikipedia_url")) {
      this.wikipedia_url = json["wikipedia_url"];
    }
    if (json.containsKey("hypoallergenic")) {
      this.hypoallergenic = json["hypoallergenic"];
    }
  }
  // 获取所有的Breeds
  static List<CatBreed> getBreeds(List json) {
    List<CatBreed> breeds = new List<CatBreed>();

    for(var breedJson in json) {
      breeds.add(CatBreed.loadFromJson(breedJson));
    }

    return breeds;
  }
}
