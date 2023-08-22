import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../LocalDB/Models/CartModel.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../firebase/cart/CartController.dart';
import '../../firebase/cart/cart.dart';
import '../../pages/cart/cart.dart';
import '../../server/functions/functions.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

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

  @override
  void initState() {
    super.initState();
    setUserID();
  }

  Widget build(BuildContext context) {
    return AppBar(
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
