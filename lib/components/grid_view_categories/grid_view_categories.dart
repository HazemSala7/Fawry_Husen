import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/components/category_widget/category-widget.dart';
import 'package:fawri_app_refactor/components/category_widget/kids_category_dialog/kids_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/shoes_category_dialog/shoes_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/sizes_page/sizes_page.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/products-category/products-category.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:fawri_app_refactor/services/remote_config_firebase/remote_config_firebase.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class GridViewCategories extends StatefulWidget {
  const GridViewCategories({super.key});

  @override
  State<GridViewCategories> createState() => _GridViewCategoriesState();
}

class _GridViewCategoriesState extends State<GridViewCategories> {
  @override
  String categoryName = "";
  String categoryDesc = "";
  String categoryImage = "";
  String categoryPath = "";

  setControllers() async {
    var _categoryName = await FirebaseRemoteConfigClass().fetchCategoryName();
    var _categoryDesc = await FirebaseRemoteConfigClass().fetchCategoryDesc();
    var _categoryImage = await FirebaseRemoteConfigClass().fetchCategoryImage();
    var _categoryPath = await FirebaseRemoteConfigClass().fetchCategoryPath();
    setState(() {
      categoryName = _categoryName.toString();
      categoryDesc = _categoryDesc.toString();
      categoryImage = _categoryImage.toString();
      categoryPath = _categoryPath.toString();
    });
  }

