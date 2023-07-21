import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../domain/domain.dart';

var headers = {'ContentType': 'application/json', "Connection": "Keep-Alive"};

NavigatorFunction(BuildContext context, Widget Widget) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Widget));
}

getProducts() async {
  var response = await http.get(
      Uri.parse(
          "http://34.227.78.214/api/getAllItems?api_key=H93J48593HFNWIEUTR287TG3&page=12"),
      headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  return res;
}

getProductByCategory(category_id, int page) async {
  var response = await http.get(
      Uri.parse(
          "$URL_PRODUCT_BY_CATEGORY?main_category=$category_id&season=Summer&page=$page&api_key=$key_bath"),
      headers: headers);
  var res = json.decode(utf8.decode(response.bodyBytes));
  return res;
}
