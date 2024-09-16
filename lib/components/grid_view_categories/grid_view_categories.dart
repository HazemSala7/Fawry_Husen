import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/components/category_widget/category-widget.dart';
import 'package:fawri_app_refactor/components/category_widget/kids_category_dialog/kids_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/shoes_category_dialog/shoes_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/sizes_page/sizes_page.dart';
import 'package:fawri_app_refactor/components/flash_sales_list/flash_sales_list.dart';
import 'package:fawri_app_refactor/components/home_tools_products/home_tools_products.dart';
import 'package:fawri_app_refactor/components/recommended_products/recommended_products.dart';
import 'package:fawri_app_refactor/components/slider-widget/slider-widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/model/slider/slider.dart';
import 'package:fawri_app_refactor/pages/products-category/products-category.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:fawri_app_refactor/services/remote_config_firebase/remote_config_firebase.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
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
  String featuresUrl3 = "";
  String marque = "";
  bool setBigCategories = false;
  List<int> discountCategories = [];

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
            future: getProducts(1),
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
            }),
        FutureBuilder(
            future: getSliders(),
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
            }),
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
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              color: Colors.red,
                              child: Text(
                                'SALE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Visibility(
            visible: _isCategoryDataValid(),
            child: InkWell(
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
                          main_category:
                              "Jewelry %26 Watches, Jewelry  Watches",
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
                          main_category:
                              "Beauty %26 Health, Jewelry %26 Watches",
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
                  ], borderRadius: BorderRadius.circular(6)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            FancyShimmerImage(
                              imageUrl: categoryImage,
                              boxFit: BoxFit.cover,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.25,
                            ),
                            // Container(
                            //     width: double.infinity,
                            //     height:
                            //         MediaQuery.of(context).size.height * 0.25,
                            //     decoration: BoxDecoration(
                            //       gradient: LinearGradient(
                            //         begin: Alignment.topCenter,
                            //         end: Alignment.bottomCenter,
                            //         colors: [
                            //           Color.fromARGB(183, 182, 138, 18),
                            //           Color.fromARGB(45, 0, 0, 0)
                            //         ],
                            //       ),
                            //     )),
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
          ),
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
      ],
    );
  }
}
