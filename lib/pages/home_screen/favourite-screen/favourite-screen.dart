import 'dart:async';
import 'dart:convert';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/LocalDB/Provider/FavouriteProvider.dart';
import 'package:fawri_app_refactor/pages/product-screen/product-screen.dart';
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
        favoriteProvider.getFavouritesItems();
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
                        String productIdsString = favoritesItems
                            .map((item) => item.productId)
                            .join(', ');
                        return cartCard(
                          price: item.price,
                          name: item.name,
                          IDs: productIdsString,
                          product_id: item.productId,
                          index: index,
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

  NavigatorProduct(favItems, index, image, product_id) {
    List<Map<String, dynamic>> products = [];

    for (int i = 0; i < favItems.length; i++) {
      Map<String, dynamic> product = {
        'id': favItems[i].productId,
        'title': favItems[i].name,
        'image': favItems[i].image,
        'price': favItems[i].price,
      };
      products.add(product);
    }
    List<T> reorderListBasedOnIndex<T>(List<T> list, int index) {
      if (index >= 0 && index < list.length) {
        var firstPart = list.sublist(index);
        var secondPart = list.sublist(0, index);
        return [...firstPart, ...secondPart];
      }
      return list; // Return the original list if the index is out of bounds
    }

    String productIdsString = reorderListBasedOnIndex(
            favItems.map((item) => item.productId).toList(), index)
        .join(', ');

// Create a map for the first object you want to insert
    Map<String, dynamic> firstProduct = {
      'id': favItems[index].productId,
      'title': favItems[index].name,
      'image': favItems[index].image,
      'price': favItems[index].price,
    };

// Insert the first object at the specified index
    products.insert(0, firstProduct);

    NavigatorFunction(
      context,
      ProductScreen(
        SIZES: [],
        ALL: false,
        SubCategories: [],
        Sub_Category_Key: "",
        index: index,
        sizes: [],
        url: "",
        page: 1,
        cart_fav: true,
        favourite: false,
        Images: [image],
        Product: products,
        IDs: productIdsString,
        id: product_id,
      ),
    );
  }

  addToCart(product_ID, name, image, price, sku, vendorski, nickname,
      cartProvider, favoriteProvider) async {
    final newItem = CartItem(
      availability: 1,
      productId: product_ID,
      name: name,
      sku: sku,
      vendor_sku: vendorski,
      nickname: nickname,
      image: image.toString(),
      price: double.parse(price.toString()),
      quantity: 1,
      user_id: 0,
      type: '',
      placeInWarehouse: '',
    );
    cartProvider.addToCart(newItem);
    Navigator.pop(context);
    Fluttertoast.showToast(
      msg: "تم اضافه هذا المنتج الى سله المنتجات بنجاح",
    );
    favoriteProvider.removeFromFavorite(product_ID);
    setState(() {});
    Timer(Duration(milliseconds: 500), () {
      Fluttertoast.cancel(); // Dismiss the toast after the specified duration
    });
  }

  Widget cartCard(
      {String image = "",
      var price,
      String name = "",
      String SKU = "",
      String vendor_SKU = "",
      String nickname = "",
      int fav_id = 0,
      int index = 0,
      var IDs,
      Function? removeProduct,
      int product_id = 0,
      String categry = ""}) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favoriteProvider = Provider.of<FavouriteProvider>(context);
    List<FavoriteItem> favItems = favoriteProvider.favoriteItems;
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
                        : NavigatorProduct(favItems, index, image, product_id);
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
            InkWell(
              onTap: () {
                List<Map<String, dynamic>> products = [];

                for (int i = 0; i < favItems.length; i++) {
                  Map<String, dynamic> product = {
                    'id': favItems[i].productId,
                    'title': favItems[i].name,
                    'image': favItems[i].image,
                    'price': favItems[i].price,
                  };
                  products.add(product);
                }
                List<T> reorderListBasedOnIndex<T>(List<T> list, int index) {
                  if (index >= 0 && index < list.length) {
                    var firstPart = list.sublist(index);
                    var secondPart = list.sublist(0, index);
                    return [...firstPart, ...secondPart];
                  }
                  return list; // Return the original list if the index is out of bounds
                }

                String productIdsString = reorderListBasedOnIndex(
                        favItems.map((item) => item.productId).toList(), index)
                    .join(', ');

// Create a map for the first object you want to insert
                Map<String, dynamic> firstProduct = {
                  'id': favItems[index].productId,
                  'title': favItems[index].name,
                  'image': favItems[index].image,
                  'price': favItems[index].price,
                };

// Insert the first object at the specified index
                products.insert(0, firstProduct);

                NavigatorFunction(
                  context,
                  ProductScreen(
                    SIZES: [],
                    ALL: false,
                    SubCategories: [],
                    Sub_Category_Key: "",
                    index: index,
                    sizes: [],
                    url: "",
                    page: 1,
                    cart_fav: true,
                    favourite: false,
                    Images: [image],
                    Product: products,
                    IDs: productIdsString,
                    id: product_id,
                  ),
                );
              },
              child: Container(
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                'هل تريد بالتأكيد اضافه هذا المنتج الى سله المنتجات ؟ '),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('اغلاق'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  List<Map<String, dynamic>> products = [];

                                  for (int i = 0; i < favItems.length; i++) {
                                    Map<String, dynamic> product = {
                                      'id': favItems[i].productId,
                                      'title': favItems[i].name,
                                      'image': favItems[i].image,
                                      'price': favItems[i].price,
                                    };
                                    products.add(product);
                                  }
                                  List<T> reorderListBasedOnIndex<T>(
                                      List<T> list, int index) {
                                    if (index >= 0 && index < list.length) {
                                      var firstPart = list.sublist(index);
                                      var secondPart = list.sublist(0, index);
                                      return [...firstPart, ...secondPart];
                                    }
                                    return list; // Return the original list if the index is out of bounds
                                  }

                                  String productIdsString =
                                      reorderListBasedOnIndex(
                                              favItems
                                                  .map((item) => item.productId)
                                                  .toList(),
                                              index)
                                          .join(', ');

// Create a map for the first object you want to insert
                                  Map<String, dynamic> firstProduct = {
                                    'id': favItems[index].productId,
                                    'title': favItems[index].name,
                                    'image': favItems[index].image,
                                    'price': favItems[index].price,
                                  };

// Insert the first object at the specified index
                                  products.insert(0, firstProduct);

                                  NavigatorFunction(
                                    context,
                                    ProductScreen(
                                      SIZES: [],
                                      ALL: false,
                                      SubCategories: [],
                                      Sub_Category_Key: "",
                                      index: index,
                                      sizes: [],
                                      url: "",
                                      page: 1,
                                      cart_fav: true,
                                      favourite: false,
                                      Images: [image],
                                      Product: products,
                                      IDs: productIdsString,
                                      id: product_id,
                                    ),
                                  );
                                  // addToCart(
                                  //     product_id,
                                  //     name,
                                  //     image,
                                  //     price,
                                  //     SKU,
                                  //     vendor_SKU,
                                  //     nickname,
                                  //     cartProvider,
                                  //     favoriteProvider);
                                },
                                child: Text('اضافه'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.add_shopping_cart,
                      color: MAIN_COLOR,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                'هل أنت متأكد انك تريد حذف هذا المنتج من المفضله'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('اغلاق'),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    removeProduct!();
                                  },
                                  child: Text('حذف')),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.delete_forever,
                      color: MAIN_COLOR,
                      size: 30,
                    ),
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
