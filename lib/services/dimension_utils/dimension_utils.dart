import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DimensionUtils {
  static const String widthKey = 'card_width';
  static const String heightKey = 'card_height';

  // Calculate and store dimensions
  static Future<void> storeDimensions(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Size screenSize = MediaQuery.of(context).size;
    double cardWidth = (screenSize.width / 2) - 12; // Example calculation
    double cardHeight = cardWidth * 2; // Example aspect ratio

    await prefs.setDouble(widthKey, cardWidth);
    await prefs.setDouble(heightKey, cardHeight);
  }

  // Retrieve stored dimensions
  static Future<Size> getDimensions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double cardWidth = prefs.getDouble(widthKey) ?? 100.0; // default value
    double cardHeight = prefs.getDouble(heightKey) ?? 200.0; // default value

    return Size(cardWidth, cardHeight);
  }
}
