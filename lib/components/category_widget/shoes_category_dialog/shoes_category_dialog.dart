import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:flutter/material.dart';

import '../../../LocalDB/Database/local_storage.dart';
import '../../../constants/constants.dart';
import '../../../pages/products-category/products-category.dart';
import '../../../server/functions/functions.dart';
import '../sizes_page/sizes_page.dart';

class ShoesCategoryDialog extends StatefulWidget {
  ShoesCategoryDialog({super.key});

  @override
  State<ShoesCategoryDialog> createState() => _ShoesCategoryDialogState();
}

class _ShoesCategoryDialogState extends State<ShoesCategoryDialog> {
  @override
  List<CategoryItem> categoryItems = [
    CategoryItem(name: "أحذية الستاتية", image: "assets/images/heel.png"),
    CategoryItem(
        name: "أحذية رجالية",
        image: "assets/images/icons8-climbing-shoes-100.png"),
    CategoryItem(
        name: "أحذية أطفال", image: "assets/images/icons8-sneaker-64.png"),
    CategoryItem(
        name: "الجميع", image: "assets/images/icons8-select-all-100.png"),
  ];
  bool isAnyItemSelected = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: MAIN_COLOR,
          centerTitle: true,
          title: Text(
            "فوري",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              )),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/for-shoes.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color(0xffEDF5F7).withOpacity(0.1),
            BlendMode.dstATop,
          ),
        )),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int index = 0; index < categoryItems.length; index++)
                  categoryMethodForShoes(
                    name: categoryItems[index].name,
                    image: categoryItems[index].image,
                    isSelected: categoryItems[index].isSelected,
                    onTaped: () {
                      setState(() {
                        if (categoryItems[index].name == "الجميع") {
                          NavigatorFunction(
                              context,
                              ProductsCategories(
                                search: false,
                                category_id: "Shoes,Kids",
                                size: "",
                                containerWidths: "",
                                main_category: "Shoes,Kids",
                                keys: "",
                                sizes: "",
                                name: "",
                              ));
                        } else {
                          categoryItems[index].isSelected =
                              !categoryItems[index].isSelected;
                          // Check if any button is selected
                          isAnyItemSelected =
                              categoryItems.any((item) => item.isSelected);
                        }
                      });
                    },
                  ),
                if (isAnyItemSelected)
                  ButtonWidget(
                    name: "التالي",
                    height: 50,
                    width: 200,
                    BorderColor: MAIN_COLOR,
                    OnClickFunction: () {
                      Map sizes = {};
                      String Main_Category = "";
                      if (categoryItems[0].isSelected) {
                        sizes = LocalStorage().getSize("Women_shoes_sizes");
                        Main_Category = "Women Shoes";
                      } else if (categoryItems[1].isSelected) {
                        sizes = LocalStorage().getSize("Men_shoes_sizes");
                        Main_Category = "Men Shoes";
                      } else if (categoryItems[2].isSelected) {
                        sizes = LocalStorage().getSize("Kids_shoes_sizes");
                        Main_Category = "Kids Shoes";
                      } else {
                        sizes = {};
                        Main_Category = "all";
                      }
                      var keys = sizes.keys.toList();

                      double gridViewHeight =
                          calculateGridViewHeight(keys.length);
                      List<double> containerWidths = keys
                          .map((text) =>
                              getTextWidth(text,
                                  TextStyle(fontWeight: FontWeight.bold)) +
                              100.0)
                          .toList();
                      NavigatorFunction(
                          context,
                          SizesPage(
                            sizes: sizes,
                            main_category: Main_Category,
                            name: "الأحذيه",
                            containerWidths: containerWidths,
                            keys: keys,
                          ));
                    },
                    BorderRaduis: 40,
                    ButtonColor: MAIN_COLOR,
                    NameColor: Colors.white,
                  ),
                Text(
                  "تخطي الأن",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87),
                )
              ],
            ),
          ),
        ),
      ),
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

  Widget categoryMethodForShoes(
      {String image = "",
      String name = "",
      Function? onTaped,
      required bool isSelected}) {
    return InkWell(
      onTap: () {
        onTaped!();
      },
      child: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 7,
              blurRadius: 5,
            ),
          ],
          borderRadius: BorderRadius.circular(40),
          color: isSelected ? Colors.black : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              isSelected ? "assets/images/icons8-correct-100.png" : image,
              height: 20,
              width: 20,
            ),
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: isSelected ? Colors.white : Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  final String image;
  final String name;
  bool isSelected;

  CategoryItem({
    required this.image,
    required this.name,
    this.isSelected = false,
  });
}
