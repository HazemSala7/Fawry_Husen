import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fawri_app_refactor/LocalDB/Provider/CartProvider.dart';
import 'package:fawri_app_refactor/components/cart_icon/cart_icon.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/cart/cart.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';

class AppBarWidgetBack extends StatelessWidget {
  var cartKey;
  bool showCart;
  AppBarWidgetBack({
    Key? key,
    required this.showCart,
    required this.cartKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MAIN_COLOR,
      centerTitle: true,
      title: Text(
        "فوري",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      actions: [
        Visibility(
          visible: showCart,
          child: Container(
            key: cartKey,
            child: Stack(
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
                      color: Colors.white,
                    ),
                  ),
                ),
                Consumer<CartProvider>(
                  builder: (context, cartProvider, _) {
                    int itemCount = cartProvider.cartItemsCount;
                    return CartIcon();
                  },
                )
              ],
            ),
          ),
        )
      ],
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          )),
    );
  }
}
