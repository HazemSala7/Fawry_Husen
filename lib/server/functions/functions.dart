import 'package:fawri_app_refactor/services/remote_config_firebase/remote_config_firebase.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fawri_app_refactor/LocalDB/Provider/CartProvider.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../../LocalDB/Models/FavoriteItem.dart';
import '../../LocalDB/Provider/FavouriteProvider.dart';
import '../../firebase/favourites/FavouriteControler.dart';
import '../../firebase/favourites/favourite.dart';
import '../domain/domain.dart';

var headers = {'ContentType': 'application/json', "Connection": "Keep-Alive"};

NavigatorFunction(BuildContext context, Widget Widget) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Widget));
}

getProducts(int page) async {
  var response = await http.get(
      Uri.parse(
          "http://54.91.80.40:3000/api/getAllItems?api_key=$key_bath&page=$page"),
      headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  return res;
}

getSpeceficProduct(id) async {
  if (id.toString().endsWith(',')) {
    id = id.toString().substring(0, id.toString().length - 1);
  }

  var response = await http.get(
      Uri.parse("$URL_SINGLE_PRODUCT?id=$id&api_key=$key_bath"),
      headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  return res;
}

addOrder({context, address, phone, city, name}) async {
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
      'POST',
      Uri.parse(
          'http://54.91.80.40:3000/api/orders/submitOrder?api_key=H93J48593HFNWIEUTR287TG3'));
  request.body = json.encode({
    "name": name.toString(),
    "page": "Fawri App",
    "description": "description Test",
    "phone": phone.toString(),
    "address": address.toString(),
    "city": city.toString(),
    "total_price": totalPrice,
    "user_id": UserID.toString(),
    "products": products
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

sendNotification({context}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? TOKEN = await prefs.getString('device_token') ?? "-";
  var headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAACwl5eY0:APA91bHHuJ0hAZrN5X9Pxmygq8He3SwM0_2wXsUMC0JaPT3R12FWQnc3A0E9LaDEDieuwHa4lRCeYSObgT5nroTscoUjUA9CX3a6cYG9fa0L0sB-YPvVEqdk5ekMOyb24b8COE_rsuCz'
  };
  var request =
      http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
  request.body = json.encode({
    "notification": {
      "title": "Fawri App",
      "body": "الامنتج الذي تم اضافته الى السله لم يتبقى منه الا 2"
    },
    "to": TOKEN
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

getProductByCategory(
    category_id, sub_category_key, String size, int page) async {
  var seasonName = await FirebaseRemoteConfigClass().initilizeConfig();
  var response = await http.get(
      Uri.parse(
          "$URL_PRODUCT_BY_CATEGORY?main_category=$category_id&sub_category=$sub_category_key&${size != "null" ? "size=${size}" : ""}&season=${seasonName.toString()}&page=$page&api_key=$key_bath"),
      headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  return res;
}

getSizesByCategory(category_id, context) async {
  var response = await http.get(
      Uri.parse(
          "$URL_SIZES_BY_CATEGORY?main_category=$category_id&season=Summer&api_key=$key_bath"),
      headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  Navigator.of(context, rootNavigator: true).pop();

  return res["sizes"];
}

showDelayedDialog(context) {
  Future.delayed(Duration(seconds: 2), () {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(0),
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
                      "تم ارسال هديه اليك  و هي كوبون بقيمة خصم 30% من قيمة الطلبية و هو 1551",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  });
}
