import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/cart/cart.dart';
import 'package:fawri_app_refactor/pages/home_screen/category-screen/category-screen.dart';
import 'package:fawri_app_refactor/pages/home_screen/favourite-screen/favourite-screen.dart';
import 'package:fawri_app_refactor/pages/home_screen/main-screen/main-screen.dart';
import 'package:fawri_app_refactor/pages/home_screen/profile-screen/profile-screen.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/tshirt.png",
            height: 35,
            width: 35,
            color: Colors.black,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              NavigatorFunction(context, Cart());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/shopping-cart.png",
                height: 35,
                width: 35,
                color: Colors.black,
              ),
            ),
          )
          // Padding(
          //   padding: EdgeInsetsDirectional.fromSTEB(0, 8, 12, 0),
          //   child: FutureBuilder<ApiCallResponse>(
          //     future: (_apiRequestCompleter ??= Completer<ApiCallResponse>()
          //           ..complete(GetcartnewCall.call(
          //             id: currentUserUid,
          //           )))
          //         .future,
          //     builder: (context, snapshot) {
          //       // Customize what your widget looks like when it's loading.
          //       if (!snapshot.hasData) {
          //         return Center(
          //           child: SizedBox(
          //             width: 50,
          //             height: 50,
          //             child: CircularProgressIndicator(
          //               color: FlutterFlowTheme.of(context).primaryColor,
          //             ),
          //           ),
          //         );
          //       }
          //       final badgeGetCarttResponse = snapshot.data!;
          //       if (FFAppState().selectedcats.isEmpty) {
          //         subheight = 0;
          //         subheight2 = 40;
          //       } else {
          //         subheight = 50;
          //         subheight2 = 88;
          //       }
          //       return InkWell(
          //           onTap: () async {
          //             // await Navigator.push(
          //             //   context,
          //             //   MaterialPageRoute(
          //             //     builder: (context) => ShowCaseWidget(
          //             //       builder: Builder(
          //             //         builder: (context) => const CartWidget(),
          //             //       ),
          //             //     ),
          //             //   ),
          //             // );
          //           },
          //           child: Container());
          //     },
          //   ),
          // )
        ],
        elevation: 1,
        centerTitle: true,
        title: Text(
          "الرئيسيه",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(child: _listOfWidget[selectedIndex]),
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
