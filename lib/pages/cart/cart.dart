import 'dart:async';
import 'dart:convert';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/firebase/cart/CartController.dart';
import 'package:fawri_app_refactor/firebase/cart/CartFirebaseModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uuid/uuid.dart';
import '../../LocalDB/Models/CartModel.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../constants/constants.dart';
import '../../firebase/cart/CartProvider.dart';
import '../../server/domain/domain.dart';
import '../../server/functions/functions.dart';
import '../../services/dialogs/bottom-dialogs.dart';
import '../newest_orders/newest_orders.dart';
import '../product-screen/product-screen.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  bool clicked = false;
  bool Login = false;
  String user_id = "";
  setControllers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool('login');
    String UserID = prefs.getString('user_id') ?? "";
    user_id = UserID;
    if (login == true) {
      Login = true;
    } else {
      Login = false;
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    // final cartProvider = context.watch<CartProvider>();
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        List<CartItem> cartItems = cartProvider.cartItems;

        double total = 0;
        for (CartItem item in cartItems) {
          total += (double.tryParse(item.price.toString())?.toInt() ?? 0) *
              item.quantity;
          // total += item.price;
        }
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                centerTitle: true,
                actions: [
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: FaIcon(
                  //     FontAwesomeIcons.facebookMessenger,
                  //     color: Colors.black,
                  //     size: 25,
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  InkWell(
                    onTap: () {
                      NavigatorFunction(
                          context,
                          NewestOrders(
                            user_id: user_id,
                          ));
                    },
                    child: FaIcon(
                      FontAwesomeIcons.clock,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
                title: Text(
                  "سلتي",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, right: 20, left: 20, bottom: 20),
                      child: Row(
                        children: [
                          Text(
                            "عدد المنتجات بالسله : ${cartItems.length}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                    cartItems.length != 0
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              CartItem item = cartItems[index];
                              double total = item.price * item.quantity;

                              return CartProductMethod(
                                index: index,
                                cartProvider: cartProvider,
                                price: item.price,
                                product_id: item.productId,
                                available: item.availability,
                                type: item.type,
                                name: item.name,
                                qty: item.quantity,
                                removeProduct: () {
                                  cartProvider.removeFromCart(item.productId,
                                      selectedSize: item.type);
                                  setState(() {});
                                },
                                image: item.image,
                                item: item,
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
                                  "لا يوجد منتجات بالسله",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
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
              ),
            ),
            Visibility(
              visible: cartItems.length == 0 ? false : true,
              child: Material(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    alignment: Alignment.center,
                    child: clicked
                        ? Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: MAIN_COLOR),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.white,
                              )),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(5),
                            child: ButtonWidget(
                                name: "تأكيد عمليه الشراء",
                                height: 50,
                                width: 300,
                                BorderColor: Colors.black,
                                OnClickFunction: () async {
                                  setState(() {
                                    clicked = true;
                                  });

                                  bool allAvailable = true;
                                  var itemsToCheck = cartItems
                                      .map((item) => {
                                            'id': item.productId,
                                            'size': item.type,
                                            'quantity': item.quantity
                                          })
                                      .toList();

                                  var availabilityMap =
                                      await checkProductAvailability(
                                          itemsToCheck);

                                  for (var i = 0; i < cartItems.length; i++) {
                                    var item = cartItems[i];
                                    var availabilityData =
                                        availabilityMap[item.productId];

                                    bool isAvailable =
                                        availabilityData?['isAvailable'] ??
                                            false;
                                    int availableQty =
                                        availabilityData?['availableQty'] ?? 0;

                                    if (!isAvailable) {
                                      allAvailable = false;

                                      CartItem updatedItem = CartItem(
                                        quantityExist: availableQty,
                                        image: item.image,
                                        name: item.name,
                                        nickname: item.nickname,
                                        placeInWarehouse: item.placeInWarehouse,
                                        price: item.price,
                                        sku: item.sku,
                                        type: item.type,
                                        user_id: item.user_id,
                                        vendor_sku: item.vendor_sku,
                                        quantity: availableQty,
                                        id: item.id,
                                        productId: item.productId,
                                        availability: availableQty,
                                      );
                                      cartProvider.updateCartItemById(
                                          item.productId, updatedItem);

                                      Fluttertoast.showToast(
                                        msg:
                                            "تم تحديث كمية المنتج :${item.name} إلى $availableQty",
                                        backgroundColor:
                                            Color.fromARGB(255, 43, 145, 17),
                                      );
                                      break;
                                    }
                                  }

                                  if (allAvailable) {
                                    showCheckoutDialog().showBottomDialog(
                                        context,
                                        double.parse(total.toString()));
                                  }

                                  setState(() {
                                    clicked = false;
                                  });
                                },
                                BorderRaduis: 10,
                                ButtonColor: Colors.black,
                                NameColor: Colors.white),
                          )),
              ),
            ),
          ],
        );
      },
    );
  }

  GlobalKey _one = GlobalKey();
  Future<bool> hasShowcaseBeenShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('cart') ?? false;
  }

  Future<void> markShowcaseAsShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cart', true);
  }

  void startShowCase() async {
    bool showcaseShown = await hasShowcaseBeenShown();

    if (!showcaseShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_one]);
      });
      markShowcaseAsShown();
    }
  }

  @override
  void initState() {
    super.initState();
    startShowCase();
    setControllers();
  }

  deleteCart(removeProduct) async {
    Navigator.pop(context);
    removeProduct();
    Fluttertoast.showToast(msg: "تم حذف المنتج بنجاح");
  }

  Widget CartProductMethod(
      {String image = "",
      String name = "",
      CartProvider? cartProvider,
      Function? removeProduct,
      int product_id = 0,
      CartItem? item,
      int index = 0,
      int available = 1,
      var IDs,
      int qty = 0,
      String type = "",
      var products,
      String cart_id = "",
      var price}) {
    final cartProvider = Provider.of<CartProvider>(context);
    List<CartItem> cartItems = cartProvider.cartItems;

    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
            ),
          ],
          color: Colors.white,
          border: Border.all(
            color: available == 1
                ? Colors.transparent
                : Colors.red, // Set border color
            width: 2, // Set border width
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Dismissible(
          key: Key(index.toString()), // Provide a unique key for each item
          direction:
              DismissDirection.horizontal, // Allow both left and right swipes
          confirmDismiss: (direction) async {
            bool isDeleteAction = direction == DismissDirection.startToEnd;
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(
                      'هل أنت متأكد انك تريد حذف هذا المنتج من سله المنتجات'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('اغلاق'),
                    ),
                    TextButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String UserID = prefs.getString('user_id') ?? "";
                        deleteCart(removeProduct);
                      },
                      child: Text('حذف'),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) async {
            if (direction == DismissDirection.startToEnd) {
            } else if (direction == DismissDirection.endToStart) {}
          },
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
          child: InkWell(
            onTap: () {
              List<Map<String, dynamic>> products = [];

              for (int i = 0; i < cartItems.length; i++) {
                Map<String, dynamic> product = {
                  'id': cartItems[i].productId,
                  'title': cartItems[i].name,
                  'image': cartItems[i].image,
                  'price': cartItems[i].price,
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
                      cartItems.map((item) => item.productId).toList(), index)
                  .join(', ');
              Map<String, dynamic> firstProduct = {
                'id': cartItems[index].productId,
                'title': cartItems[index].name,
                'image': cartItems[index].image,
                'price': cartItems[index].price,
              };
              products.insert(0, firstProduct);

              NavigatorFunction(
                context,
                ProductScreen(
                  priceMul: 1.0,
                  price: price.toString(),
                  SIZES: [],
                  ALL: false,
                  Sub_Category_Key: "",
                  SubCategories: [],
                  index: index,
                  url: "",
                  page: 1,
                  sizes: [],
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
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                ),
              ], color: Colors.white),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: FancyShimmerImage(
                              imageUrl: image,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 250,
                                child: Text(
                                  name.length > 50
                                      ? name.substring(0, 50) + '...'
                                      : name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "الحجم : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: MAIN_COLOR,
                                    ),
                                  ),
                                  Text(
                                    type.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: item!.quantityExist > 1 ? true : false,
                                child: Row(
                                  children: [
                                    Text(
                                      "الكمية : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: MAIN_COLOR,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (item.quantity > 1) {
                                                int quantity = int.parse(
                                                    item.quantity.toString());
                                                // Call the updateCartItem function in CartProvider
                                                cartProvider.updateCartItem(
                                                  item.copyWith(
                                                    quantity: quantity - 1,
                                                  ),
                                                );
                                                setState(() {});
                                              }
                                            },
                                            child: Container(
                                              width: 27,
                                              height: 27,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 75, 75, 75),
                                                    width: 2),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 22,
                                                  color: Color.fromARGB(
                                                      255, 61, 61, 61),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "$qty",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              int quantity = int.parse(
                                                  item.quantity.toString());
                                              int quantityExist = int.parse(item
                                                  .quantityExist
                                                  .toString());
                                              if (quantity < quantityExist) {
                                                cartProvider.updateCartItem(
                                                  item.copyWith(
                                                    quantity: quantity + 1,
                                                  ),
                                                );
                                                setState(() {});
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "لا يمكن اضافة المزيد");
                                              }
                                            },
                                            child: Container(
                                              width: 27,
                                              height: 27,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 75, 75, 75),
                                                    width: 2),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: Color.fromARGB(
                                                      255, 61, 61, 61),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "السعر : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: MAIN_COLOR,
                                    ),
                                  ),
                                  Text(
                                    "₪${(double.tryParse(price.toString())?.toInt() ?? 0)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 124, 21, 138),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      "₪${(double.tryParse(price.toString())?.toInt() ?? 0) * qty}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
