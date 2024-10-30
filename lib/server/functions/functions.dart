import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fawri_app_refactor/firebase/order/OrderController.dart';
import 'package:fawri_app_refactor/firebase/selected_sizes/selected_sizes_controller.dart';
import 'package:fawri_app_refactor/firebase/selected_sizes/selected_sizes_model.dart';
import 'package:fawri_app_refactor/pages/products-category/products-category.dart';
import 'package:fawri_app_refactor/services/cache_manager/cache_manager.dart';
import 'package:fawri_app_refactor/services/remote_config_firebase/remote_config_firebase.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fawri_app_refactor/LocalDB/Provider/CartProvider.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../constants/constants.dart';
import '../../firebase/order/OrderFirebaseModel.dart';
import '../../firebase/used_copons/UsedCoponsController.dart';
import '../../firebase/used_copons/UsedCoponsFirebaseModel.dart';
import '../domain/domain.dart';

var headers = {'ContentType': 'application/json', "Connection": "Keep-Alive"};

Future<String> createDynamicLink(String productId) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://fawri.page.link', // Use your dynamic link URL prefix
    link: Uri.parse(
        'https://fawri-f7ab5f0e45b8.herokuapp.com/product?id=$productId'),
    androidParameters: AndroidParameters(
      packageName: 'fawri.app.shop', // Replace with your app's package name
      minimumVersion: 0,
    ),
    iosParameters: IOSParameters(
      bundleId: 'fawri.app.shop', // Replace with your app's bundle ID
      minimumVersion: '1.0.0',
    ),
  );

  final ShortDynamicLink shortLink =
      await FirebaseDynamicLinks.instance.buildShortLink(parameters);
  return shortLink.shortUrl.toString();
}

Future<String> createCartDynamicLink() async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://fawri.page.link', // Your dynamic link URL prefix
    link: Uri.parse(
        'https://fawri-f7ab5f0e45b8.herokuapp.com/cart'), // Link for Cart screen
    androidParameters: AndroidParameters(
      packageName: 'fawri.app.shop', // Your app's package name
      minimumVersion: 0,
    ),
    iosParameters: IOSParameters(
      bundleId: 'fawri.app.shop', // Your app's bundle ID
      minimumVersion: '1.0.0',
    ),
  );

  final ShortDynamicLink shortLink =
      await FirebaseDynamicLinks.instance.buildShortLink(parameters);
  return shortLink.shortUrl.toString();
}

Future<String> createNewestOrdersDynamicLink() async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://fawri.page.link', // Your dynamic link URL prefix
    link: Uri.parse(
        'https://fawri-f7ab5f0e45b8.herokuapp.com/track_order'), // Link for NewestOrders screen
    androidParameters: AndroidParameters(
      packageName: 'fawri.app.shop', // Your app's package name
      minimumVersion: 0,
    ),
    iosParameters: IOSParameters(
      bundleId: 'fawri.app.shop', // Your app's bundle ID
      minimumVersion: '1.0.0',
    ),
  );

  final ShortDynamicLink shortLink =
      await FirebaseDynamicLinks.instance.buildShortLink(parameters);
  return shortLink.shortUrl.toString();
}

NavigatorFunction(BuildContext context, Widget Widget) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Widget));
}

fetchRecommendedItems(int page) async {
  SelectedSizeService selectedSizeService = SelectedSizeService();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String UserID = prefs.getString('user_id') ?? "";
  String categoryId = "";
  List<String> sizes = [];
  String userId = UserID;
  List<SelectedSizeModel> selectedSizes =
      await selectedSizeService.getSelectedSizesByUserId(userId);
  Map<String, dynamic> combinedResponse = {"items": []};
  for (var selectedSize in selectedSizes) {
    categoryId = selectedSize.categoryId;
    categoryId = categoryId.replaceAll('&', '%26');
    sizes = selectedSize.selectedSizes;
    String sizesParam = sizes.join(',');
  }
  var response =
      await getProductByCategory(categoryId, '', '', sizes.join(','), page);
  if (response != null && response["items"] != null) {
    combinedResponse["items"].addAll(response["items"]);
  }

  return combinedResponse;
}

