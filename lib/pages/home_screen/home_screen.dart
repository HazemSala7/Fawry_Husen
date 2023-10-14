import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/cart/cart.dart';
import 'package:fawri_app_refactor/pages/home_screen/category-screen/category-screen.dart';
import 'package:fawri_app_refactor/pages/home_screen/favourite-screen/favourite-screen.dart';
import 'package:fawri_app_refactor/pages/home_screen/main-screen/main-screen.dart';
import 'package:fawri_app_refactor/pages/home_screen/profile-screen/profile-screen.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:fawri_app_refactor/services/app_bar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  late PageController _pageController;
  int selectedIndex = 0;
  bool _colorful = false;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> _listOfWidget = <Widget>[
    MainScreen(),
    CategoryScreen(),
    Favourite(),
    ProfileScreen(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: ShowCaseWidget(
            builder: Builder(
                builder: (context) => AppBarWidget(
                      main_Category: "",
                    )),
          ),
          preferredSize: Size.fromHeight(60)),
      body: _listOfWidget[selectedIndex],
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        onButtonPressed: onButtonPressed,
        iconSize: 30,
        activeColor: MAIN_COLOR,
        selectedIndex: selectedIndex,
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
