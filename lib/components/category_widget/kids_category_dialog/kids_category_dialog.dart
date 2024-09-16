import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../LocalDB/Database/local_storage.dart';
import '../../../constants/constants.dart';
import '../../../pages/products-category/products-category.dart';
import '../../../server/functions/functions.dart';
import '../sizes_page/sizes_page.dart';

class KidsCategoryDialog extends StatefulWidget {
  KidsCategoryDialog({super.key});

  @override
  State<KidsCategoryDialog> createState() => _KidsCategoryDialogState();
}

class _KidsCategoryDialogState extends State<KidsCategoryDialog> {
  @override
  List<CategoryItem> categoryItems = [
    CategoryItem(
        name: "قسم الأولاد",
        image: "assets/images/icons8-human-head-96 (1).png"),
    CategoryItem(name: "قسم البنات", image: "assets/images/icons8-girl-96.png"),
    CategoryItem(name: "للأم و الرضيع", image: "assets/images/care.png"),
    CategoryItem(
        name: "كلاهما", image: "assets/images/icons8-select-all-100.png"),
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
          image: AssetImage("assets/images/baby1.png"),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    categoryMethodForShoes(
                      name: categoryItems[0].name,
                      image: categoryItems[0].image,
                      isSelected: categoryItems[0].isSelected,
                      onTaped: () {
                        setState(() {
                          categoryItems[0].isSelected =
                              !categoryItems[0].isSelected;
                          isAnyItemSelected =
                              categoryItems.any((item) => item.isSelected);
                        });
                        Map sizes = {};
                        String Main_Category = "";
                        sizes = LocalStorage().getSize("kidsboysSizes");
                        Main_Category = "Kids Boys";
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
                              name: "قسم الأولاد",
                              containerWidths: containerWidths,
                              keys: keys,
                            ));
                      },
                    ),
                    categoryMethodForShoes(
                      name: categoryItems[1].name,
                      image: categoryItems[1].image,
                      isSelected: categoryItems[1].isSelected,
                      onTaped: () {
                        setState(() {
                          categoryItems[1].isSelected =
                              !categoryItems[1].isSelected;
                          isAnyItemSelected =
                              categoryItems.any((item) => item.isSelected);
                        });
                        Map sizes = {};
                        String Main_Category = "";
                        sizes = LocalStorage().getSize("girls_kids_sizes");
                        Main_Category = "Kids Girls";
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
                              name: "قسم البنات",
                              containerWidths: containerWidths,
                              keys: keys,
                            ));
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: categoryMethodForShoes(
                    name: categoryItems[2].name,
                    image: categoryItems[2].image,
                    isSelected: categoryItems[2].isSelected,
                    onTaped: () {
                      setState(() {
                        categoryItems[2].isSelected =
                            !categoryItems[2].isSelected;
                      });

                      NavigatorFunction(
                          context,
                          ShowCaseWidget(
                              builder: Builder(
                            builder: (context) => ProductsCategories(
                              SIZES: [],
                              category_id: "Women Apparel, Baby",
                              search: false,
                              size: "",
                              containerWidths: "null",
                              main_category: "Women Apparel, Baby",
                              keys: "null",
                              sizes: "null",
                              name: "للرضيع و الأم",
                            ),
                          )));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: categoryMethodForShoes(
                    name: categoryItems[3].name,
                    image: categoryItems[3].image,
                    isSelected: categoryItems[3].isSelected,
                    onTaped: () {
                      setState(() {
                        categoryItems[3].isSelected =
                            !categoryItems[3].isSelected;
                      });

                      NavigatorFunction(
                          context,
                          ShowCaseWidget(
                              builder: Builder(
                            builder: (context) => ProductsCategories(
                              SIZES: [],
                              category_id: "Kids",
                              search: false,
                              size: "",
                              containerWidths: "null",
                              main_category: "Kids",
                              keys: "null",
                              sizes: "null",
                              name: "قسم الأولاد و البنات",
                            ),
                          )));
                    },
                  ),
                ),

                // SizedBox(
                //   height: 30,
                // ),
                // if (isAnyItemSelected)
                //   ButtonWidget(
                //     name: "التالي",
                //     width: 180,
                //     height: 60,
                //     BorderColor: MAIN_COLOR,
                //     OnClickFunction: () {
                //       Map sizes = {};
                //       String Main_Category = "";
                //       if (categoryItems[0].isSelected) {
                //         sizes = LocalStorage().getSize("Women_shoes_sizes");
                //         Main_Category = "Women Shoes";
                //       } else if (categoryItems[1].isSelected) {
                //         sizes = LocalStorage().getSize("Men_shoes_sizes");
                //         Main_Category = "Men Shoes";
                //       } else if (categoryItems[2].isSelected) {
                //         sizes = LocalStorage().getSize("Kids_shoes_sizes");
                //         Main_Category = "Kids Shoes";
                //       } else {
                //         sizes = {};
                //         Main_Category = "all";
                //       }
                //       var keys = sizes.keys.toList();

                //       double gridViewHeight =
                //           calculateGridViewHeight(keys.length);
                //       List<double> containerWidths = keys
                //           .map((text) =>
                //               getTextWidth(text,
                //                   TextStyle(fontWeight: FontWeight.bold)) +
                //               100.0)
                //           .toList();
                //       NavigatorFunction(
                //           context,
                //           SizesPage(
                //             sizes: sizes,
                //             main_category: Main_Category,
                //             name: "الأحذيه",
                //             containerWidths: containerWidths,
                //             keys: keys,
                //           ));
                //     },
                //     BorderRaduis: 40,
                //     ButtonColor: MAIN_COLOR,
                //     NameColor: Colors.white,
                //   ),
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
    return Column(
      children: [
        Visibility(
          visible: name == "كلاهما" ? false : true,
          child: Image.asset(
            image,
            height: 40,
            width: 40,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () {
            onTaped!();
          },
          child: Container(
            width: 180,
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
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: isSelected ? Colors.white : Colors.black87),
              ),
            ),
          ),
        ),
      ],
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