getSliders({bool withCategory = false}) async {
  // final cacheManager = CacheManager();
  // const cacheKey = 'sliders';
  // final cachedData = await cacheManager.getCache(cacheKey);

  // if (cachedData != null) {
  //   return cachedData;
  // }

  try {
    var response = await http.get(
        Uri.parse(withCategory
            ? "${URL}getSliders?api_key=$key_bath&type=category"
            : "${URL}getSliders?api_key=$key_bath"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // await cacheManager.setCache(cacheKey, res);
      return res;
    } else {
      throw Exception('Failed to load sliders: ${response.statusCode}');
    }
  } catch (e) {
    var response = await http.get(Uri.parse("http://api.well.ps:3002/sliders"),
        headers: headers);
    var res = jsonDecode(response.body)["response"];

    if (response.statusCode == 200) {
      // await cacheManager.setCache(cacheKey, res);
      return res;
    } else {
      throw Exception(
          'Failed to load sliders from fallback: ${response.statusCode}');
    }
  }
}

getFeatureProducts(DomainName) async {
  var response = await http.get(Uri.parse(DomainName), headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  if (response.statusCode != 200) {
    return false;
  } else {
    return res;
  }
}

getFlashSales(int page) async {
  var response = await http.get(Uri.parse("$URL_FLASH_SALES?page=$page"),
      headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  if (response.statusCode != 200) {
    return false;
  } else {
    return res;
  }
}

get11Products(int page) async {
  var response = await http.get(
      Uri.parse(
          "${URL}getAvailableItems?api_key=$key_bath&page=$page&tag=11.11"),
      headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  if (response.statusCode != 200) {
    return false;
  } else {
    return res;
  }
}

getDiscountProducts(int page) async {
  var response = await http.get(
      Uri.parse(
          "${URL}getAvailableItems?api_key=$key_bath&page=$page&tag=discount"),
      headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  if (response.statusCode != 200) {
    return false;
  } else {
    return res;
  }
}

getShops(int page) async {
  var response =
      await http.get(Uri.parse("$URL_GET_SHOPS?page=$page"), headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  if (response.statusCode != 200) {
    return false;
  } else {
    return res;
  }
}

getAppSections() async {
  var response = await http
      .get(Uri.parse("$URL_APP_SECTIONS?api_key=$key_bath"), headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  if (response.statusCode != 200) {
    return false;
  } else {
    return res;
  }
}

getBestSellersProducts(int page) async {
  var response = await http.get(Uri.parse("$URL_TOP_SELLERS?page=$page"),
      headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  if (response.statusCode != 200) {
    return false;
  } else {
    return res;
  }
}

getProducts(int page) async {
  final cacheManager = CacheManager();
  final cacheKey = 'products_page_$page';
  final cachedData = await cacheManager.getCache(cacheKey);
  var seasonName = await FirebaseRemoteConfigClass().initilizeConfig();
  try {
    var response = await http.get(
        Uri.parse(
            "${URL}getAllItems?api_key=$key_bath&season=${seasonName.toString()}&page=$page"),
        headers: headers);

    var res = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      await cacheManager.setCache(cacheKey, res);
      return res;
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  } catch (e) {
    var DomainName = await FirebaseRemoteConfigClass().getDomain();
    var response = await http.get(
        Uri.parse(
            "http://$DomainName/api/getAllItems?api_key=$key_bath&season=${seasonName.toString()}&page=$page"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      await cacheManager.setCache(cacheKey, res);
      return res;
    } else {
      throw Exception(
          'Failed to load products from fallback: ${response.statusCode}');
    }
  }
}

getSliderProducts(url, page) async {
  var response = await http.get(Uri.parse("$url&page=$page"), headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  return res;
}

getDynamicSectionProducts(String url, int page) async {
  url = url.replaceAll(RegExp(r'(&page=\d+)'), '');
  var response = await http.get(Uri.parse("$url&page=$page"), headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  return res;
}

getSpeceficProduct(id) async {
  try {
    if (id.toString().endsWith(',')) {
      id = id.toString().substring(0, id.toString().length - 1);
    }
    print("// get item data //");
    print("$URL_SINGLE_PRODUCT?api_key=$key_bath&id=$id");
    var response = await http.get(
        Uri.parse("$URL_SINGLE_PRODUCT?api_key=$key_bath&id=$id"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  } catch (e) {
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

addOrder(
    {context,
    address,
    phone,
    city,
    name,
    description,
    total,
    copon,
    cityID,
    areaName,
    areaID}) async {
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
        "shop_id": cartProvider[i].shopId == "null"
            ? "1"
            : cartProvider[i].shopId.toString(),
        "data": [
          {
            "sku": cartProvider[i].sku.toString(),
            "name": cartProvider[i].name.toString(),
            "price": cartProvider[i].price.toString(),
            "quantity": int.parse(cartProvider[i].quantity.toString()),
            "size": cartProvider[i].type.toString(),
            "nickname": cartProvider[i].nickname.toString(),
            "vendor_sku": cartProvider[i].vendor_sku.toString(),
            "variant_index": 0,
            "place_in_warehouse": cartProvider[i].placeInWarehouse.toString()
          }
        ]
      });
      totalPrice += double.parse(cartProvider[i].price.toString()) *
          double.parse(cartProvider[i].quantity.toString());
    }

    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('${URL_ADD_ORDER}?api_key=$key_bath'));
    request.body = json.encode({
      "name": name.toString(),
      "page": "Fawri App",
      "description": description.toString(),
      "phone": phone.toString(),
      "address": address.toString(),
      "city": city.toString(),
      "total_price": double.parse(total.toString()),
      "user_id": 38,
      "location_ids": {
        "city_id": cityID.toString(),
        "area_id": areaID.toString(),
        "area_name": areaName.toString()
      },
      "products": products
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String stream = await response.stream.bytesToString();
      final decodedMap = json.decode(stream);
      final OrderController orderService = OrderController();
      final UsedCoponsController usedCoponService = UsedCoponsController();
      String Order_ID = Uuid().v4();
      String usedCopon_ID = Uuid().v4();
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);

      OrderFirebaseModel newItem = OrderFirebaseModel(
          id: Order_ID,
          tracking_number: "123456",
          number_of_products: cartProvider.length.toString(),
          sum: total.toString(),
          order_id: decodedMap["id"].toString(),
          user_id: UserID.toString(),
          created_at: formattedDate.toString());
      orderService.addUser(newItem);

      UsedCoponsFirebaseModel newUsedCoponItem = UsedCoponsFirebaseModel(
        id: usedCopon_ID,
        copon: usedCopon_ID.toString(),
        order_id: decodedMap["id"].toString(),
        user_id: UserID.toString(),
      );
      usedCoponService.addUsedCopon(newUsedCoponItem);
      return response.statusCode;
    } else {
      return 404;
    }
  } catch (e) {
    print("response");
    print(e);
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
          "shop_id": cartProvider[i].shopId.toString() == "null"
              ? "1"
              : cartProvider[i].shopId.toString(),
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
        final UsedCoponsController usedCoponService = UsedCoponsController();
        String Order_ID = Uuid().v4();
        String usedCopon_ID = Uuid().v4();
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
        UsedCoponsFirebaseModel newUsedCoponItem = UsedCoponsFirebaseModel(
          id: usedCopon_ID,
          copon: usedCopon_ID.toString(),
          order_id: decodedMap["id"].toString(),
          user_id: UserID.toString(),
        );
        usedCoponService.addUsedCopon(newUsedCoponItem);
      } else {
        return 404;
      }
    } catch (e) {
      return 404;
    }
  }
}

sendNotification({context, USER_TOKENS, productImage}) async {
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
      "image": productImage,
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
    if (size.isNotEmpty && size.toString() != "null" && size.toString() != "") {
      Final_URL =
          "$URL_PRODUCT_BY_CATEGORY?main_category=$category_id&sub_category=${sub_category_key_final}&${size != "null" || size != "" ? "size=${"$size,ONE SIZE"}" : ""}&season=${seasonName.toString()}&page=$page&api_key=$key_bath";
    } else {
      Final_URL =
          "$URL_PRODUCT_BY_CATEGORY?main_category=$category_id&sub_category=${sub_category_key_final}&season=${seasonName.toString()}&page=$page&api_key=$key_bath";
    }
    if (selected_sizes != '' && selected_sizes.toString() != "null") {
      Final_URL += "&size=$selected_sizes";
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
    if (size.isNotEmpty && size.toString() != "null") {
      Final_URL =
          "$DomainName/api/getAvailableItems?main_category=$category_id&sub_category=$sub_category_key_final&${size != "null" || size != "" ? "size=${size}" : ""}&season=${seasonName.toString()}&page=$page&api_key=$key_bath";
    } else {
      Final_URL =
          "$DomainName/api/getAvailableItems?main_category=$category_id&sub_category=$sub_category_key_final&season=${seasonName.toString()}&page=$page&api_key=$key_bath";
    }
    if (selected_sizes.isNotEmpty) {
      Final_URL += "&size=$selected_sizes";
    }
    var response = await http.get(Uri.parse(Final_URL), headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  }
}

getHomeData(int page) async {
  var seasonName = await FirebaseRemoteConfigClass().initilizeConfig();
  try {
    var response = await http.get(
        Uri.parse(
            "https://fawri-f7ab5f0e45b8.herokuapp.com/api/getAvailableItems?main_category=Home %26 Living, Home Living, Home Textile,Tools %26 Home Improvement&sub_category=&season=${seasonName.toString()}&page=1&api_key=H93J48593HFNWIEUTR287TG3"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  } catch (e) {
    var response = await http.get(
        Uri.parse(
            "https://fawri-f7ab5f0e45b8.herokuapp.com/api/getAvailableItems?main_category=Home %26 Living, Home Living, Home Textile,Tools %26 Home Improvement&sub_category=&season=${seasonName.toString()}&page=1&api_key=H93J48593HFNWIEUTR287TG3"),
        headers: headers);
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
  }
}

cancelOrder(int orderId, String reason, BuildContext context) async {
  final String apiKey = 'H93J48593HFNWIEUTR287TG3';
  final String url = 'https://fawri-f7ab5f0e45b8.herokuapp.com/api/cancelOrder';

  try {
    final response = await http.get(
      Uri.parse('$url?order_id=$orderId&reason=$reason&api_key=$apiKey'),
    );

    if (!context.mounted) return;

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "تم حذف الطلبية بنجاح!");
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'فشلت عملية الحذف , الرجاء المحاولة مرة أخرى');
    }
  } catch (e) {
    print('Error: $e');
    if (!context.mounted) return; // Ensure the widget is still mounted
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred. Please try again.')),
    );
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

getCoupunDeleteCose() async {
  var Final_URL = "$URL_DELETE_COST?api_key=$key_bath";
  var response = await http.get(Uri.parse(Final_URL), headers: headers);
  if (response.statusCode == 200) {
    var res = json.decode(utf8.decode(response.bodyBytes));
    return res;
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

Future<Map<int, Map<String, dynamic>>> checkProductAvailability(
    List<Map<String, dynamic>> items) async {
  try {
    var url =
        'https://fawri-f7ab5f0e45b8.herokuapp.com/api/checkProductAvailabilityList';
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'items': items});

    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    var res = json.decode(response.body);
    var availabilityMap = <int, Map<String, dynamic>>{};
    for (var item in res['items']) {
      var id = item['id'];
      var availabilityStr = item['availability'];
      var isAvailable = availabilityStr.contains('true');
      var availableQtyStr = availabilityStr.contains('available quantity:')
          ? availabilityStr.split('available quantity:').last.trim()
          : '0';
      var availableQty = int.tryParse(availableQtyStr) ?? 0;

      availabilityMap[id] = {
        'isAvailable': isAvailable,
        'availableQty': availableQty
      };
    }

    return availabilityMap;
  } catch (e) {
    print('Error checking product availability: $e');
    return {};
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
  Future.delayed(Duration(seconds: 300), () {
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
                        "لقد حصلت على كوبون خصم بقيمة 10% يمكنك استخدامه عند شرائك لأحد منتجاتنا",
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

String getThumbnailUrl(String imageUrl, int width, int height) {
  if (imageUrl.startsWith('https://img.ltwebstatic.com')) {
    // Extract the base URL and file extension
    final uri = Uri.parse(imageUrl);
    final pathSegments = uri.pathSegments;

    // Handle cases where the path may have multiple segments
    if (pathSegments.isNotEmpty) {
      final lastSegment = pathSegments
          .last; // Last segment, e.g., '1641353828b13dabf0345da19c50e70fd7c116752d.jpg'
      final extensionIndex = lastSegment.lastIndexOf('.');

      if (extensionIndex != -1) {
        final baseUrl = uri.toString().substring(
            0, uri.toString().length - (lastSegment.length - extensionIndex));
        final extension = lastSegment.substring(extensionIndex);

        // Construct the new thumbnail URL
        return '${baseUrl}_thumbnail_${width}x$height$extension';
      }
    }
  }
  // Return original URL if it does not match the criteria
  return imageUrl;
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
                  searchResults.length == 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            "لا يوجد اية نتائج",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        )
                      : Visibility(
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
                                    if (searchResults[index]["type"] ==
                                        "title") {
                                      NavigatorFunction(
                                          context,
                                          ProductsCategories(
                                              sizes: "",
                                              SIZES: [],
                                              name: main_category,
                                              category_id: main_category,
                                              size: "",
                                              title: searchResults[index]
                                                      ["word"]
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
                                              title: searchResults[index]
                                                      ["word"]
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
                                                      ? searchResults[index]
                                                              ["word"]
                                                          .toString()
                                                          .substring(0, 35)
                                                      : searchResults[index]
                                                              ["word"]
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: const Color.fromARGB(
                                            255, 236, 236, 236),
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
