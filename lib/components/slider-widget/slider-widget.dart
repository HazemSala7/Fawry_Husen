import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/components/category_widget/category-widget.dart';
import 'package:fawri_app_refactor/components/category_widget/kids_category_dialog/kids_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/shoes_category_dialog/shoes_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/sizes_page/sizes_page.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/pages/home_screen/slider_products/slider_products.dart';
import 'package:fawri_app_refactor/pages/products-category/products-category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../constants/constants.dart';
import '../../model/slider/slider.dart';
import '../../server/domain/domain.dart';
import '../../server/functions/functions.dart';

class SlideImage extends StatefulWidget {
  List<Silder> slideimage;
  bool showShadow = false;
  bool withCategory = false;
  bool click = false;
  SlideImage({
    Key? key,
    required this.slideimage,
    required this.withCategory,
    required this.showShadow,
    required this.click,
  }) : super(key: key);

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return ImageSlideshow(
        width: double.infinity,
        indicatorColor: MAIN_COLOR,
        isLoop: true,
        height: MediaQuery.of(context).size.height * 0.4,
        children: widget.slideimage
            .map((e) => InkWell(
                  onTap: () {
                    if (widget.withCategory) {
                      bool All = false;
                      bool Women = false;
                      bool Men = false;
                      bool Kids = false;
                      if (e.action.toString() == "5") {
                        NavigatorFunction(context, ShoesCategoryDialog());
                      } else if (e.action.toString() == "3") {
                        NavigatorFunction(context, KidsCategoryDialog());
                      } else if (e.action.toString() == "17") {
                        NavigatorFunction(
                            context,
                            ShowCaseWidget(
                                builder: Builder(
                              builder: (context) => ProductsCategories(
                                SIZES: [],
                                category_id:
                                    "Sports %26 Outdoor, Sports  Outdoor",
                                search: false,
                                size: "",
                                containerWidths: "null",
                                keys: "null",
                                name: "مستلزمات رياضية",
                                sizes: "null",
                                main_category:
                                    "Sports %26 Outdoor, Sports  Outdoor",
                              ),
                            )));
                      } else if (e.action.toString() == "7") {
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
                      } else if (e.action.toString() == "6") {
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
                      } else if (e.action.toString() == "10") {
                        NavigatorFunction(
                            context,
                            ShowCaseWidget(
                                builder: Builder(
                              builder: (context) => ProductsCategories(
                                SIZES: [],
                                category_id:
                                    "Jewelry %26 Watches, Jewelry  Watches",
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
                      } else if (e.action.toString() == "9") {
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
                      } else if (e.action.toString() == "16") {
                        NavigatorFunction(
                            context,
                            ShowCaseWidget(
                                builder: Builder(
                              builder: (context) => ProductsCategories(
                                SIZES: [],
                                category_id:
                                    "Beauty %26 Health, Jewelry %26 Watches",
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
                      } else if (e.action.toString() == "16") {
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
                      } else if (e.action.toString() == "15") {
                        NavigatorFunction(
                            context,
                            ShowCaseWidget(
                                builder: Builder(
                              builder: (context) => ProductsCategories(
                                SIZES: [],
                                category_id:
                                    "Bags %26 Luggage, Bags %26 Luggage",
                                search: false,
                                size: "",
                                containerWidths: "null",
                                keys: "null",
                                name: "حقائب",
                                sizes: "null",
                                main_category:
                                    "Bags %26 Luggage, Bags %26 Luggage",
                              ),
                            )));
                      } else if (e.action.toString() == "11") {
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
                      } else if (e.action.toString() == "12") {
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
                      } else if (e.action.toString() == "14") {
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
                        if (e.action.toString() == "2") {
                          sizes = LocalStorage().getSize("womenSizes");
                        } else if (e.action.toString() == "1") {
                          sizes = LocalStorage().getSize("menSizes");
                        } else if (e.action.toString() == "4") {
                          sizes = LocalStorage().getSize("womenPlusSizes");
                        } else if (e.action.toString() == "18") {
                          sizes = LocalStorage().getSize("Weddings & Events");
                        } else if (e.action.toString() == "8") {
                          sizes = LocalStorage()
                              .getSize("Underwear_Sleepwear_sizes");
                        }

                        var keys = sizes.keys.toList();

                        double gridViewHeight =
                            calculateGridViewHeight(keys.length);
                        // Calculate the widths for each Container
                        List<double> containerWidths = keys
                            .map((text) =>
                                getTextWidth(text,
                                    TextStyle(fontWeight: FontWeight.bold)) +
                                120.0)
                            .toList();
                        NavigatorFunction(
                            context,
                            SizesPage(
                              sizes: sizes,
                              main_category: e.action.toString() == "2"
                                  ? "Women Apparel"
                                  : e.action.toString() == "1"
                                      ? "Men Apparel, Men"
                                      : e.action.toString() == "4"
                                          ? "Women Apparel"
                                          : e.action.toString() == "18"
                                              ? "Weddings %26 Events, Weddings %26 Events"
                                              : e.action.toString() == "8"
                                                  ? "Underwear & Sleepwear, Underwear Sleepwear"
                                                  : "",
                              name: e.action.toString() == "2"
                                  ? "ملابس نسائيه"
                                  : e.action.toString() == "1"
                                      ? "ملابس رجاليه"
                                      : e.action.toString() == "4"
                                          ? "ملابس نسائيه مقاس كبير"
                                          : e.action.toString() == "18"
                                              ? "مستلزمات اعراس"
                                              : e.action.toString() == "8"
                                                  ? "ملابس داخليه"
                                                  : "",
                              containerWidths: containerWidths,
                              keys: keys,
                            ));
                      }
                    } else {
                      NavigatorFunction(
                          context,
                          HomeScreen(
                            title: e.title.toString() == ""
                                ? "سلايدر 1 سلايدر 1"
                                : e.title,
                            url: e.action,
                            selectedIndex: 0,
                            slider: true,
                          ));
                    }
                  },
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Stack(
                        children: [
                          FancyShimmerImage(
                            imageUrl: e.image,
                            boxFit: BoxFit.cover,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                          // Visibility(
                          //   visible: widget.showShadow,
                          //   child: Container(
                          //       width: double.infinity,
                          //       height:
                          //           MediaQuery.of(context).size.height * 0.4,
                          //       decoration: BoxDecoration(
                          //         gradient: LinearGradient(
                          //           begin: Alignment.topCenter,
                          //           end: Alignment.bottomCenter,
                          //           colors: [
                          //             Color.fromARGB(183, 0, 0, 0),
                          //             Color.fromARGB(45, 0, 0, 0)
                          //           ],
                          //         ),
                          //       )),
                          // ),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 20, top: 20),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Text(
                      //             e.title == null || e.title.toString() == ""
                      //                 ? "سلايدر 1 سلايدر 1"
                      //                 : e.title,
                      //             style: TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.white,
                      //                 fontSize: 30),
                      //           )
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 30,
                      //       ),
                      //       Row(
                      //         children: [
                      //           Text(
                      //             e.description == null ||
                      //                     e.description.toString() == ""
                      //                 ? "وصف عن منتج"
                      //                 : e.description,
                      //             style: TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.white,
                      //                 fontSize: 20),
                      //           )
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ))
            .toList(),
        autoPlayInterval: 6000,
        // isLoop: true,
      );
    });
  }
}
