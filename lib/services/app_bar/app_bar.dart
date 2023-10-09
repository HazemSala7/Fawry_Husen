import 'package:fawri_app_refactor/pages/choose_size/choose_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../../LocalDB/Database/local_storage.dart';
import '../../LocalDB/Models/CartModel.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../components/button_widget/button_widget.dart';
import '../../constants/constants.dart';
import '../../firebase/cart/CartController.dart';
import '../../firebase/cart/cart.dart';
import '../../pages/cart/cart.dart';
import '../../pages/products-category/products-category.dart';
import '../../server/functions/functions.dart';

class AppBarWidget extends StatefulWidget {
  String main_Category;
  AppBarWidget({super.key, required this.main_Category});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  String user_id = "";
  setUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UserID = prefs.getString('user_id') ?? "";
    user_id = UserID;
  }

  Map sizes = {};

  setSizesArray() {
    if (widget.main_Category == "ملابس نسائيه") {
      sizes = LocalStorage().getSize("menSizes");
    } else if (widget.main_Category == "ملابس رجاليه") {
      sizes = LocalStorage().getSize("menSizes");
    } else if (widget.main_Category == "ملابس أطفال") {
      sizes = LocalStorage().getSize("kidsboysSizes");
    } else {
      sizes = LocalStorage().getSize("womenSizes");
    }
    setState(() {});
  }

  getSizesAndShow() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var keys = sizes.keys.toList();

        double gridViewHeight = calculateGridViewHeight(keys.length);
        // Calculate the widths for each Container
        List<double> containerWidths = keys
            .map((text) =>
                getTextWidth(text, TextStyle(fontWeight: FontWeight.bold)) +
                32.0)
            .toList();
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'لتجربة أفضل, الرجاء اختيار الحجم',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: Container(
              height: gridViewHeight + 150,
              child: Column(
                children: [
                  Wrap(
                    spacing: 15.0, // gap between adjacent chips
                    runSpacing: 15.0, // gap between lines
                    children: <Widget>[
                      for (int index = 0; index < keys.length; index++)
                        InkWell(
                          onTap: () {
                            Vibration.vibrate(duration: 300);
                            setState(() {
                              sizes[keys[index]] = !sizes[keys[index]];
                            });
                          },
                          child: Container(
                            width: containerWidths[
                                index], // Use the calculated width
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                ),
                              ],
                              color: sizes[keys[index]]
                                  ? Colors.black
                                  : Colors.white,

                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the border radius
                            ),
                            height: sizes[keys[index]] ? 50 : 40,
                            child: Center(
                              child: Text(
                                keys[index],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: sizes[keys[index]]
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonWidget(
                          name: "حفظ",
                          height: 40,
                          width: 120,
                          BorderColor: Colors.black,
                          OnClickFunction: () async {
                            LocalStorage().setStartSize();
                            if (widget.main_Category == "ملابس نسائيه") {
                              LocalStorage().editSize("menSizes", sizes);
                            } else if (widget.main_Category == "ملابس رجاليه") {
                              LocalStorage().editSize("menSizes", sizes);
                            } else if (widget.main_Category == "ملابس أطفال") {
                              LocalStorage().editSize("kidsboysSizes", sizes);
                            } else {
                              LocalStorage().editSize("womenSizes", sizes);
                            }
                            String sizeApi = "";
                            List sizeApp = [];

                            sizes.keys.forEach((k) {
                              if (sizes[k]) {
                                sizeApi = sizeApi + k;
                                sizeApp.add(k.split(' ')[0]);
                              }
                            });
                            LocalStorage().setSizeUser(sizeApp);

                            NavigatorFunction(
                                context,
                                ProductsCategories(
                                  category_id: widget.main_Category,
                                  size: sizeApp.join(', '),
                                ));
                          },
                          BorderRaduis: 10,
                          ButtonColor: MAIN_COLOR,
                          NameColor: Colors.white,
                        ),
                        ButtonWidget(
                          name: "تخطي",
                          height: 40,
                          width: 120,
                          BorderColor: Colors.black,
                          OnClickFunction: () async {
                            LocalStorage().setStartSize();
                            LocalStorage().setSizeUser([]);
                            NavigatorFunction(
                                context,
                                ProductsCategories(
                                  category_id: widget.main_Category,
                                  size: "null",
                                ));
                            // String selectedSizes = getSelectedSizes();
                            // SharedPreferences prefs =
                            //     await SharedPreferences.getInstance();
                            // await prefs.setString('size', selectedSizes);
                            // NavigatorFunction(
                            //     context,
                            //     ProductsCategories(
                            //       category_id: widget.main_category,
                            //       size: selectedSizes,
                            //     ));
                          },
                          BorderRaduis: 10,
                          ButtonColor: MAIN_COLOR,
                          NameColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
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

  @override
  void initState() {
    super.initState();
    setUserID();
    setSizesArray();
  }

  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: () {
          getSizesAndShow();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/tshirt.png",
            height: 35,
            width: 35,
            color: Colors.black,
          ),
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            InkWell(
              onTap: () {
                NavigatorFunction(context, Cart());
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
