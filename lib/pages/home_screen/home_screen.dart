import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/home_screen/category-screen/category-screen.dart';
import 'package:fawri_app_refactor/pages/home_screen/favourite-screen/favourite-screen.dart';
import 'package:fawri_app_refactor/pages/home_screen/main-screen/main-screen.dart';
import 'package:fawri_app_refactor/pages/home_screen/profile-screen/profile-screen.dart';
import 'package:fawri_app_refactor/services/app_bar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import 'slider_products/slider_products.dart';

class HomeScreen extends StatefulWidget {
  int selectedIndex = 0;
  bool slider = false;
  bool productsKinds = false;
  String url, title, endDate;
  var type;
  HomeScreen({
    Key? key,
    required this.type,
    required this.endDate,
    required this.productsKinds,
    required this.url,
    required this.title,
    required this.slider,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  PageController _pageController = PageController();

  bool _colorful = false;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.selectedIndex);
  }

  void onButtonPressed(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    List<Widget> _listOfWidget = <Widget>[
      widget.slider
          ? SliderProducts(
              url: widget.url,
              title: widget.title,
            )
          : MainScreen(
              type: widget.type,
              API: widget.url,
              hasAPI: widget.productsKinds,
            ),
      CategoryScreen(),
      Favourite(),
      ProfileScreen(),
    ];
    return Scaffold(
      appBar: PreferredSize(
          child: ShowCaseWidget(
            builder: Builder(
                builder: (context) => AppBarWidget(
                      main_Category: "",
                      containerWidths: "",
                      keys: "",
                      name: "",
                      sizes: "",
                    )),
          ),
          preferredSize: Size.fromHeight(60)),
      body: _listOfWidget[widget.selectedIndex],
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
    );
  }
}
