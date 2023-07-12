import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

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
    Container(
      alignment: Alignment.center,
      child: const Icon(
        Icons.event,
        size: 56,
        color: Colors.brown,
      ),
    ),
    Container(
      alignment: Alignment.center,
      child: const Icon(
        Icons.search,
        size: 56,
        color: Colors.brown,
      ),
    ),
    Container(
      alignment: Alignment.center,
      child: const Icon(
        Icons.bolt,
        size: 56,
        color: Colors.brown,
      ),
    ),
    Container(
      alignment: Alignment.center,
      child: const Icon(
        Icons.tune_rounded,
        size: 56,
        color: Colors.brown,
      ),
    ),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: _listOfWidget[selectedIndex],
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        onButtonPressed: onButtonPressed,
        iconSize: 30,
        activeColor: const Color(0xFF01579B),
        selectedIndex: selectedIndex,
        barItems: <BarItem>[
          BarItem(
            icon: Icons.person,
            title: 'Profile',
          ),
          BarItem(
            icon: Icons.search_rounded,
            title: 'Favourite',
          ),
          BarItem(
            icon: Icons.category,
            title: 'Categories',
          ),
          BarItem(
            icon: Icons.home,
            title: 'Home',
          ),
        ],
      ),
    );
  }
}
