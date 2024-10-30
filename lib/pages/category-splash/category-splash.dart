import 'package:fawri_app_refactor/components/grid_view_categories/grid_view_categories.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import '../../../constants/constants.dart';
import '../../components/cart_icon/cart_icon.dart';
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

  PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    _initialize();
    _pageController = PageController(initialPage: widget.selectedIndex);
  }

  String titleName = "";
  Future<void> _initialize() async {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double cardWidth = (screenWidth / 2) - 12;
    double cardHeight = cardWidth * 2;

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
              child: CartIcon(0),
            ),
            actions: [
              InkWell(
                onTap: () {
                  NavigatorFunction(
                      context,
                      HomeScreen(
                        bannerTitle: "",
                        endDate: "",
                        type: "normal",
                        productsKinds: false,
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
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            GridViewCategories(),
          ],
        ),
      ),
    );
  }
}
