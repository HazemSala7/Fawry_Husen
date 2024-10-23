import 'dart:convert';
import 'dart:math';

import 'package:fawri_app_refactor/components/category_widget/category-widget.dart';
import 'package:fawri_app_refactor/components/count-down-widget/count-down-widget.dart';
import 'package:fawri_app_refactor/components/flash_sales_list/flash_sales_list.dart';
import 'package:fawri_app_refactor/components/flash_sales_products/flash_sales_products.dart';
import 'package:fawri_app_refactor/components/grid_view_categories/flash-sales-widget/flash-sales-widget.dart';
import 'package:fawri_app_refactor/components/home_tools_products/home_tools_products.dart';
import 'package:fawri_app_refactor/components/recommended_products/recommended_products.dart';
import 'package:fawri_app_refactor/components/sections/style-four/style-four.dart';
import 'package:fawri_app_refactor/components/sections/style-one/style-one.dart';
import 'package:fawri_app_refactor/components/sections/style-three/style-three.dart';
import 'package:fawri_app_refactor/components/shops_list/shops_list.dart';
import 'package:fawri_app_refactor/components/slider-widget/slider-widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/model/slider/slider.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/pages/product-screen/product-screen.dart';
import 'package:fawri_app_refactor/server/domain/domain.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:fawri_app_refactor/services/remote_config_firebase/remote_config_firebase.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

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
  String featuresUrl3 = "";
  String marque = "";
  bool setBigCategories = false;
  List<int> discountCategories = [];
  final List<Color> darkColors = [
    Colors.black,
    Colors.brown,
    Colors.blue.shade900,
    Colors.green.shade900,
    Colors.grey.shade800,
    Colors.indigo.shade900,
  ];
  final Random random = Random();

  setControllers() async {
    var _discountCategories =
        await FirebaseRemoteConfigClass().fetchDiscountCategories();
    var _featuresUrl3 = await FirebaseRemoteConfigClass().getCategoryIDKey3();
    var _categoryName = await FirebaseRemoteConfigClass().fetchCategoryName();
    var _marque = await FirebaseRemoteConfigClass().fetchMarque();
    var _categoryDesc = await FirebaseRemoteConfigClass().fetchCategoryDesc();
    var _categoryImage = await FirebaseRemoteConfigClass().fetchCategoryImage();
    var _categoryPath = await FirebaseRemoteConfigClass().fetchCategoryPath();
    setState(() {
      discountCategories = (_discountCategories)
          .map((category) => int.parse(category.toString()))
          .toList();
      categoryName = _categoryName.toString();
      categoryDesc = _categoryDesc.toString();
      categoryImage = _categoryImage.toString();
      categoryPath = _categoryPath.toString();
      marque = _marque.toString();
      featuresUrl3 = _featuresUrl3.toString();
    });
  }

  bool _isDiscountCategory() {
    return discountCategories.contains(int.tryParse(categoryPath));
  }

  @override
  void initState() {
    setControllers();
    super.initState();
  }

  bool _isCategoryDataValid() {
    return categoryName.isNotEmpty &&
        categoryDesc.isNotEmpty &&
        categoryImage.isNotEmpty &&
        categoryPath.isNotEmpty;
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xff01378A),
                Color(0xff6A96CB),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "وصل حديثا",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
                Text(
                  "New Arrival",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        FutureBuilder(
          future: getCachedProducts(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 160,
                          height: 100,
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 196, 196, 196),
                            highlightColor:
                                const Color.fromARGB(255, 129, 129, 129),
                            child: Container(
                              width: 120,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              if (snapshot.data != null) {
                return FlashSalesList(
                  productStyleNumber: 2,
                  shortlisted: snapshot.data["items"],
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  color: Colors.white,
                );
              }
            }
          },
        ),
        FutureBuilder(
          future: getCachedSliders(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 196, 196, 196),
                  highlightColor: const Color.fromARGB(255, 129, 129, 129),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: Colors.white,
                  ),
                ),
              );
            } else {
              List<Silder>? album = [];
              if (snapshot.data != null) {
                List mysslide = snapshot.data;
                List<Silder> album1 = mysslide.map((s) {
                  Silder c = Silder.fromJson(s);
                  return c;
                }).toList();
                album = album1;
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: SlideImage(
                      withCategory: false,
                      click: true,
                      showShadow: true,
                      slideimage: album,
                    ),
                  ),
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  color: Colors.white,
                );
              }
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
          child: Row(
            children: [
              Text("الأقسام الرئيسية : ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 10),
          child: setBigCategories
              ? GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    bool isDiscounted = discountCategories.contains(
                        int.parse(categories[index]["id"].toString()));
                    return Stack(
                      children: [
                        CategoryWidget(
                          setBorder: false,
                          main_category: categories[index]["main_category"],
                          name: categories[index]["name"],
                          CateImage: categories[index]["icon"],
                          CateIcon: categories[index]["icon"],
                          image: categories[index]["image"],
                        ),
                        if (isDiscounted)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Lottie.asset(
                              "assets/lottie_animations/Animation - 1726302974575.json",
                              height: 40,
                              reverse: true,
                              repeat: true,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    );
                  },
                )
              : Container(
                  height: 200,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      bool isDiscounted = discountCategories.contains(
                          int.parse(categories[index]["id"].toString()));
                      return Stack(
                        children: [
                          CategoryWidget(
                            setBorder: isDiscounted,
                            main_category: categories[index]["main_category"],
                            name: categories[index]["name"],
                            CateImage: categories[index]["icon"],
                            CateIcon: categories[index]["icon"],
                            image: categories[index]["image"],
                          ),
                          if (isDiscounted)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Lottie.asset(
                                "assets/lottie_animations/Animation - 1726302974575.json",
                                height: 40,
                                reverse: true,
                                repeat: true,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              setBigCategories = !setBigCategories;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          setBigCategories ? "اعرض بشكل أقل" : "اعرض بشكل أوسع",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color.fromARGB(255, 21, 101, 167)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_circle_left_outlined,
                          color: Color.fromARGB(255, 21, 101, 167),
                        ),
                      ],
                    ),
                    Container(
                      width: 140,
                      height: 1,
                      color: const Color.fromARGB(255, 80, 79, 79),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        FutureBuilder(
            future: getSliders(withCategory: true),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 196, 196, 196),
                    highlightColor: const Color.fromARGB(255, 129, 129, 129),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.20,
                      color: Colors.white,
                    ),
                  ),
                );
              } else {
                List<Silder>? album = [];
                if (snapshot.data != null) {
                  List mysslide = snapshot.data;
                  List<Silder> album1 = mysslide.map((s) {
                    Silder c = Silder.fromJson(s);
                    return c;
                  }).toList();
                  album = album1;
                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: SlideImage(
                        withCategory: true,
                        click: true,
                        showShadow: true,
                        slideimage: album,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.20,
                    width: double.infinity,
                    color: Colors.white,
                  );
                }
              }
            }),
        // Padding(
        //   padding: const EdgeInsets.only(top: 5),
        //   child: Visibility(
        //     visible: _isCategoryDataValid(),
        //     child: InkWell(
        //       onTap: () {
        //         bool All = false;
        //         bool Women = false;
        //         bool Men = false;
        //         bool Kids = false;
        //         if (categoryPath.toString() == "5") {
        //           NavigatorFunction(context, ShoesCategoryDialog());
        //         } else if (categoryPath.toString() == "3") {
        //           NavigatorFunction(context, KidsCategoryDialog());
        //         } else if (categoryPath.toString() == "17") {
        //           NavigatorFunction(
        //               context,
        //               ShowCaseWidget(
        //                   builder: Builder(
        //                 builder: (context) => ProductsCategories(
        //                   SIZES: [],
        //                   category_id: "Sports %26 Outdoor, Sports  Outdoor",
        //                   search: false,
        //                   size: "",
        //                   containerWidths: "null",
        //                   keys: "null",
        //                   name: "مستلزمات رياضية",
        //                   sizes: "null",
        //                   main_category: "Sports %26 Outdoor, Sports  Outdoor",
        //                 ),
        //               )));
        //         } else if (categoryPath.toString() == "7") {
        //           NavigatorFunction(
        //               context,
        //               ShowCaseWidget(
        //                   builder: Builder(
        //                 builder: (context) => ProductsCategories(
        //                   SIZES: [],
        //                   category_id:
        //                       "Home & Living, Home Living, Home Textile,Tools & Home Improvement",
        //                   search: false,
        //                   size: "",
        //                   containerWidths: "null",
        //                   keys: "null",
        //                   name: "للمنزل",
        //                   sizes: "null",
        //                   main_category:
        //                       "Home & Living, Home Living, Home Textile,Tools & Home Improvement",
        //                 ),
        //               )));
        //         } else if (categoryPath.toString() == "6") {
        //           NavigatorFunction(
        //               context,
        //               ShowCaseWidget(
        //                   builder: Builder(
        //                 builder: (context) => ProductsCategories(
        //                   SIZES: [],
        //                   category_id: "Women Apparel, Baby",
        //                   search: false,
        //                   size: "",
        //                   containerWidths: "null",
        //                   keys: "null",
        //                   name: "للرضيع و الأم",
        //                   sizes: "null",
        //                   main_category: "Women Apparel, Baby",
        //                 ),
        //               )));
        //         } else if (categoryPath.toString() == "10") {
        //           NavigatorFunction(
        //               context,
        //               ShowCaseWidget(
        //                   builder: Builder(
        //                 builder: (context) => ProductsCategories(
        //                   SIZES: [],
        //                   category_id: "Jewelry %26 Watches, Jewelry  Watches",
        //                   search: false,
        //                   size: "",
        //                   containerWidths: "null",
        //                   keys: "null",
        //                   name: "مجوهرات و ساعات",
        //                   sizes: "null",
        //                   main_category:
        //                       "Jewelry %26 Watches, Jewelry  Watches",
        //                 ),
        //               )));
        //         } else if (categoryPath.toString() == "9") {
        //           NavigatorFunction(
        //               context,
        //               ShowCaseWidget(
        //                   builder: Builder(
        //                 builder: (context) => ProductsCategories(
        //                   SIZES: [],
        //                   category_id: "Apparel Accessories",
        //                   search: false,
        //                   size: "",
        //                   containerWidths: "null",
        //                   keys: "null",
        //                   name: "اكسسوارات",
        //                   sizes: "null",
        //                   main_category: "Apparel Accessories",
        //                 ),
        //               )));
        //         } else if (categoryPath.toString() == "16") {
        //           NavigatorFunction(
        //               context,
        //               ShowCaseWidget(
        //                   builder: Builder(
        //                 builder: (context) => ProductsCategories(
        //                   SIZES: [],
        //                   category_id: "Beauty %26 Health, Jewelry %26 Watches",
        //                   search: false,
        //                   size: "",
        //                   containerWidths: "null",
        //                   keys: "null",
        //                   name: "مستحضرات تجميلية",
        //                   sizes: "null",
        //                   main_category:
        //                       "Beauty %26 Health, Jewelry %26 Watches",
        //                 ),
        //               )));
        //         } else if (categoryPath.toString() == "16") {
        //           NavigatorFunction(
        //               context,
        //               ShowCaseWidget(
        //                   builder: Builder(
        //                 builder: (context) => ProductsCategories(
        //                   SIZES: [],
        //                   category_id: "Electronics",
        //                   search: false,
        //                   size: "",
        //                   containerWidths: "null",
        //                   keys: "null",
        //                   name: "الكترونيات",
        //                   sizes: "null",
        //                   main_category: "Electronics",
        //                 ),
        //               )));
        //         } else if (categoryPath.toString() == "15") {
        //           NavigatorFunction(
        //               context,
        //               ShowCaseWidget(
        //                   builder: Builder(
        //                 builder: (context) => ProductsCategories(
        //                   SIZES: [],
        //                   category_id: "Bags %26 Luggage, Bags %26 Luggage",
        //                   search: false,
        //                   size: "",
        //                   containerWidths: "null",
        //                   keys: "null",
        //                   name: "حقائب",
        //                   sizes: "null",
        //                   main_category: "Bags %26 Luggage, Bags %26 Luggage",
        //                 ),
        //               )));
        //         } else if (categoryPath.toString() == "11") {
        //           NavigatorFunction(
        //               context,
        //               ShowCaseWidget(
        //                   builder: Builder(
        //                 builder: (context) => ProductsCategories(
        //                   SIZES: [],
        //                   category_id: "Pet Supplies",
        //                   search: false,
        //                   size: "",
        //                   containerWidths: "null",
        //                   keys: "null",
        //                   name: "للحيوانات الاليفة",
        //                   sizes: "null",
        //                   main_category: "Pet Supplies",
        //                 ),
        //               )));
        //         } else if (categoryPath.toString() == "12") {
        //           NavigatorFunction(
        //               context,
        //               ShowCaseWidget(
        //                   builder: Builder(
        //                 builder: (context) => ProductsCategories(
        //                   SIZES: [],
        //                   category_id: "Automotive",
        //                   search: false,
        //                   size: "",
        //                   containerWidths: "null",
        //                   keys: "null",
        //                   name: "مستلزمات سيارات",
        //                   sizes: "null",
        //                   main_category: "Automotive",
        //                 ),
        //               )));
        //         } else if (categoryPath.toString() == "14") {
        //           NavigatorFunction(
        //               context,
        //               ShowCaseWidget(
        //                   builder: Builder(
        //                 builder: (context) => ProductsCategories(
        //                   SIZES: [],
        //                   category_id:
        //                       "Office School Supplies, Office %26 School Supplies",
        //                   search: false,
        //                   size: "",
        //                   containerWidths: "null",
        //                   keys: "null",
        //                   name: "مستلزمات مكاتب",
        //                   sizes: "null",
        //                   main_category:
        //                       "Office School Supplies, Office %26 School Supplies",
        //                 ),
        //               )));
        //         } else {
        //           Map sizes = {};
        //           if (categoryPath.toString() == "2") {
        //             sizes = LocalStorage().getSize("womenSizes");
        //           } else if (categoryPath.toString() == "1") {
        //             sizes = LocalStorage().getSize("menSizes");
        //           } else if (categoryPath.toString() == "4") {
        //             sizes = LocalStorage().getSize("womenPlusSizes");
        //           } else if (categoryPath.toString() == "18") {
        //             sizes = LocalStorage().getSize("Weddings & Events");
        //           } else if (categoryPath.toString() == "8") {
        //             sizes = LocalStorage().getSize("Underwear_Sleepwear_sizes");
        //           }

        //           var keys = sizes.keys.toList();

        //           double gridViewHeight = calculateGridViewHeight(keys.length);
        //           // Calculate the widths for each Container
        //           List<double> containerWidths = keys
        //               .map((text) =>
        //                   getTextWidth(
        //                       text, TextStyle(fontWeight: FontWeight.bold)) +
        //                   120.0)
        //               .toList();
        //           NavigatorFunction(
        //               context,
        //               SizesPage(
        //                 sizes: sizes,
        //                 main_category: categoryPath.toString() == "2"
        //                     ? "Women Apparel"
        //                     : categoryPath.toString() == "1"
        //                         ? "Men Apparel, Men"
        //                         : categoryPath.toString() == "4"
        //                             ? "Women Apparel"
        //                             : categoryPath.toString() == "18"
        //                                 ? "Weddings %26 Events, Weddings %26 Events"
        //                                 : categoryPath.toString() == "8"
        //                                     ? "Underwear & Sleepwear, Underwear Sleepwear"
        //                                     : "",
        //                 name: categoryPath.toString() == "2"
        //                     ? "ملابس نسائيه"
        //                     : categoryPath.toString() == "1"
        //                         ? "ملابس رجاليه"
        //                         : categoryPath.toString() == "4"
        //                             ? "ملابس نسائيه مقاس كبير"
        //                             : categoryPath.toString() == "18"
        //                                 ? "مستلزمات اعراس"
        //                                 : categoryPath.toString() == "8"
        //                                     ? "ملابس داخليه"
        //                                     : "",
        //                 containerWidths: containerWidths,
        //                 keys: keys,
        //               ));
        //         }
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Container(
        //           decoration: BoxDecoration(boxShadow: [
        //             BoxShadow(
        //               color: Color.fromARGB(255, 145, 114, 13).withOpacity(0.5),
        //               blurRadius: 7,
        //               offset: Offset(0, 2),
        //             ),
        //           ], borderRadius: BorderRadius.circular(6)),
        //           child: Stack(
        //             alignment: Alignment.center,
        //             children: [
        //               ClipRRect(
        //                 borderRadius: BorderRadius.circular(6),
        //                 child: Stack(
        //                   children: [
        //                     FancyShimmerImage(
        //                       imageUrl: categoryImage,
        //                       boxFit: BoxFit.cover,
        //                       width: double.infinity,
        //                       height: MediaQuery.of(context).size.height * 0.25,
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(right: 20, top: 5),
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                   children: [
        //                     Text(
        //                       categoryName,
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.white,
        //                           fontSize: 30),
        //                     ),
        //                     SizedBox(
        //                       height: 30,
        //                     ),
        //                     Text(
        //                       categoryDesc,
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.white,
        //                           fontSize: 20),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 20,
        ),

        FutureBuilder(
          future: getFlashSales(1),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Shimmer loading effect during data fetch
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 160,
                          height: 100,
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 196, 196, 196),
                            highlightColor:
                                const Color.fromARGB(255, 129, 129, 129),
                            child: Container(
                              width: 120,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              // Display flash sales content when data is available
              return FlashSalesWidget(
                active: snapshot.data["active"],
                flashSalesArray: snapshot.data,
                startDate: snapshot.data["start_date"],
                endDate: snapshot.data["end_date"],
              );
            } else {
              // Fallback for empty or null data
              return Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                color: Colors.white,
                child: Center(
                  child: Text(
                    "No flash sales available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              );
            }
          },
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
          child: Row(
            children: [
              Text(
                "خصيصا لك",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: fetchRecommendedItems(1),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 160,
                          height: 100,
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 196, 196, 196),
                            highlightColor:
                                const Color.fromARGB(255, 129, 129, 129),
                            child: Container(
                              width: 120,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              return RecommendedProducts(
                hasAPI: false,
                productCardStyle: 2,
                shortlisted: snapshot.data["items"],
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                color: Colors.white,
              );
            }
          },
        ),
        SizedBox(height: 20),
        Container(
          height: 370,
          width: double.infinity,
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topRight,
              //   end: Alignment.bottomLeft,
              //   colors: [
              //     Color.fromARGB(255, 0, 89, 255),
              //     Color.fromRGBO(90, 88, 233, 1),
              //   ],
              // ),
              ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "الأكثر مبيعا",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 200,
                      height: 3,
                      color: Colors.black,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                FutureBuilder(
                  future: getBestSellersProducts(1),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 196, 196, 196),
                                  highlightColor:
                                      const Color.fromARGB(255, 129, 129, 129),
                                  child: Container(
                                    width: 160,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.hasData && snapshot.data != null) {
                      List products = snapshot.data["data"];
                      int pageCount = (products.length / 4)
                          .ceil(); // Calculate number of pages

                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.38,
                        child: PageView.builder(
                          itemCount: pageCount,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, pageIndex) {
                            // Display 4 products per page (2x2 grid)
                            int start = pageIndex * 4;
                            int end = (start + 4 > products.length)
                                ? products.length
                                : start + 4;

                            List currentProducts = products.sublist(start, end);

                            return GridView.builder(
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevent individual scrolling
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Two products per row
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio:
                                    1.5, // Adjust this ratio for card size
                              ),
                              itemCount: currentProducts.length,
                              itemBuilder: (context, gridIndex) {
                                var product = currentProducts[gridIndex];
                                Color randomColor = darkColors[
                                    random.nextInt(darkColors.length)];
                                return InkWell(
                                  onTap: () {
                                    List result = [];
                                    int startIndex = gridIndex - 20;
                                    int endIndex = gridIndex + 20;
                                    if (startIndex < 0) {
                                      startIndex = 0;
                                    }
                                    if (endIndex > products.length) {
                                      endIndex = products.length;
                                    }
                                    result.addAll(
                                        products.sublist(startIndex, endIndex));
                                    result.insert(0, products[gridIndex]);
                                    List<String> idsList = result
                                        .map((item) =>
                                            item['item_id'].toString())
                                        .toList();
                                    String commaSeparatedIds =
                                        idsList.join(', ');
                                    NavigatorFunction(
                                        context,
                                        ProductScreen(
                                          hasAPI: true,
                                          priceMul: 1.0,
                                          price: products[gridIndex]["price"]
                                              .toString(),
                                          SIZES: [],
                                          ALL: true,
                                          SubCategories: [],
                                          url:
                                              "${URL}getAllItems?api_key=$key_bath&page=1",
                                          page: 1,
                                          Sub_Category_Key:
                                              sub_categories_women_appearel[0]
                                                      ["key"]
                                                  .toString(),
                                          sizes: [],
                                          index: gridIndex,
                                          cart_fav: false,
                                          Images: [],
                                          favourite: false,
                                          id: products[gridIndex]["item_id"],
                                          Product: result,
                                          IDs: commaSeparatedIds,
                                        ));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            child: Container(
                                              color: randomColor,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: 50,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        product["item_name"],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  product.containsKey(
                                                              "price") &&
                                                          product["price"] !=
                                                              null
                                                      ? Text(
                                                          product["price"]
                                                                  is double
                                                              ? "₪${(product["price"] as double).toStringAsFixed(2)}"
                                                              : (double.tryParse(
                                                                          product["price"]
                                                                              .toString()) !=
                                                                      null
                                                                  ? "₪${double.parse(product["price"]).toStringAsFixed(2)}"
                                                                  : "₪0"),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 24,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : Text(
                                                          "₪0",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 24,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 150,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(product[
                                                                "images"]
                                                            .length ==
                                                        0
                                                    ? "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                                    : product["images"][0] ??
                                                        "https://www.fawri.co/assets/about_us/fawri_logo.jpg"),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: double.infinity,
                        color: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: InkWell(
                onTap: () {
                  NavigatorFunction(
                      context,
                      HomeScreen(
                        type: "best_seller",
                        url: URL_TOP_SELLERS,
                        title: "",
                        slider: false,
                        selectedIndex: 0,
                        productsKinds: true,
                      ));
                },
                child: Column(
                  children: [
                    Text(
                      "عرض بشكل أوسع",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MAIN_COLOR,
                          fontSize: 14),
                    ),
                    Container(
                      width: 110,
                      height: 2,
                      color: MAIN_COLOR,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        Visibility(
          visible: marque.toString() == "" ? false : true,
          child: Container(
            height: 40,
            width: double.infinity,
            color: Colors.red,
            child: Marquee(
              text: marque,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 17),
              scrollAxis: Axis.horizontal,
              blankSpace: 20.0,
              velocity: 100.0,
              pauseAfterRound: Duration(seconds: 1),
              startPadding: 10.0,
              accelerationDuration: Duration(milliseconds: 500),
              decelerationDuration: Duration(milliseconds: 500),
              accelerationCurve: Curves.linear,
              decelerationCurve: Curves.easeOut,
            ),
          ),
        ),
        FutureBuilder(
            future: getFeatureProducts(featuresUrl3),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                width: 160,
                                height: 100,
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 196, 196, 196),
                                  highlightColor:
                                      const Color.fromARGB(255, 129, 129, 129),
                                  child: Container(
                                    width: 120,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            );
                          })),
                );
              } else {
                if (snapshot.data != null) {
                  return FlashSalesList(
                    productStyleNumber: 3,
                    shortlisted: snapshot.data["items"],
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    color: Colors.white,
                  );
                }
              }
            }),
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
          child: Row(
            children: [
              Text(
                "يجب أن تكون في كل منزل",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "assets/images/house.png",
                height: 25,
                width: 25,
              )
            ],
          ),
        ),
        FutureBuilder(
          future: getHomeData(1),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 160,
                          height: 100,
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 196, 196, 196),
                            highlightColor:
                                const Color.fromARGB(255, 129, 129, 129),
                            child: Container(
                              width: 120,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              return HomeToolsProducts(
                shortlisted: snapshot.data["items"],
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                color: Colors.white,
              );
            }
          },
        ),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              height: 330,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 241, 9, 40),
                    Color.fromRGBO(116, 13, 13, 1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "شركاء النجاح",
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: FutureBuilder(
                        future: getShops(1),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: ListView.builder(
                                      itemCount: 4,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 5, left: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: 160,
                                            height: 100,
                                            child: Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(
                                                  255, 196, 196, 196),
                                              highlightColor:
                                                  const Color.fromARGB(
                                                      255, 129, 129, 129),
                                              child: Container(
                                                width: 120,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        );
                                      })),
                            );
                          } else {
                            if (snapshot.data != null) {
                              return ShopsList(
                                shortlisted: snapshot.data["data"],
                              );
                            } else {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: double.infinity,
                                color: Colors.white,
                              );
                            }
                          }
                        }),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "اعرض منتوجاتك على فوري ؟ ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                  // SizedBox(
                  //   height: 1,
                  // ),
                  Container(
                    width: 140,
                    height: 2,
                    color: Colors.white,
                  )
                ],
              ),
            )
          ],
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FutureBuilder(
              future: getAppSections(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, left: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 160,
                                  height: 100,
                                  child: Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 196, 196, 196),
                                    highlightColor: const Color.fromARGB(
                                        255, 129, 129, 129),
                                    child: Container(
                                      width: 120,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              );
                            })),
                  );
                } else {
                  if (snapshot.data != null) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, int index) {
                          String styleID =
                              snapshot.data[index]["style"]["style_id"] ?? "1";
                          String sectionName =
                              snapshot.data[index]["name"] ?? "";
                          String sectionURL =
                              snapshot.data[index]["content_url"] ?? "";
                          var bgColor =
                              snapshot.data[index]['style']['BG_color'] ?? "";
                          Color backgroundColor = bgColor.isNotEmpty
                              ? Color(
                                  int.parse(bgColor.replaceFirst('#', '0xff')))
                              : Colors.transparent;

                          return styleID == "1"
                              ? SectionStyleOne(
                                  sectionName: sectionName,
                                  sectionURL: sectionURL,
                                  backgroundColor: backgroundColor)
                              : styleID == "2"
                                  ? Container()
                                  : styleID == "3"
                                      ? SectionStyleThree(
                                          sectionName: sectionName,
                                          sectionURL: sectionURL,
                                          backgroundColor: backgroundColor)
                                      : SectionStyleFour(
                                          sectionName: sectionName,
                                          sectionURL: sectionURL,
                                          backgroundColor: backgroundColor);
                        });
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: double.infinity,
                      color: Colors.white,
                    );
                  }
                }
              }),
        )
      ],
    );
  }

  var cachedProducts;
  List<dynamic>? cachedSliders;
  DateTime? productsCacheTime;
  DateTime? slidersCacheTime;

  getCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedProductsString = prefs.getString('cachedProducts');
    String? productsCacheTimeString = prefs.getString('productsCacheTime');
    if (cachedProductsString != null && productsCacheTimeString != null) {
      DateTime productsCacheTime = DateTime.parse(productsCacheTimeString);
      if (DateTime.now().difference(productsCacheTime).inHours < 2) {
        return jsonDecode(cachedProductsString);
      }
    }
    Map<String, dynamic> fetchedProducts = await getProducts(1);
    prefs.setString('cachedProducts', jsonEncode(fetchedProducts));
    prefs.setString('productsCacheTime', DateTime.now().toIso8601String());
    return fetchedProducts;
  }

  getCachedSliders() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedSlidersString = prefs.getString('cachedSliders');
    String? slidersCacheTimeString = prefs.getString('slidersCacheTime');
    if (cachedSlidersString != null && slidersCacheTimeString != null) {
      DateTime slidersCacheTime = DateTime.parse(slidersCacheTimeString);
      if (DateTime.now().difference(slidersCacheTime).inHours < 2) {
        return jsonDecode(cachedSlidersString);
      }
    }
    List<dynamic> fetchedSliders = await getSliders(withCategory: false);
    prefs.setString('cachedSliders', jsonEncode(fetchedSliders));
    prefs.setString('slidersCacheTime', DateTime.now().toIso8601String());
    return fetchedSliders;
  }
}
