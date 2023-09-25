import 'package:hive_flutter/hive_flutter.dart';
import 'package:fawri_app_refactor/LocalDB/Models/FavoriteItem.dart';

class LocalStorage {
  static LocalStorage instance = LocalStorage._();
  LocalStorage._();
  factory LocalStorage() {
    return instance;
  }
  late final favoriteDataBox;
  late final sizeDataBox;

  Future<void> initHive() async {
    await Hive.initFlutter();
    favoriteDataBox = await Hive.openBox('favoriteData');
    sizeDataBox = await Hive.openBox('sizeData');
    setSize();
  }

//user images
  void setFavorite(FavoriteItem item) async {
    List data = favorites;
    data.add(item.toJson());
    favoriteDataBox.put('favorites', data);
    print(favorites);
    print("favorites");
  }

  List<String> Men_sizes = [
    "XS 👔",
    "S 👖",
    "M 👖",
    "L 👖",
    "XL 🧥",
    "XXL 👔",
    "XXXL 👔",
    "0XL 👖",
    "1XL 👖",
    "2XL 👕",
    "3XL 👖",
    "4XL 👕",
    "5XL 👖",
    "6XL 👕",
  ];
  List<String> women__sizes = [
    "XXS 👚",
    "XS 👗",
    "S 🩱",
    "M 🩱",
    "L 🩱",
    "XL 🩱",
    "XXL 👘",
    "XXXL 🧥",
    "ONE SIZE 👘",
  ];
  var women_Plus_sizes = ["0XL", "1XL", "2XL", "3XL", "4XL", "5XL"];
  List<String> kids_boys_sizes = [
    "6-9 شهر",
    "9-12 شهر",
    "S"
        "2سنة",
    "2-3سنة",
    "3سنة",
    "4سنة",
    "5سنة",
    "5-6سنة",
    "6سنة",
    "7سنة",
    "8 سنة",
    "9 سنة",
    "10 سنة",
    "9-10 سنة",
    "11-12 سنة",
    "12 سنة",
    "12-13 سنة",
    "13-14 سنة",
  ];

  void setSize() async {
    sizeDataBox.put('menSizes', {
      "XS 👔": false,
      "S 👖": false,
      "M 👖": false,
      "L 👖": false,
      "XL 🧥": false,
      "XXL 👔": false,
      "XXXL 👔": false,
      "0XL 👖": false,
      "1XL 👖": false,
      "2XL 👕": false,
      "3XL 👖": false,
      "4XL 👕": false,
      "5XL 👖": false,
      "6XL 👕": false,
    });
    sizeDataBox.put('womenSizes', {
      "XXS 👚": false,
      "XS 👗": false,
      "S 🩱": false,
      "M 🩱": false,
      "L 🩱": false,
      "XL 🩱": false,
      "XXL 👘": false,
      "XXXL 🧥": false,
      "ONE SIZE 👘": false,
    });
    sizeDataBox.put('womenPlusSizes', {
      "0XL": false,
      "1XL": false,
      "2XL": false,
      "3XL": false,
      "4XL": false,
      "5XL": false
    });
    sizeDataBox.put('kidsboysSizes', {
      "0XL": false,
      "1XL": false,
      "2XL": false,
      "3XL": false,
      "4XL": false,
      "5XL": false,
    });
  }

  void editSize(key, v) async {
    sizeDataBox.put(key, v);
  }

  getSize(type) {
    if (type == "menSizes") {
      return sizeDataBox.get('menSizes', defaultValue: []);
    }
    if (type == "womenSizes") {
      return sizeDataBox.get('womenSizes', defaultValue: []);
    }
    if (type == "womenPlusSizes") {
      return sizeDataBox.get('womenPlusSizes', defaultValue: []);
    }
    if (type == "kidsboysSizes") {
      return sizeDataBox.get('kidsboysSizes', defaultValue: []);
    }
  }

  setSizeUser(data) {
    sizeDataBox.put('sizeUser', data);
  }

  void deleteFavorite(String id) async {
    List data = favorites;
    for (int i = 0; i < data.length; i++) {
      if (data[i]["id"].toString() == id.toString()) {
        data.removeAt(i);
      }
    }
    favoriteDataBox.put('favorites', data);
  }

  isFavorite(String id) {
    bool favorite = false;
    for (int i = 0; i < favorites.length; i++) {
      if (favorites[i]["id"].toString() == id.toString()) {
        favorite = true;
      }
    }
    return favorite;
  }

  List getFavorites() {
    List data = favoriteDataBox.get('favorites', defaultValue: []);
    return data;
  }

  List<dynamic> get favorites =>
      favoriteDataBox.get('favorites', defaultValue: []);
  List get sizeUser => sizeDataBox.get('sizeUser', defaultValue: []);
}
