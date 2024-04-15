import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fawri_app_refactor/firebase/order/OrderController.dart';
import 'package:fawri_app_refactor/pages/products-category/products-category.dart';
import 'package:fawri_app_refactor/services/remote_config_firebase/remote_config_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fawri_app_refactor/LocalDB/Provider/CartProvider.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../LocalDB/Models/FavoriteItem.dart';
import '../../LocalDB/Provider/FavouriteProvider.dart';
import '../../constants/constants.dart';
import '../../firebase/favourites/FavouriteControler.dart';
import '../../firebase/favourites/favourite.dart';
import '../../firebase/order/OrderFirebaseModel.dart';
import '../domain/domain.dart';

var headers = {'ContentType': 'application/json', "Connection": "Keep-Alive"};

NavigatorFunction(BuildContext context, Widget Widget) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Widget));
}

getProducts(int page) async {
  try {
    var response = await http.get(
        Uri.parse("${URL}getAllItems?api_key=$key_bath&page=$page"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  } catch (e) {
    var DomainName = await FirebaseRemoteConfigClass().getDomain();
    var response = await http.get(
        Uri.parse(
            "http://$DomainName/api/getAllItems?api_key=$key_bath&page=$page"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200) {
      return false;
    } else {
      return res;
    }
  }
}

getSpeceficProduct(id) async {
  try {
    if (id.toString().endsWith(',')) {
      id = id.toString().substring(0, id.toString().length - 1);
    }
    print("0");
    print("url");
    print("$URL_SINGLE_PRODUCT?api_key=$key_bath&id=$id");
    var response = await http.get(
        Uri.parse("$URL_SINGLE_PRODUCT?api_key=$key_bath&id=$id"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  } catch (e) {
    print("1");
    var DomainName = await FirebaseRemoteConfigClass().getDomain();
    if (id.toString().endsWith(',')) {
      id = id.toString().substring(0, id.toString().length - 1);
    }
    var response = await http.get(
        Uri.parse("$DomainName/api/getItemData?api_key=$key_bath&id=$id"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  }
}

getOrderDetails(id) async {
  try {
    var response = await http.get(
        Uri.parse("$URL_ORDER_DETAILS?id=$id&api_key=$key_bath"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  } catch (e) {
    var DomainName = await FirebaseRemoteConfigClass().getDomain();

    var response = await http.get(
        Uri.parse("$DomainName/api/getOrderData?id=$id&api_key=$key_bath"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  }
}

addOrder({context, address, phone, city, name, description, total}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UserID = prefs.getString('user_id') ?? "";
    final cartProvider =
        Provider.of<CartProvider>(context, listen: false).cartItems;
    List<Map<String, dynamic>> products = [];
    double totalPrice = 0.0;
    for (var i = 0; i < cartProvider.length; i++) {
      products.add({
        "id": cartProvider[i].productId.toString(),
        "image": cartProvider[i].image.toString(),
        "data": [
          {
            "sku": cartProvider[i].sku.toString(),
            "name": cartProvider[i].name.toString(),
            "price": cartProvider[i].price.toString(),
            "quantity": 1,
            "size": cartProvider[i].type.toString(),
            "nickname": cartProvider[i].nickname.toString(),
            "vendor_sku": cartProvider[i].vendor_sku.toString(),
            "variant_index": 0,
            "place_in_warehouse": cartProvider[i].placeInWarehouse.toString()
          }
        ]
      });
      totalPrice += double.parse(cartProvider[i].price.toString());
    }

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('$URL_ADD_ORDER?api_key=H93J48593HFNWIEUTR287TG3'));
    request.body = json.encode({
      "name": name.toString(),
      "page": "Fawri App",
      "description": description.toString(),
      "phone": phone.toString(),
      "address": address.toString(),
      "city": city.toString(),
      "total_price": double.parse(total.toString()),
      "user_id": 38,
      "products": products
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String stream = await response.stream.bytesToString();
      final decodedMap = json.decode(stream);
      final OrderController orderService = OrderController();
      String Order_ID = Uuid().v4();
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);

      OrderFirebaseModel newItem = OrderFirebaseModel(
          id: Order_ID,
          tracking_number: "123456",
          number_of_products: cartProvider.length.toString(),
          sum: totalPrice.toString(),
          order_id: decodedMap["id"].toString(),
          user_id: UserID.toString(),
          created_at: formattedDate.toString());
      orderService.addUser(newItem);
    } else {
      print(response.reasonPhrase);
    }
  } catch (e) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UserID = prefs.getString('user_id') ?? "";
    final cartProvider =
        Provider.of<CartProvider>(context, listen: false).cartItems;
    List<Map<String, dynamic>> products = [];
    double totalPrice = 0.0;
    for (var i = 0; i < cartProvider.length; i++) {
      products.add({
        "id": cartProvider[i].productId.toString(),
        "image": cartProvider[i].image.toString(),
        "data": [
          {
            "sku": cartProvider[i].sku.toString(),
            "name": cartProvider[i].name.toString(),
            "price": cartProvider[i].price.toString(),
            "quantity": 1,
            "size": cartProvider[i].type.toString(),
            "nickname": cartProvider[i].nickname.toString(),
            "vendor_sku": cartProvider[i].vendor_sku.toString(),
            "variant_index": 0,
            "place_in_warehouse": cartProvider[i].placeInWarehouse.toString()
          }
        ]
      });
      totalPrice += double.parse(cartProvider[i].price.toString());
    }
    var DomainName = await FirebaseRemoteConfigClass().getDomain();

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            '$DomainName/api/orders/submitOrder?api_key=H93J48593HFNWIEUTR287TG3'));
    request.body = json.encode({
      "name": name.toString(),
      "page": "Fawri App",
      "description": "description Test",
      "phone": phone.toString(),
      "address": address.toString(),
      "city": city.toString(),
      "total_price": double.parse(total.toString()),
      "user_id": 38,
      "products": products
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String stream = await response.stream.bytesToString();
      final decodedMap = json.decode(stream);
      final OrderController orderService = OrderController();
      String Order_ID = Uuid().v4();
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);

      OrderFirebaseModel newItem = OrderFirebaseModel(
          id: Order_ID,
          tracking_number: "123456",
          number_of_products: cartProvider.length.toString(),
          sum: totalPrice.toString(),
          order_id: decodedMap["id"].toString(),
          user_id: UserID.toString(),
          created_at: formattedDate.toString());
      orderService.addUser(newItem);
    } else {
      print(response.reasonPhrase);
    }
  }
}

sendNotification({context, USER_TOKENS}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? TOKEN = await prefs.getString('device_token') ?? "-";
  var headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAACwl5eY0:APA91bHHuJ0hAZrN5X9Pxmygq8He3SwM0_2wXsUMC0JaPT3R12FWQnc3A0E9LaDEDieuwHa4lRCeYSObgT5nroTscoUjUA9CX3a6cYG9fa0L0sB-YPvVEqdk5ekMOyb24b8COE_rsuCz'
  };
  List<String> registrationTokens = USER_TOKENS;
  var request =
      http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
  request.body = json.encode({
    "notification": {
      "title": "Fawri App",
      "body": "المنتج الذي تم اضافته الى السله لم يتبقى منه الا 2"
    },
    "registration_ids": registrationTokens
  });
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    String stream = await response.stream.bytesToString();
    final decodedMap = json.decode(stream);
  } else {
    print(response.reasonPhrase);
  }
}

getProductByCategory(category_id, sub_category_key, String size,
    String selected_sizes, int page) async {
  try {
    var sub_category_key_final = sub_category_key.replaceAll('&', '%26');
    var seasonName = await FirebaseRemoteConfigClass().initilizeConfig();
    var Final_URL = "";
    if (size != null && size.isNotEmpty && size.toString() != "null") {
      Final_URL =
          "$URL_PRODUCT_BY_CATEGORY?main_category=$category_id&sub_category=${sub_category_key_final},ONE SIZE&${size != "null" || size != "" ? "size=${size}" : ""}&season=${seasonName.toString()}&page=$page&api_key=$key_bath";
    } else {
      Final_URL =
          "$URL_PRODUCT_BY_CATEGORY?main_category=$category_id&sub_category=${sub_category_key_final},ONE SIZE&season=${seasonName.toString()}&page=$page&api_key=$key_bath";
    }
    if (selected_sizes != '') {
      Final_URL += "&selected_sizes=$selected_sizes";
    }
    print("Final_URL");
    print(Final_URL);
    var response = await http.get(Uri.parse(Final_URL), headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  } catch (e) {
    var DomainName = await FirebaseRemoteConfigClass().getDomain();
    var sub_category_key_final = sub_category_key.replaceAll('&', '%26');
    var seasonName = await FirebaseRemoteConfigClass().initilizeConfig();
    var Final_URL = "";
    if (size != null && size.isNotEmpty && size.toString() != "null") {
      Final_URL =
          "$DomainName/api/getAvailableItems?main_category=$category_id&sub_category=$sub_category_key_final&${size != "null" || size != "" ? "size=${size}" : ""}&season=${seasonName.toString()}&page=$page&api_key=$key_bath";
    } else {
      Final_URL =
          "$DomainName/api/getAvailableItems?main_category=$category_id&sub_category=$sub_category_key_final&season=${seasonName.toString()}&page=$page&api_key=$key_bath";
    }
    if (selected_sizes != null && selected_sizes.isNotEmpty) {
      Final_URL += "&selected_sizes=$selected_sizes";
    }
    var response = await http.get(Uri.parse(Final_URL), headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  }
}

getSearchResults(category_id, sub_category_key, title, type, int page) async {
  try {
    var seasonName = await FirebaseRemoteConfigClass().initilizeConfig();
    var Final_URL = "";
    if (type.toString() != "title") {
      Final_URL =
          "$URL_PRODUCT_BY_CATEGORY?main_category=$category_id&sub_category=$title&season=${seasonName.toString()}&page=$page&api_key=$key_bath";
    } else {
      Final_URL =
          "$URL_PRODUCT_BY_CATEGORY?main_category=$category_id&title=$title&season=${seasonName.toString()}&page=$page&api_key=$key_bath";
    }
    var response = await http.get(Uri.parse(Final_URL), headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  } catch (e) {
    var DomainName = await FirebaseRemoteConfigClass().getDomain();
    var seasonName = await FirebaseRemoteConfigClass().initilizeConfig();
    var Final_URL = "";
    if (type.toString() != "title") {
      Final_URL =
          "$DomainName/api/getAvailableItems?main_category=$category_id&sub_category=$title&season=${seasonName.toString()}&page=$page&api_key=$key_bath";
    } else {
      Final_URL =
          "$DomainName/api/getAvailableItems?main_category=$category_id&title=$title&season=${seasonName.toString()}&page=$page&api_key=$key_bath";
    }
    var response = await http.get(Uri.parse(Final_URL), headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  }
}

getCoupun(code) async {
  var Final_URL = "$URL_COPUN?code=$code&redeem=false&api_key=$key_bath";
  var response = await http.post(Uri.parse(Final_URL), headers: headers);
  if (response.statusCode == 200) {
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res["discount_amount"];
  } else {
    return "false";
  }
}

Future<bool> checkInternetConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

getCoupunRedeem(code) async {
  var Final_URL = "$URL_COPUN?code=$code&redeem=true&api_key=$key_bath";
  var response = await http.post(Uri.parse(Final_URL), headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
}

checkProductAvailability(prodct_id, size) async {
  try {
    var Final_URL =
        "$URL_CHECK_PRODUCT_AVAILABILITY?id=$prodct_id&size=$size&api_key=$key_bath";
    var response = await http.get(Uri.parse(Final_URL), headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res["availabilty"];
  } catch (e) {
    var DomainName = await FirebaseRemoteConfigClass().getDomain();

    var Final_URL =
        "$DomainName/api/checkProductAvailability?id=$prodct_id&size=$size&api_key=$key_bath";
    var response = await http.get(Uri.parse(Final_URL), headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res["availabilty"];
  }
}

getSimilarWords(main_category, query_word) async {
  try {
    var Final_URL =
        "$URL_SIMILAR_WORDS?main_category=$main_category&query_word=$query_word&api_key=$key_bath";
    var response = await http.get(Uri.parse(Final_URL), headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  } catch (e) {
    var DomainName = await FirebaseRemoteConfigClass().getDomain();

    var Final_URL =
        "$DomainName/api/getSimilarWords?main_category=$main_category&query_word=$query_word&api_key=$key_bath";
    var response = await http.get(Uri.parse(Final_URL), headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  }
}

getSizesByCategory(category_id, context) async {
  try {
    var response = await http.get(
        Uri.parse(
            "$URL_SIZES_BY_CATEGORY?main_category=$category_id&season=Summer&api_key=$key_bath"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    Navigator.of(context, rootNavigator: true).pop();

    return res["sizes"];
  } catch (e) {
    var DomainName = await FirebaseRemoteConfigClass().getDomain();

    var response = await http.get(
        Uri.parse(
            "$DomainName/api/getAvailableSizes?main_category=$category_id&season=Summer&api_key=$key_bath"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    Navigator.of(context, rootNavigator: true).pop();

    return res["sizes"];
  }
}

showDelayedDialog(context) {
  Future.delayed(Duration(seconds: 120), () {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                        "assets/lottie_animations/Animation - 1699360987745.json",
                        height: 300,
                        reverse: true,
                        repeat: true,
                        fit: BoxFit.cover),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "مفاجأة",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "لقد حصلت على كوبون خصم بقيمة 20% يمكنك استخدامه عند شرائك لأحد منتجاتنا",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Fawri2024",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: "Fawri2024"));
                        Navigator.pop(context);
                      },
                      child: Text(
                        "اضغط للنسخ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  });
}

void showSearchDialog(
  BuildContext context,
  main_category,
) async {
  List<dynamic> searchResults = [];
  TextEditingController searchController = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 44, 44, 44),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: MAIN_COLOR,
                          blurRadius: 5.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      controller: searchController,
                      onChanged: (value) async {
                        searchResults = await getSimilarWords(
                            main_category, searchController.text);
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 196, 195, 195),
                            fontSize: 12,
                          ),
                          hintText: "ابحث من خلال أسم المنتج"),
                    ),
                  ),
                  Visibility(
                    visible: searchController.text == "" ? false : true,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: double.infinity,
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: searchResults.length,
                        // shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              print(searchController.text);
                              if (searchResults[index]["type"] == "title") {
                                NavigatorFunction(
                                    context,
                                    ProductsCategories(
                                        sizes: "",
                                        SIZES: [],
                                        name: main_category,
                                        category_id: main_category,
                                        size: "",
                                        title: searchResults[index]["word"]
                                            .toString(),
                                        type: searchResults[index]["type"]
                                            .toString(),
                                        main_category: main_category,
                                        keys: "",
                                        search: true,
                                        containerWidths: ""));
                              } else {
                                NavigatorFunction(
                                    context,
                                    ProductsCategories(
                                        sizes: "",
                                        SIZES: [],
                                        name: main_category,
                                        category_id: main_category,
                                        size: "",
                                        title: searchResults[index]["word"]
                                            .toString(),
                                        type: searchResults[index]["type"]
                                            .toString(),
                                        main_category: main_category,
                                        keys: "",
                                        search: true,
                                        containerWidths: ""));
                              }
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            searchResults[index]["word"]
                                                        .toString()
                                                        .length >
                                                    35
                                                ? searchResults[index]["word"]
                                                    .toString()
                                                    .substring(0, 35)
                                                : searchResults[index]["word"]
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      // InkWell(
                                      //   onTap: () {},
                                      //   child: Container(
                                      //     width: 20,
                                      //     height: 20,
                                      //     decoration: BoxDecoration(
                                      //         shape: BoxShape.circle,
                                      //         border: Border.all(
                                      //             color: MAIN_COLOR)),
                                      //     child: Center(
                                      //       child: FaIcon(
                                      //         FontAwesomeIcons.plus,
                                      //         color: MAIN_COLOR,
                                      //         size: 10,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color:
                                      const Color.fromARGB(255, 236, 236, 236),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
