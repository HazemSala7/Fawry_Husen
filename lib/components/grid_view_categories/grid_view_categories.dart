import 'dart:convert';
import 'dart:math';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/components/category_widget/category-widget.dart';
import 'package:fawri_app_refactor/components/count-down-widget/count-down-widget.dart';
import 'package:fawri_app_refactor/components/flash_sales_list/flash_sales_list.dart';
import 'package:fawri_app_refactor/components/flash_sales_products/flash_sales_products.dart';
import 'package:fawri_app_refactor/components/grid_view_categories/best-seller-widget/best-seller-widget.dart';
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
  String URL11 = "";
  bool setBigCategories = false;
  bool setShow11 = false;
  List<int> discountCategories = [];

  setControllers() async {
    var _discountCategories =
        await FirebaseRemoteConfigClass().fetchDiscountCategories();
    var _show11 = await FirebaseRemoteConfigClass().fetchShow11();
    var _url11 = await FirebaseRemoteConfigClass().fetchURL11();
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
      URL11 = _url11.toString();
      setShow11 = _show11.toString() == "true" ? true : false;
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
    return Container(
      color: setShow11 ? Colors.black : Colors.transparent,
      child: Column(
        children: [
          Visibility(
            visible: setShow11,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    NavigatorFunction(
                      context,
                      HomeScreen(
                        bannerTitle: "11.11",
                        endDate: "",
                        type: "11.11",
                        url: "",
                        title: "",
                        slider: false,
                        selectedIndex: 0,
                        productsKinds: false,
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 230,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: FancyShimmerImage(
                        imageUrl: URL11,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
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
                              baseColor:
                                  const Color.fromARGB(255, 196, 196, 196),
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
                    check11: setShow11,
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: setShow11 ? Colors.red : MAIN_COLOR,
                    ))
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
                            setBigCategories
                                ? "اعرض بشكل أقل"
                                : "اعرض بشكل أوسع",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: setShow11
                                    ? Colors.yellow
                                    : Color.fromARGB(255, 21, 101, 167)),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_circle_left_outlined,
                            color: setShow11
                                ? Colors.yellow
                                : Color.fromARGB(255, 21, 101, 167),
                          ),
                        ],
                      ),
                      Container(
                        width: 140,
                        height: 1,
                        color: setShow11
                            ? Colors.yellow
                            : Color.fromARGB(255, 80, 79, 79),
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
                              baseColor:
                                  const Color.fromARGB(255, 196, 196, 196),
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
                  check11: setShow11,
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: setShow11 ? Colors.red : MAIN_COLOR,
                  ),
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
                              baseColor:
                                  const Color.fromARGB(255, 196, 196, 196),
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
                  check11: setShow11,
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
          BestSellersWidget(
            check11: setShow11,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10),
                child: InkWell(
                  onTap: () {
                    NavigatorFunction(
                        context,
                        HomeScreen(
                          bannerTitle: "Best Seller",
                          endDate: "",
                          type: "best_seller",
                          url: URL_TOP_SELLERS,
                          title: "",
                          slider: false,
                          selectedIndex: 0,
                          productsKinds: true,
                        ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "اعرض بشكل أوسع",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: setShow11 ? Colors.yellow : MAIN_COLOR,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_circle_left_outlined,
                            color: setShow11 ? Colors.yellow : MAIN_COLOR,
                          ),
                        ],
                      ),
                      Container(
                        width: 145,
                        height: 2,
                        color: setShow11 ? Colors.yellow : MAIN_COLOR,
                      ),
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
                    return FlashSalesList(
                      check11: setShow11,
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: setShow11 ? Colors.red : MAIN_COLOR),
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
                              baseColor:
                                  const Color.fromARGB(255, 196, 196, 196),
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
                  check11: setShow11,
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
          // Stack(
          //   alignment: Alignment.bottomRight,
          //   children: [
          //     Container(
          //       height: 330,
          //       width: double.infinity,
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //           begin: Alignment.topRight,
          //           end: Alignment.bottomLeft,
          //           colors: [
          //             Color.fromARGB(255, 241, 9, 40),
          //             Color.fromRGBO(116, 13, 13, 1),
          //           ],
          //         ),
          //       ),
          //       child: Column(
          //         children: [
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 20),
          //                 child: Text(
          //                   "شركاء النجاح",
          //                   style: GoogleFonts.cairo(
          //                     fontWeight: FontWeight.w900,
          //                     fontSize: 26,
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(bottom: 20),
          //             child: FutureBuilder(
          //                 future: getShops(1),
          //                 builder: (context, AsyncSnapshot snapshot) {
          //                   if (snapshot.connectionState ==
          //                       ConnectionState.waiting) {
          //                     return Padding(
          //                       padding: const EdgeInsets.only(bottom: 15),
          //                       child: Container(
          //                           width: double.infinity,
          //                           height:
          //                               MediaQuery.of(context).size.height * 0.25,
          //                           child: ListView.builder(
          //                               itemCount: 4,
          //                               scrollDirection: Axis.horizontal,
          //                               itemBuilder: (context, int index) {
          //                                 return Padding(
          //                                   padding: const EdgeInsets.only(
          //                                       right: 5, left: 5),
          //                                   child: Container(
          //                                     decoration: BoxDecoration(
          //                                         borderRadius:
          //                                             BorderRadius.circular(10)),
          //                                     width: 160,
          //                                     height: 100,
          //                                     child: Shimmer.fromColors(
          //                                       baseColor: const Color.fromARGB(
          //                                           255, 196, 196, 196),
          //                                       highlightColor:
          //                                           const Color.fromARGB(
          //                                               255, 129, 129, 129),
          //                                       child: Container(
          //                                         width: 120,
          //                                         height: 150,
          //                                         decoration: BoxDecoration(
          //                                             color: Colors.white,
          //                                             borderRadius:
          //                                                 BorderRadius.circular(
          //                                                     10)),
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 );
          //                               })),
          //                     );
          //                   } else {
          //                     if (snapshot.data != null) {
          //                       return ShopsList(
          //                         shortlisted: snapshot.data["data"],
          //                       );
          //                     } else {
          //                       return Container(
          //                         height:
          //                             MediaQuery.of(context).size.height * 0.25,
          //                         width: double.infinity,
          //                         color: Colors.white,
          //                       );
          //                     }
          //                   }
          //                 }),
          //           )
          //         ],
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         children: [
          //           Text(
          //             "اعرض منتوجاتك على فوري ؟ ",
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.white,
          //                 fontSize: 12),
          //           ),
          //           // SizedBox(
          //           //   height: 1,
          //           // ),
          //           Container(
          //             width: 140,
          //             height: 2,
          //             color: Colors.white,
          //           )
          //         ],
          //       ),
          //     )
          //   ],
          // ),
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                            String styleID = snapshot.data[index]["style"]
                                    ["style_id"] ??
                                "1";
                            String sectionName =
                                snapshot.data[index]["name"] ?? "";
                            String sectionURL =
                                snapshot.data[index]["content_url"] ?? "";
                            var bgColor =
                                snapshot.data[index]['style']['BG_color'] ?? "";
                            Color backgroundColor = bgColor.isNotEmpty
                                ? Color(int.parse(
                                    bgColor.replaceFirst('#', '0xff')))
                                : Colors.transparent;

                            return styleID == "1"
                                ? SectionStyleOne(
                                    check11: setShow11,
                                    sectionName: sectionName,
                                    sectionURL: sectionURL,
                                    backgroundColor: backgroundColor)
                                : styleID == "2"
                                    ? Container()
                                    : styleID == "3"
                                        ? SectionStyleThree(
                                            check11: setShow11,
                                            sectionName: sectionName,
                                            sectionURL: sectionURL,
                                            backgroundColor: backgroundColor)
                                        : styleID == "4"
                                            ? SectionStyleFour(
                                                sectionName: sectionName,
                                                sectionURL: sectionURL,
                                                backgroundColor:
                                                    backgroundColor)
                                            : Container();
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
      ),
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
