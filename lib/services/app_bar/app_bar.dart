import 'package:fawri_app_refactor/components/category_widget/sizes_page/sizes_page.dart';
import 'package:fawri_app_refactor/pages/choose_size/choose_size.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:vibration/vibration.dart';

import '../../LocalDB/Database/local_storage.dart';
import '../../LocalDB/Models/CartModel.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../components/button_widget/button_widget.dart';
import '../../constants/constants.dart';
import '../../firebase/cart/CartController.dart';
import '../../firebase/cart/CartFirebaseModel.dart';
import '../../pages/cart/cart.dart';
import '../../pages/products-category/products-category.dart';
import '../../server/functions/functions.dart';

class AppBarWidget extends StatefulWidget {
  var sizes, containerWidths, keys, main_Category, name;
  AppBarWidget(
      {super.key,
      required this.sizes,
      required this.name,
      required this.main_Category,
      required this.keys,
      required this.containerWidths});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  String user_id = "";
  bool is_selected_size = false;
  setSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UserID = prefs.getString('user_id') ?? "";
    bool is_selected_size_shared = prefs.getBool('is_selected_size') ?? false;
    user_id = UserID;
    is_selected_size = is_selected_size_shared;
  }

  Map sizes = {};
  String sizesOutput = "";

  setSizesArray() {
    if (widget.main_Category == "ملابس نسائيه") {
      sizes = LocalStorage().getSize("womenSizes");
    } else if (widget.main_Category == "ملابس رجاليه") {
      sizes = LocalStorage().getSize("menSizes");
    } else if (widget.main_Category == "ملابس نسائيه مقاس كبير") {
      sizes = LocalStorage().getSize("womenPlusSizes");
    } else if (widget.main_Category == "مستلزمات اعراس") {
      sizes = LocalStorage().getSize("Weddings & Events");
    } else if (widget.main_Category == "ملابس داخليه") {
      sizes = LocalStorage().getSize("Underwear_Sleepwear_sizes");
    }
    if (widget.sizes is Map) {
      // Check if widget.sizes is a Map
      List trueSizes = (widget.sizes as Map)
          .entries // Cast widget.sizes to Map
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList();

      sizesOutput = trueSizes.join(', ');
      setState(() {});
    }
  }

  double calculateGridViewHeight(int itemCount) {
    final double itemHeight = 30.0; // Height of each item
    final int itemsPerRow = 3; // Number of items per row
    final int rowCount = (itemCount / itemsPerRow).ceil();
    final double gridHeight = itemHeight * rowCount;
    final double spacingHeight = 30.0 * (rowCount - 1); // Adjust for spacing
    return gridHeight + spacingHeight;
  }

  double getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }

  GlobalKey _one = GlobalKey();

  // Function to check if the showcase has been shown before
  Future<bool> hasShowcaseBeenShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showcaseShown') ?? false;
  }

  // Function to mark the showcase as shown
  Future<void> markShowcaseAsShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showcaseShown', true);
  }

  void startShowCase() async {
    bool showcaseShown = await hasShowcaseBeenShown();

    if (!showcaseShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_one]);
      });

      // Mark the showcase as shown
      markShowcaseAsShown();
    }
  }

  @override
  void initState() {
    super.initState();
    startShowCase();
    setSharedPref();
    setSizesArray();
  }

  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Visibility(
        visible: widget.sizes == "" || widget.sizes == "null" ? false : true,
        child: Showcase(
          key: _one,
          title: 'اختيار الحجم',
          description: 'هنا يتم اختيار الحجم',
          child: InkWell(
            onTap: () {
              NavigatorFunction(
                  context,
                  SizesPage(
                      sizes: widget.sizes,
                      name: widget.name,
                      main_category: widget.main_Category,
                      keys: widget.keys,
                      containerWidths: widget.containerWidths));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: is_selected_size
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Marquee(
                        text: "$sizesOutput",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 40.0,
                        velocity: 50.0,
                        pauseAfterRound: Duration(seconds: 1),
                        startPadding: 10.0,
                        accelerationDuration: Duration(milliseconds: 500),
                        decelerationDuration: Duration(milliseconds: 500),
                        accelerationCurve: Curves.linear,
                        decelerationCurve: Curves.easeOut,
                      ),
                    )
                  : Image.asset(
                      is_selected_size
                          ? "assets/images/full_tshirt.png"
                          : "assets/images/tshirt.png",
                      height: 35,
                      width: 35,
                    ),
            ),
          ),
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            InkWell(
              onTap: () {
                NavigatorFunction(
                    context,
                    ShowCaseWidget(
                        builder: Builder(builder: (context) => Cart())));
              },
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  "assets/images/shopping-cart.png",
                  height: 35,
                  width: 35,
                  color: Colors.black,
                ),
              ),
            ),
            Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                int itemCount = cartProvider.cartItemsCount;
                return CartIcon(itemCount);
              },
            )
          ],
        )
      ],
      elevation: 1,
      centerTitle: true,
      title: Text(
        "الرئيسيه",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
      ),
    );
  }

  Widget CartIcon(int itemCount) {
    return Container(
      height: 17,
      width: 17,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            itemCount.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
