import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/components/category_widget/kids_category_dialog/kids_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/shoes_category_dialog/shoes_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/sizes_page/sizes_page.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:vibration/vibration.dart';

import '../../pages/products-category/products-category.dart';
import '../../services/custom_icons/custom_icons.dart';

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

class CategoryWidget extends StatefulWidget {
  final image, name, main_category, CateIcon, CateImage;
  bool setBorder;
  CategoryWidget({
    Key? key,
    required this.setBorder,
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
        } else if (widget.name == "ملابس رياضية") {
          NavigatorFunction(
              context,
              ShowCaseWidget(
                  builder: Builder(
                builder: (context) => ProductsCategories(
                  SIZES: [],
                  category_id: widget.main_category,
                  search: false,
                  size: "",
                  containerWidths: "null",
                  keys: "null",
                  name: widget.name,
                  sizes: "null",
                  main_category: widget.main_category,
                ),
              )));
        } else if (widget.name == "للمنزل") {
          NavigatorFunction(
              context,
              ShowCaseWidget(
                  builder: Builder(
                builder: (context) => ProductsCategories(
                  SIZES: [],
                  category_id: widget.main_category,
                  search: false,
                  size: "",
                  containerWidths: "null",
                  keys: "null",
                  name: widget.name,
                  sizes: "null",
                  main_category: widget.main_category,
                ),
              )));
        } else if (widget.name == "للرضيع و الأم") {
          NavigatorFunction(
              context,
              ShowCaseWidget(
                  builder: Builder(
                builder: (context) => ProductsCategories(
                  SIZES: [],
                  category_id: widget.main_category,
                  search: false,
                  size: "",
                  containerWidths: "null",
                  keys: "null",
                  name: widget.name,
                  sizes: "null",
                  main_category: widget.main_category,
                ),
              )));
        } else if (widget.name == "مجوهرات و ساعات") {
          NavigatorFunction(
              context,
              ShowCaseWidget(
                  builder: Builder(
                builder: (context) => ProductsCategories(
                  SIZES: [],
                  category_id: widget.main_category,
                  search: false,
                  size: "",
                  containerWidths: "null",
                  keys: "null",
                  name: widget.name,
                  sizes: "null",
                  main_category: widget.main_category,
                ),
              )));
        } else if (widget.name == "اكسسوارات") {
          NavigatorFunction(
              context,
              ShowCaseWidget(
                  builder: Builder(
                builder: (context) => ProductsCategories(
                  SIZES: [],
                  category_id: widget.main_category,
                  search: false,
                  size: "",
                  containerWidths: "null",
                  keys: "null",
                  name: widget.name,
                  sizes: "null",
                  main_category: widget.main_category,
                ),
              )));
        } else if (widget.name == "مستحضرات تجميلية") {
          NavigatorFunction(
              context,
              ShowCaseWidget(
                  builder: Builder(
                builder: (context) => ProductsCategories(
                  SIZES: [],
                  category_id: widget.main_category,
                  search: false,
                  size: "",
                  containerWidths: "null",
                  keys: "null",
                  name: widget.name,
                  sizes: "null",
                  main_category: widget.main_category,
                ),
              )));
        } else if (widget.name == "الكترونيات") {
          NavigatorFunction(
              context,
              ShowCaseWidget(
                  builder: Builder(
                builder: (context) => ProductsCategories(
                  SIZES: [],
                  category_id: widget.main_category,
                  search: false,
                  size: "",
                  containerWidths: "null",
                  keys: "null",
                  name: widget.name,
                  sizes: "null",
                  main_category: widget.main_category,
                ),
              )));
        } else if (widget.name == "حقائب") {
          NavigatorFunction(
              context,
              ShowCaseWidget(
                  builder: Builder(
                builder: (context) => ProductsCategories(
                  SIZES: [],
                  category_id: widget.main_category,
                  search: false,
                  size: "",
                  containerWidths: "null",
                  keys: "null",
                  name: widget.name,
                  sizes: "null",
                  main_category: widget.main_category,
                ),
              )));
        } else if (widget.name == "للحيوانات الاليفة") {
          NavigatorFunction(
              context,
              ShowCaseWidget(
                  builder: Builder(
                builder: (context) => ProductsCategories(
                  SIZES: [],
                  category_id: widget.main_category,
                  search: false,
                  size: "",
                  containerWidths: "null",
                  keys: "null",
                  name: widget.name,
                  sizes: "null",
                  main_category: widget.main_category,
                ),
              )));
        } else if (widget.name == "مستلزمات سيارات") {
          NavigatorFunction(
              context,
              ShowCaseWidget(
                  builder: Builder(
                builder: (context) => ProductsCategories(
                  SIZES: [],
                  category_id: widget.main_category,
                  search: false,
                  size: "",
                  containerWidths: "null",
                  keys: "null",
                  name: widget.name,
                  sizes: "null",
                  main_category: widget.main_category,
                ),
              )));
        } else if (widget.name == "قرطاسية ومكاتب") {
          NavigatorFunction(
              context,
              ShowCaseWidget(
                  builder: Builder(
                builder: (context) => ProductsCategories(
                  SIZES: [],
                  category_id: widget.main_category,
                  search: false,
                  size: "",
                  containerWidths: "null",
                  keys: "null",
                  name: widget.name,
                  sizes: "null",
                  main_category: widget.main_category,
                ),
              )));
        } else {
          Map sizes = {};
          if (widget.name == "ملابس نسائيه") {
            sizes = LocalStorage().getSize("womenSizes");
          } else if (widget.name == "ملابس رجاليه") {
            sizes = LocalStorage().getSize("menSizes");
          } else if (widget.name == "مقاسات كبيرة") {
            sizes = LocalStorage().getSize("womenPlusSizes");
          } else if (widget.name == "مستلزمات اعراس") {
            sizes = LocalStorage().getSize("Weddings & Events");
          } else if (widget.name == "ملابس داخليه") {
            sizes = LocalStorage().getSize("Underwear_Sleepwear_sizes");
          }

          var keys = sizes.keys.toList();

          double gridViewHeight = calculateGridViewHeight(keys.length);
          // Calculate the widths for each Container
          List<double> containerWidths = keys
              .map((text) =>
                  getTextWidth(text, TextStyle(fontWeight: FontWeight.bold)) +
                  120.0)
              .toList();
          NavigatorFunction(
              context,
              SizesPage(
                sizes: sizes,
                main_category: widget.main_category,
                name: widget.name,
                containerWidths: containerWidths,
                keys: keys,
              ));
        }
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.setBorder
                      ? Color.fromARGB(255, 79, 231, 9)
                      : Colors.transparent,
                  width: widget.setBorder ? 2 : 0),
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10),
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
              borderRadius: BorderRadius.circular(10),
              color: Color(0x80000000),
            ),
            child: Center(
              child: Text(
                widget.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
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
