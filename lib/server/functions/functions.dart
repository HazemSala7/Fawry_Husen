import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
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
          "http://34.227.78.214/api/getAllItems?api_key=$key_bath&page=$page"),
      headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  return res;
}

getSpeceficProduct(id) async {
  if (id.toString().endsWith(',')) {
    id = id.toString().substring(0, id.toString().length - 1);
  }
  print("$URL_SINGLE_PRODUCT?id=$id&api_key=$key_bath");
  var response = await http.get(
      Uri.parse("$URL_SINGLE_PRODUCT?id=$id&api_key=$key_bath"),
      headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  return res;
}

addOrder({context, address, phone, city}) async {
  SharedPreferences prefs =
  await SharedPreferences.getInstance();
  String UserID = prefs.getString('user_id') ?? "";

  final cartProvider = Provider.of<CartProvider>(context, listen: false).cartItems;
  List products = [];
  double totalPrice = 0.0;
  for (var i = 0; i < cartProvider.length; i++) {
    products.add({
      "id": cartProvider[i].id.toString(),
      "image": cartProvider[i].image.toString(),
      "data": [
        {
          "sku": "U7IBYP",
          "name": cartProvider[i].name.toString(),
          "price": cartProvider[i].price.toString(),
          "quantity": 1,
          "size": cartProvider[i].type.toString(),
          "nickname": "TEST",
          "vendor_sku": "sa2211175146616151",
          "variant_index": 0,
          "place_in_warehouse": "TEST"
        }
      ]
    });
    totalPrice += double.parse(cartProvider[i].price.toString());
  }

  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'POST',
      Uri.parse(
          'http://34.227.78.214/api/orders/submitOrder?api_key=H93J48593HFNWIEUTR287TG3'));
  request.body = json.encode({
    "name": "Husen TEST",
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
    print(decodedMap["id"]);
  } else {
    print(response.reasonPhrase);
  }
}

getProductByCategory(
    category_id, sub_category_key, String size, int page) async {
  var response = await http.get(
      Uri.parse(
          "$URL_PRODUCT_BY_CATEGORY?main_category=$category_id&sub_category=$sub_category_key&size=$size&season=Summer&page=$page&api_key=$key_bath"),
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
