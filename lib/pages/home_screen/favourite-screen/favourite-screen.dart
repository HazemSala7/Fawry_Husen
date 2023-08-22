import 'dart:async';
import 'dart:convert';
import 'package:fawri_app_refactor/LocalDB/Provider/FavouriteProvider.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/constants.dart';
import '../../../LocalDB/Models/CartModel.dart';
import '../../../LocalDB/Models/FavoriteItem.dart';
import '../../../LocalDB/Provider/CartProvider.dart';
import '../../../firebase/favourites/FavouriteControler.dart';
import '../../../firebase/favourites/favourite.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteProvider>(
      builder: (context, favoriteProvider, _) {
        List<FavoriteItem> favoritesItems = favoriteProvider.favoriteItems;
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 20, left: 20, bottom: 20),
                child: Row(
                  children: [
                    Text(
                      "عدد المنتجات بالمفضله : ${favoritesItems.length}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ],
                ),
              ),
              favoritesItems.length != 0
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: favoritesItems.length,
                      itemBuilder: (context, index) {
                        FavoriteItem item = favoritesItems[index];
                        return cartCard(
                          price: item.price,
                          name: item.name,
                          product_id: item.productId,
                          removeProduct: () {
                            Navigator.pop(context);
                            favoriteProvider.removeFromFavorite(item.productId);
                            setState(() {});
                          },
                          image: item.image,
                        );
                      },
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "لا يوجد منتجات بالمفضله",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Icon(Icons.no_accounts_sharp)
                        ],
                      ),
                    ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        );
      },
    );
  }

  addToCart(product_ID, name, image, price, cartProvider) async {
    final newItem = CartItem(
      productId: product_ID,
      name: name,
      image: image.toString(),
      price: double.parse(price.toString()),
      quantity: 1,
      user_id: 0,
    );
    cartProvider.addToCart(newItem);
    Navigator.pop(context);
    Fluttertoast.showToast(
      msg: "تم اضافه هذا المنتج الى سله المنتجات بنجاح",
    );
    Timer(Duration(milliseconds: 500), () {
      Fluttertoast.cancel(); // Dismiss the toast after the specified duration
    });
  }

  Widget cartCard(
      {String image = "",
      var price,
      String name = "",
      int fav_id = 0,
      int index = 0,
      Function? removeProduct,
      int product_id = 0,
      String categry = ""}) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Dismissible(
      key: Key(image), // Provide a unique key for each item
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        bool isDeleteAction = direction == DismissDirection.startToEnd;
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(isDeleteAction
                  ? 'هل أنت متأكد انك تريد حذف هذا المنتج من المفضله'
                  : 'هل تريد بالتأكيد اضافه هذا المنتج الى المفضله ؟ '),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('اغلاق'),
                ),
                TextButton(
                  onPressed: () async {
                    isDeleteAction
                        ? removeProduct!()
                        : addToCart(
                            product_id, name, image, price, cartProvider);
                  },
                  child: Text(isDeleteAction ? 'حذف' : 'اضافه'),
                ),
              ],
            );
          },
        );
      }, // Allow both left and right swipes
      // onDismissed: (direction) async {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   String? UserID = prefs.getString('user_id');
      //   if (direction == DismissDirection.startToEnd) {
      //     Timer(Duration(seconds: 1), () async {
      //       deleteFav(UserID, product_id.toString(), index);
      //     });
      //   } else if (direction == DismissDirection.endToStart) {
      //     addToCart(UserID, product_id.toString());
      //   }
      //   setState(() {});
      // },
      background: Container(
        color: Colors
            .red, // Use different colors for delete and add to cart actions
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors
            .blue, // Use different colors for delete and add to cart actions
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 7,
                      blurRadius: 5,
                    ),
                  ],
                  color: Colors.white),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          child: Image.network(
                            image,
                            height: 180,
                            width: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                width: 200,
                                child: Text(name.length > 50
                                    ? name.substring(0, 50)
                                    : name)),
                            Text(categry),
                            Text("${price} NIS"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add_shopping_cart,
                    color: MAIN_COLOR,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete_forever,
                    color: MAIN_COLOR,
                    size: 30,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
