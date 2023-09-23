import 'package:fawri_app_refactor/pages/choose_size/choose_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

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

  getSizesAndShow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedSize = prefs.getString('size') ?? '';
    List<bool> selectedStates = List.generate(women__sizes.length, (index) {
      String size = women__sizes[index].split(' ')[0];
      return savedSize == size; // Check if the size matches the saved size
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String getSelectedSizes() {
          List<String> selectedSizes = [];
          for (int index = 0; index < women__sizes.length; index++) {
            if (selectedStates[index]) {
              String size =
                  women__sizes[index].split(' ')[0]; // Extract the size part
              selectedSizes.add(size);
            }
          }
          return selectedSizes
              .join(', '); // Join selected sizes into a single string
        }

        // Calculate the widths for each Container
        List<double> containerWidths = women__sizes
            .map((text) =>
                getTextWidth(text, TextStyle(fontWeight: FontWeight.bold)) +
                32.0)
            .toList(); // Add padding to the calculated width
        double gridViewHeight = calculateGridViewHeight(women__sizes.length);
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Text(
                  'لتجربه أفضل ,',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  'الرجاء اختيار الحجم',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            content: Container(
              height: gridViewHeight + 130,
              child: Column(
                children: [
                  Wrap(
                    spacing: 15.0, // gap between adjacent chips
                    runSpacing: 15.0, // gap between lines
                    children: <Widget>[
                      for (int index = 0; index < women__sizes.length; index++)
                        InkWell(
                          onTap: () {
                            Vibration.vibrate(duration: 300);
                            setState(() {
                              setState(() {
                                selectedStates[index] = !selectedStates[index];
                              });
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
                              color: selectedStates[index]
                                  ? Colors.black
                                  : Colors.white,

                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the border radius
                            ),
                            height: selectedStates[index] ? 50 : 40,
                            child: Center(
                              child: Text(
                                women__sizes[index],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: selectedStates[index]
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
                            Vibration.vibrate(duration: 300);
                            String selectedSizes = getSelectedSizes();
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('size', selectedSizes);
                            NavigatorFunction(
                                context,
                                ProductsCategories(
                                  category_id: widget.main_Category,
                                  size: selectedSizes,
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
                          OnClickFunction: () {
                            Navigator.pop(context);
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
