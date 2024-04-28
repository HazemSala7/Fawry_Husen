import 'package:fawri_app_refactor/pages/account_information/account_information.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../components/category_widget/category-widget.dart';
import '../../../constants/constants.dart';
import '../../../services/custom_icons/custom_icons.dart';
import '../../components/slider-widget/slider-widget.dart';
import '../../model/slider/slider.dart';

class CategorySplash extends StatefulWidget {
  const CategorySplash({super.key});

  @override
  State<CategorySplash> createState() => _CategorySplashState();
}

class _CategorySplashState extends State<CategorySplash> {
  late SharedPreferences _prefs;
  bool _couponShown = false;
  bool _showGoToTopIcon = false;
  late ScrollController _scrollController;

  // void _scrollListener() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     print("test");
  //     NavigatorFunction(context, AccountInformation());
  //   } else {
  //     setState(() {
  //       _showGoToTopIcon = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _initialize();
    // _scrollController = ScrollController();
    // _scrollController.addListener(_scrollListener);
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _checkAndShowCoupon();
  }

  Future<void> _checkAndShowCoupon() async {
    bool? couponShown = _prefs.getBool('couponShown');
    if (couponShown == null || !couponShown) {
      // Show the coupon dialog
      setState(() {
        _couponShown = true;
      });
      _prefs.setBool('couponShown', true);
      showDelayedDialog(context);
    } else {
      // Check if it's a new month
      DateTime now = DateTime.now();
      int currentMonth = now.month;
      int currentYear = now.year;
      int? lastMonth = _prefs.getInt('lastMonth');
      int? lastYear = _prefs.getInt('lastYear');

      if (lastMonth != currentMonth || lastYear != currentYear) {
        showDelayedDialog(context);
        _prefs.setInt('lastMonth', currentMonth);
        _prefs.setInt('lastYear', currentYear);
      }
    }
  }

  bool showGoToTopIcon = false;

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 1,
            leading: Container(),
            actions: [
              InkWell(
                onTap: () {
                  NavigatorFunction(
                      context,
                      HomeScreen(
                        selectedIndex: 0,
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "تخطي",
                    style: TextStyle(
                        fontSize: 18,
                        color: MAIN_COLOR,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
            title: Text(
              "الأقسام الرئيسيه",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 30),
              child: Column(
                children: [
                  FutureBuilder(
                      future: getSliders(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Shimmer.fromColors(
                              baseColor:
                                  const Color.fromARGB(255, 196, 196, 196),
                              highlightColor:
                                  const Color.fromARGB(255, 129, 129, 129),
                              child: Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("الأقسام الرئيسية : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))
                      ],
                    ),
                  ),
                  GridView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, int index) {
                        return CategoryWidget(
                            main_category: categories[index]["main_category"],
                            name: categories[index]["name"],
                            CateImage: categories[index]["icon"],
                            CateIcon: categories[index]["icon"],
                            image: categories[index]["image"]);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
