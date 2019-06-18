/** 获取所有的种类 */
class AllBreeds {
  List<String> names;

  AllBreeds.loadFromJson(Map json) {
    if (json.containsKey("message")) {
      if (this.names == null) {
        this.names = new List<String>();
      }
      for(var name in json["message"].keys) {
        this.names.add(name);
      }
    }
  }

  @override
  String toString() {
    return '{"AllBreeds-names": $names}';
  }
}

/** 获取某一个种类的图片 */
class DogImageForIndicateBreed {
  List<String> imgs;
  DogImageForIndicateBreed.loadFromJson(Map json) {
    if (json.containsKey("message")) {
      if (this.imgs == null) {
        this.imgs = new List<String>();
      }
      for(var name in json["message"]) {
        this.imgs.add(name);
      }
    }
  }
  @override
  String toString() {
    return '{"DogImageForIndicateBreed-imgs": $imgs}';
  }
}

/** 获取某一个种类的子种类 */
class DogSubBreedsInBreed {
  List<String> breeds;
  DogSubBreedsInBreed.loadFromJson(Map json) {
    if (json.containsKey("message")) {
      if (this.breeds == null) {
        this.breeds = new List<String>();
      }
      for(var name in json["message"]) {
        this.breeds.add(name);
      }
    }
  }
  @override
  String toString() {
    return '{"DogSubBreedsInBreed-breeds": $breeds}';
  }
}

/** 随机获取某一个种类的一张图片 */
class SingleDogImgForBreed {
  String img;
  SingleDogImgForBreed.loadFromJson(Map json) {
    if (json.containsKey("message")) {
      this.img = json["message"];
    }
  }
  @override
  String toString() {
    return '{"SingleDogImgForBreed-img": $img}';
  }
}
/**
 *
 * [
    {
    "breeds": [
    {
    "weight": {
    "imperial": "6 - 12",
    "metric": "3 - 5"
    },
    "id": "sphy",
    "name": "Sphynx",
    "cfa_url": "http://cfa.org/Breeds/BreedsSthruT/Sphynx.aspx",
    "vetstreet_url": "http://www.vetstreet.com/cats/sphynx",
    "vcahospitals_url": "https://vcahospitals.com/know-your-pet/cat-breeds/sphynx",
    "temperament": "Loyal, Inquisitive, Friendly, Quiet, Gentle",
    "origin": "Canada",
    "country_codes": "CA",
    "country_code": "CA",
    "description": "The Sphynx is an intelligent, inquisitive, extremely friendly people-oriented breed. Sphynx commonly greet their owners  at the front door, with obvious excitement and happiness. She has an unexpected sense of humor that is often at odds with her dour expression.",
    "life_span": "12 - 14",
    "indoor": 0,
    "lap": 1,
    "alt_names": "Canadian Hairless, Canadian Sphynx",
    "adaptability": 5,
    "affection_level": 5,
    "child_friendly": 4,
    "dog_friendly": 5,
    "energy_level": 3,
    "grooming": 2,
    "health_issues": 4,
    "intelligence": 5,
    "shedding_level": 1,
    "social_needs": 5,
    "stranger_friendly": 5,
    "vocalisation": 5,
    "experimental": 0,
    "hairless": 1,
    "natural": 0,
    "rare": 1,
    "rex": 0,
    "suppressed_tail": 0,
    "short_legs": 0,
    "wikipedia_url": "https://en.wikipedia.org/wiki/Sphynx_(cat)",
    "hypoallergenic": 1
    }
    ],
    "id": "bSu2exlkB",
    "url": "https://cdn2.thecatapi.com/images/bSu2exlkB.jpg",
    "width": 2380,
    "height": 2462
    }
    ]
 */