  @override
  void initState() {
    setControllers();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            return CategoryWidget(
              main_category: categories[index]["main_category"],
              name: categories[index]["name"],
              CateImage: categories[index]["icon"],
              CateIcon: categories[index]["icon"],
              image: categories[index]["image"],
            );
          },
        ),
        InkWell(
          onTap: () {
            bool All = false;
            bool Women = false;

            bool Men = false;
            bool Kids = false;
            if (categoryPath.toString() == "5") {
              NavigatorFunction(context, ShoesCategoryDialog());
            } else if (categoryPath.toString() == "3") {
              NavigatorFunction(context, KidsCategoryDialog());
            } else if (categoryPath.toString() == "17") {
              NavigatorFunction(
                  context,
                  ShowCaseWidget(
                      builder: Builder(
                    builder: (context) => ProductsCategories(
                      SIZES: [],
                      category_id: "Sports %26 Outdoor, Sports  Outdoor",
                      search: false,
                      size: "",
                      containerWidths: "null",
                      keys: "null",
                      name: "مستلزمات رياضية",
                      sizes: "null",
                      main_category: "Sports %26 Outdoor, Sports  Outdoor",
                    ),
                  )));
            } else if (categoryPath.toString() == "7") {
              NavigatorFunction(
                  context,
                  ShowCaseWidget(
                      builder: Builder(
                    builder: (context) => ProductsCategories(
                      SIZES: [],
                      category_id:
                          "Home & Living, Home Living, Home Textile,Tools & Home Improvement",
                      search: false,
                      size: "",
                      containerWidths: "null",
                      keys: "null",
                      name: "للمنزل",
                      sizes: "null",
                      main_category:
                          "Home & Living, Home Living, Home Textile,Tools & Home Improvement",
                    ),
                  )));
            } else if (categoryPath.toString() == "6") {
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
                      keys: "null",
                      name: "للرضيع و الأم",
                      sizes: "null",
                      main_category: "Women Apparel, Baby",
                    ),
                  )));
            } else if (categoryPath.toString() == "10") {
              NavigatorFunction(
                  context,
                  ShowCaseWidget(
                      builder: Builder(
                    builder: (context) => ProductsCategories(
                      SIZES: [],
                      category_id: "Jewelry %26 Watches, Jewelry  Watches",
                      search: false,
                      size: "",
                      containerWidths: "null",
                      keys: "null",
                      name: "مجوهرات و ساعات",
                      sizes: "null",
                      main_category: "Jewelry %26 Watches, Jewelry  Watches",
                    ),
                  )));
            } else if (categoryPath.toString() == "9") {
              NavigatorFunction(
                  context,
                  ShowCaseWidget(
                      builder: Builder(
                    builder: (context) => ProductsCategories(
                      SIZES: [],
                      category_id: "Apparel Accessories",
                      search: false,
                      size: "",
                      containerWidths: "null",
                      keys: "null",
                      name: "اكسسوارات",
                      sizes: "null",
                      main_category: "Apparel Accessories",
                    ),
                  )));
            } else if (categoryPath.toString() == "16") {
              NavigatorFunction(
                  context,
                  ShowCaseWidget(
                      builder: Builder(
                    builder: (context) => ProductsCategories(
                      SIZES: [],
                      category_id: "Beauty %26 Health, Jewelry %26 Watches",
                      search: false,
                      size: "",
                      containerWidths: "null",
                      keys: "null",
                      name: "مستحضرات تجميلية",
                      sizes: "null",
                      main_category: "Beauty %26 Health, Jewelry %26 Watches",
                    ),
                  )));
            } else if (categoryPath.toString() == "16") {
              NavigatorFunction(
                  context,
                  ShowCaseWidget(
                      builder: Builder(
                    builder: (context) => ProductsCategories(
                      SIZES: [],
                      category_id: "Electronics",
                      search: false,
                      size: "",
                      containerWidths: "null",
                      keys: "null",
                      name: "الكترونيات",
                      sizes: "null",
                      main_category: "Electronics",
                    ),
                  )));
            } else if (categoryPath.toString() == "15") {
              NavigatorFunction(
                  context,
                  ShowCaseWidget(
                      builder: Builder(
                    builder: (context) => ProductsCategories(
                      SIZES: [],
                      category_id: "Bags %26 Luggage, Bags %26 Luggage",
                      search: false,
                      size: "",
                      containerWidths: "null",
                      keys: "null",
                      name: "حقائب",
                      sizes: "null",
                      main_category: "Bags %26 Luggage, Bags %26 Luggage",
                    ),
                  )));
            } else if (categoryPath.toString() == "11") {
              NavigatorFunction(
                  context,
                  ShowCaseWidget(
                      builder: Builder(
                    builder: (context) => ProductsCategories(
                      SIZES: [],
                      category_id: "Pet Supplies",
                      search: false,
                      size: "",
                      containerWidths: "null",
                      keys: "null",
                      name: "للحيوانات الاليفة",
                      sizes: "null",
                      main_category: "Pet Supplies",
                    ),
                  )));
            } else if (categoryPath.toString() == "12") {
              NavigatorFunction(
                  context,
                  ShowCaseWidget(
                      builder: Builder(
                    builder: (context) => ProductsCategories(
                      SIZES: [],
                      category_id: "Automotive",
                      search: false,
                      size: "",
                      containerWidths: "null",
                      keys: "null",
                      name: "مستلزمات سيارات",
                      sizes: "null",
                      main_category: "Automotive",
                    ),
                  )));
            } else if (categoryPath.toString() == "14") {
              NavigatorFunction(
                  context,
                  ShowCaseWidget(
                      builder: Builder(
                    builder: (context) => ProductsCategories(
                      SIZES: [],
                      category_id:
                          "Office School Supplies, Office %26 School Supplies",
                      search: false,
                      size: "",
                      containerWidths: "null",
                      keys: "null",
                      name: "مستلزمات مكاتب",
                      sizes: "null",
                      main_category:
                          "Office School Supplies, Office %26 School Supplies",
                    ),
                  )));
            } else {
              Map sizes = {};
              if (categoryPath.toString() == "2") {
                sizes = LocalStorage().getSize("womenSizes");
              } else if (categoryPath.toString() == "1") {
                sizes = LocalStorage().getSize("menSizes");
              } else if (categoryPath.toString() == "4") {
                sizes = LocalStorage().getSize("womenPlusSizes");
              } else if (categoryPath.toString() == "18") {
                sizes = LocalStorage().getSize("Weddings & Events");
              } else if (categoryPath.toString() == "8") {
                sizes = LocalStorage().getSize("Underwear_Sleepwear_sizes");
              }

              var keys = sizes.keys.toList();

              double gridViewHeight = calculateGridViewHeight(keys.length);
              // Calculate the widths for each Container
              List<double> containerWidths = keys
                  .map((text) =>
                      getTextWidth(
                          text, TextStyle(fontWeight: FontWeight.bold)) +
                      120.0)
                  .toList();
              NavigatorFunction(
                  context,
                  SizesPage(
                    sizes: sizes,
                    main_category: categoryPath.toString() == "2"
                        ? "Women Apparel"
                        : categoryPath.toString() == "1"
                            ? "Men Apparel"
                            : categoryPath.toString() == "4"
                                ? "Women Apparel"
                                : categoryPath.toString() == "18"
                                    ? "Weddings %26 Events, Weddings %26 Events"
                                    : categoryPath.toString() == "8"
                                        ? "Underwear & Sleepwear, Underwear Sleepwear"
                                        : "",
                    name: categoryPath.toString() == "2"
                        ? "ملابس نسائيه"
                        : categoryPath.toString() == "1"
                            ? "ملابس رجاليه"
                            : categoryPath.toString() == "4"
                                ? "ملابس نسائيه مقاس كبير"
                                : categoryPath.toString() == "18"
                                    ? "مستلزمات اعراس"
                                    : categoryPath.toString() == "8"
                                        ? "ملابس داخليه"
                                        : "",
                    containerWidths: containerWidths,
                    keys: keys,
                  ));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 145, 114, 13).withOpacity(0.5),
                  blurRadius: 7,
                  offset: Offset(0, 2),
                ),
              ], borderRadius: BorderRadius.circular(20)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        FancyShimmerImage(
                          imageUrl: categoryImage,
                          boxFit: BoxFit.cover,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                        Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(183, 182, 138, 18),
                                  Color.fromARGB(45, 0, 0, 0)
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          categoryName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 30),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          categoryDesc,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GridView.builder(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categories.length - 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            return CategoryWidget(
              main_category: categories[index + 4]["main_category"],
              name: categories[index + 4]["name"],
              CateImage: categories[index + 4]["icon"],
              CateIcon: categories[index + 4]["icon"],
              image: categories[index + 4]["image"],
            );
          },
        ),
      ],
    );
  }
}
