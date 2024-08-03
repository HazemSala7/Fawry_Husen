import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/components/category_widget/kids_category_dialog/kids_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/shoes_category_dialog/shoes_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/sizes_page/sizes_page.dart';
import 'package:fawri_app_refactor/components/grid_view_categories/grid_view_categories.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/products-category/products-category.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../components/category_widget/category-widget.dart';
import '../../../components/flash_sales_list/flash_sales_list.dart';
import '../../../components/slider-widget/slider-widget.dart';
import '../../../model/slider/slider.dart';
import '../../../server/functions/functions.dart';
import '../../../services/remote_config_firebase/remote_config_firebase.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool showGoToTopIcon = false;
  String titleName = "";

  setControllers() async {
    var _titleName = await FirebaseRemoteConfigClass().fetchtitleHomePage();
    setState(() {
      titleName = _titleName.toString();
    });
  }

  @override
  void initState() {
    setControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
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
                        height: MediaQuery.of(context).size.height * 0.3,
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
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.3,
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
              },
            ),
            FutureBuilder(
              future: getProducts(1),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
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
                      shortlisted: snapshot.data["items"],
                      title: titleName,
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
            GridViewCategories()
          ],
        ),
      ),
    );
  }
}
