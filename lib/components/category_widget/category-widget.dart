import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/components/category_widget/kids_category_dialog/kids_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/shoes_category_dialog/shoes_category_dialog.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:vibration/vibration.dart';

import '../../pages/products-category/products-category.dart';
import '../../services/custom_icons/custom_icons.dart';

class CategoryWidget extends StatefulWidget {
  final image, name, main_category, CateIcon, CateImage;
  CategoryWidget({
    Key? key,
    required this.name,
    required this.image,
    required this.CateImage,
    required this.main_category,
    required this.CateIcon,
  }) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Map sizes = {};

  setSizesArray() {
    if (widget.name == "ملابس نسائيه") {
      sizes = LocalStorage().getSize("womenSizes");
    } else if (widget.name == "ملابس رجاليه") {
      sizes = LocalStorage().getSize("menSizes");
    } else if (widget.name == "ملابس أطفال") {
      sizes = LocalStorage().getSize("kidsboysSizes");
    } else {
      sizes = LocalStorage().getSize("womenSizes");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setSizesArray();
  }

  getSizesAndShow() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var keys = sizes.keys.toList();

        double gridViewHeight = calculateGridViewHeight(keys.length);
        // Calculate the widths for each Container
        List<double> containerWidths = keys
            .map((text) =>
                getTextWidth(text, TextStyle(fontWeight: FontWeight.bold)) +
                32.0)
            .toList();
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'لتجربة أفضل, الرجاء اختيار الحجم',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: Container(
              height: gridViewHeight + 150,
              child: Column(
                children: [
                  Wrap(
                    spacing: 15.0, // gap between adjacent chips
                    runSpacing: 15.0, // gap between lines
                    children: <Widget>[
                      for (int index = 0; index < keys.length; index++)
                        InkWell(
                          onTap: () {
                            Vibration.vibrate(duration: 300);
                            setState(() {
                              sizes[keys[index]] = !sizes[keys[index]];
                            });
                          },
                          child: Container(
                            width: containerWidths[
                                index], // Use the calculated width
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                ),
                              ],
                              color: sizes[keys[index]]
                                  ? Colors.black
                                  : Colors.white,

                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the border radius
                            ),
                            height: sizes[keys[index]] ? 50 : 40,
                            child: Center(
                              child: Text(
                                keys[index],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: sizes[keys[index]]
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonWidget(
                          name: "حفظ",
                          height: 40,
                          width: 120,
                          BorderColor: Colors.black,
                          OnClickFunction: () async {
                            if (widget.name == "ملابس نسائيه") {
                              LocalStorage().editSize("menSizes", sizes);
                            } else if (widget.name == "ملابس رجاليه") {
                              LocalStorage().editSize("menSizes", sizes);
                            } else if (widget.name == "ملابس أطفال") {
                              LocalStorage().editSize("kidsboysSizes", sizes);
                            } else {
                              LocalStorage().editSize("womenSizes", sizes);
                            }
                            String sizeApi = "";
                            List sizeApp = [];

                            sizes.keys.forEach((k) {
                              if (sizes[k]) {
                                sizeApi = sizeApi + k;
                                sizeApp.add(k.split(' ')[0]);
                              }
                            });
                            LocalStorage().setSizeUser(sizeApp);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('is_selected_size', true);
                            NavigatorFunction(
                                context,
                                ProductsCategories(
                                  category_id: widget.main_category,
                                  size: sizeApp.join(', '),
                                ));
                          },
                          BorderRaduis: 10,
                          ButtonColor: MAIN_COLOR,
                          NameColor: Colors.white,
                        ),
                        ButtonWidget(
                          name: "تخطي",
                          height: 40,
                          width: 120,
                          BorderColor: Colors.black,
                          OnClickFunction: () async {
                            LocalStorage().setSizeUser([]);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('is_selected_size', false);
                            NavigatorFunction(
                                context,
                                ProductsCategories(
                                  category_id: widget.main_category,
                                  size: "null",
                                ));
                          },
                          BorderRaduis: 10,
                          ButtonColor: MAIN_COLOR,
                          NameColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  double calculateGridViewHeight(int itemCount) {
    final double itemHeight = 30.0; // Height of each item
    final int itemsPerRow = 3; // Number of items per row
    final int rowCount = (itemCount / itemsPerRow).ceil();
    final double gridHeight = itemHeight * rowCount;
    final double spacingHeight = 30.0 * (rowCount - 1); // Adjust for spacing
    return gridHeight + spacingHeight;
  }

  double getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool All = false;
        bool Women = false;
        bool Men = false;
        bool Kids = false;
        if (widget.name == "الأحذيه") {
          NavigatorFunction(context, ShoesCategoryDialog());
        } else if (widget.name == "ملابس أطفال") {
          NavigatorFunction(context, KidsCategoryDialog());
        } else {
          getSizesAndShow();
        }
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  widget.image,
                ).image,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0x80000000),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      widget.CateImage,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 180,
                      child: Center(
                        child: Text(
                          widget.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.name.length >= 13 ? 16 : 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> selectedSizes = [];

  Widget sizeMethod({String size = "", int index = 0}) {
    final isSelected = selectedSizes.contains(size);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedSizes.remove(size);
            } else {
              selectedSizes.add(size);
            }
          });
        },
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              size,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}
