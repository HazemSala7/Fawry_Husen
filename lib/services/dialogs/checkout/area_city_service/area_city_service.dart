import 'package:fawri_app_refactor/model/Area/area.dart';
import 'package:fawri_app_refactor/model/City/city.dart';
import 'package:flutter/services.dart' show rootBundle;

class CityService {
  final Map<String, List<int>> cityInfo = {
    'أريحا': [8, 2, 13],
    'الخليل': [3, 14, 163],
    'القدس': [11, 164, 235],
    'بيت لحم': [4, 236, 304],
    'جنين': [2, 305, 422],
    'رام الله': [1, 423, 559],
    'سلفيت': [10, 560, 580],
    'طوباس': [7, 581, 598],
    'طولكرم': [6, 599, 644],
    'القدس الشرقية': [12, 645, 687],
    'قلقيلة': [9, 688, 722],
    'مناطق الداخل': [13, 723, 971],
    'نابلس': [5, 972, 1152],
  };

  final Map<String, String> cityTranslations = {
    'أريحا': 'Jericho',
    'الخليل': 'Hebron',
    'القدس': 'Quds',
    'بيت لحم': 'beitlahm',
    'جنين': 'Jenin',
    'رام الله': 'Ramallah',
    'سلفيت': 'Salfit',
    'طوباس': 'Tubas',
    'طولكرم': 'Tulkarem',
    'القدس الشرقية': 'QudsV',
    'قلقيلة': 'Qaliqilya',
    'مناطق الداخل': 'Manateq',
    'نابلس': 'Nablus',
  };

  List<City> loadCities() {
    return cityInfo.entries
        .map((entry) => City(
            name: entry.key,
            translatedName:
                cityTranslations[entry.key] ?? entry.key, // Add translation
            id: entry.value[0],
            startIndex: entry.value[1],
            endIndex: entry.value[2]))
        .toList();
  }

  Future<List<Area>> loadAreasFromCsv(City city) async {
    final data = await rootBundle.loadString('assets/pdfs/Cities&Areas.csv');

    // Split the data manually to ensure it captures all rows
    final List<List<dynamic>> rows =
        data.split('\n').map((line) => line.split(',')).toList();

    if (rows.isEmpty || rows.length < 2)
      return []; // Return empty if not enough data

    List<Area> areas = [];

    int newStartIndex = city.startIndex < rows.length ? city.startIndex : 0;
    int newEndIndex =
        city.endIndex < rows.length ? city.endIndex : rows.length - 1;

    // Iterate through the specified rows
    for (int i = newStartIndex; i <= newEndIndex; i++) {
      if (i < rows.length) {
        if (rows[i].length >= 2) {
          String name = rows[i][0].toString().trim(); // Trim whitespace
          int id = int.tryParse(rows[i][1].toString()) ?? 0;

          areas.add(Area(name: name, id: id, cityId: city.id));
        } else {
          print('Row $i is missing data: ${rows[i]}');
        }
      }
    }

    return areas;
  }
}
