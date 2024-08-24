import 'package:csv/csv.dart';
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
    'نابلس': [5, 972, 1152]
  };

  List<City> loadCities() {
    return cityInfo.entries
        .map((entry) => City(
            name: entry.key,
            id: entry.value[0],
            startIndex: entry.value[1],
            endIndex: entry.value[2]))
        .toList();
  }

  Future<List<Area>> loadAreasFromCsv(City city) async {
    final data = await rootBundle.loadString('assets/pdfs/Cities&Areas.csv');
    final rows = const CsvToListConverter().convert(data);
    List<Area> areas = [];
    for (int i = city.startIndex; i <= city.endIndex; i++) {
      // Ensure the conversion to the expected types.
      String name = rows[i][0].toString(); // Convert to String if not already
      int id = int.parse(rows[i][1].toString()); // Convert to int safely

      areas.add(Area(name: name, id: id, cityId: city.id));
    }
    return areas;
  }
}
