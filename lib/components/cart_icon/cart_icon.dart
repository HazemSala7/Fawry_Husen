import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../LocalDB/Provider/CartProvider.dart';
import '../../pages/cart/cart.dart';
import '../../server/functions/functions.dart';

class CartIcon extends StatefulWidget {
  const CartIcon(int itemCount, {super.key});

  @override
  State<CartIcon> createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  @override
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () {
            NavigatorFunction(context,
                ShowCaseWidget(builder: Builder(builder: (context) => Cart())));
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
