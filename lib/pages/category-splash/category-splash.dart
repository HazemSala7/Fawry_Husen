import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/pages/account_information/account_information.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import '../../../components/category_widget/category-widget.dart';
import '../../../constants/constants.dart';
import '../../../services/custom_icons/custom_icons.dart';
import '../../components/cart_icon/cart_icon.dart';
import '../../components/product_widget/product-widget.dart';
import '../../components/slider-widget/slider-widget.dart';
import '../../model/slider/slider.dart';
import '../home_screen/category-screen/category-screen.dart';
import '../home_screen/favourite-screen/favourite-screen.dart';
import '../home_screen/profile-screen/profile-screen.dart';

class CategorySplash extends StatefulWidget {
  int selectedIndex = 0;
  CategorySplash({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

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
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _initialize();
    _pageController = PageController(initialPage: widget.selectedIndex);
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
  void onButtonPressed(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    List<Widget> _listOfWidget = <Widget>[
      categorySplashMainScreen(),
      CategoryScreen(),
      Favourite(),
      ProfileScreen(),
    ];
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 1,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CartIcon(),
            ),
            actions: [
              InkWell(
                onTap: () {
                  NavigatorFunction(
                      context,
                      HomeScreen(
                        title: "",
                        selectedIndex: 0,
                        slider: false,
                        url: "",
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
          bottomNavigationBar: SlidingClippedNavBar(
            backgroundColor: Colors.white,
            onButtonPressed: onButtonPressed,
            iconSize: 30,
            activeColor: MAIN_COLOR,
            selectedIndex: widget.selectedIndex,
            barItems: <BarItem>[
              BarItem(
                icon: Icons.home,
                title: "الرئيسيه",
              ),
              BarItem(
                icon: Icons.category,
                title: "الأقسام",
              ),
              BarItem(
                icon: FontAwesomeIcons.heart,
                title: "المفضله",
              ),
              BarItem(
                icon: Icons.more,
                title: "المزيد",
              ),
            ],
          ),
          body: _listOfWidget[widget.selectedIndex],
        ),
      ),
    );
  }

  Widget categorySplashMainScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 30),
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
                        highlightColor:
                            const Color.fromARGB(255, 129, 129, 129),
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
                        padding: const EdgeInsets.only(top: 15),
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
                }),
            FutureBuilder(
                future: getProducts(1),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 196, 196, 196),
                        highlightColor:
                            const Color.fromARGB(255, 129, 129, 129),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.3,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    if (snapshot.data != null) {
                      return recentlyShortlistedByYou(
                          shortlisted: snapshot.data["items"],
                          title: "المنتجات المخفضة");
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
                ],
              ),
            ),
            GridView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }

  Widget recentlyShortlistedByYou({var shortlisted, String title = ""}) {
    return Container(
      color: Color(0xffFEEFDB),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
            child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: AnimationLimiter(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        shortlisted.length >= 10 ? 10 : shortlisted.length,
                    itemBuilder: (context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          horizontalOffset: 100.0,
                          child: FadeInAnimation(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: InkWell(
                                    onTap: () {
                                      // NavigatorFunction(
                                      //     context,
                                      //     ProductScreen(
                                      //       Images: [
                                      //         widget.image,
                                      //         widget.image
                                      //       ],
                                      //       price: widget.new_price.toString(),
                                      //       name: widget.name,
                                      //       id: widget.id,
                                      //     ));
                                    },
                                    child: Container(
                                      width: 160,
                                      // height: 180,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                Stack(
                                                  alignment: Alignment.topRight,
                                                  children: [
                                                    Stack(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      children: [
                                                        Container(
                                                            width:
                                                                double.infinity,
                                                            height: 180,
                                                            child:
                                                                FancyShimmerImage(
                                                              imageUrl: shortlisted[
                                                                      index][
                                                                  "vendor_images_links"][0],
                                                              width: double
                                                                  .infinity,
                                                              height: 240,
                                                              boxFit:
                                                                  BoxFit.cover,
                                                              errorWidget:
                                                                  Image.asset(
                                                                "assets/images/splash.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                    Opacity(
                                                      opacity: 0.75,
                                                      child: Container(
                                                        width: 35,
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Center(
                                                          child: Lottie.asset(
                                                              "assets/lottie_animations/Animation - 1720525210493.json",
                                                              height: 50,
                                                              reverse: true,
                                                              repeat: true,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 160,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5,
                                                          right: 5,
                                                          top: 3),
                                                  child: Text(
                                                    shortlisted[index]["title"]
                                                                .length >
                                                            15
                                                        ? shortlisted[index]
                                                                ["title"]
                                                            .substring(0, 15)
                                                        : shortlisted[index]
                                                            ["title"],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "₪${shortlisted[index]["price"]}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Color(0xff354EB2)),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Column(
                                                  children: [
                                                    Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Text(
                                                          "₪${double.parse(shortlisted[index]["price"].toString()) * 1.5}",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 1,
                                                          width: 50,
                                                          color: Colors.black,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Color(0xffFFA048),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
