import 'package:fawri_app_refactor/LocalDB/DataBase/DataBase.dart';
import 'package:flutter/material.dart';
import '../Models/AddressItem.dart';

class AddressProvider extends ChangeNotifier {
  List<AddressItem> _addressItems = [];
  CartDatabaseHelper _dbHelper = CartDatabaseHelper();

  List<AddressItem> get addressItems => _addressItems;
  int get addressItemsCount => _addressItems.length;

  AddressProvider() {
    _init();
  }

  Future<void> _init() async {
    _addressItems = await _dbHelper.getAddresses();
    notifyListeners();
  }

  Future<void> addToAddress(AddressItem item) async {
    // Insert the item into the database
    await _dbHelper.insertAddressItem(item);

    // Refresh _addressItems with the latest data from the database
    _addressItems = await _dbHelper.getUserAddresses();

    // Notify listeners after updating the list
    notifyListeners();
  }

  Future<void> removeFromAddress(int addressId) async {
    await _dbHelper.deleteAddressItem(addressId);
    _addressItems.removeWhere((item) => item.id == addressId);
    notifyListeners();
  }

  Future<void> clearAddress() async {
    _addressItems.clear();
    await _dbHelper.clearCart();
    notifyListeners();
  }

  void updateCartItem(AddressItem item) async {
    await _dbHelper.updateAddressItem(item);
    _addressItems = await _dbHelper.getUserAddresses();
    notifyListeners();
  }

  List<Map<String, dynamic>> getProductsArray() {
    List<Map<String, dynamic>> productsArray = [];

    for (AddressItem item in _addressItems) {
      Map<String, dynamic> productData = {
        'id': item.id,
        'user_id': item.user_id,
        'name': item.name,
      };
      productsArray.add(productData);
    }

    return productsArray;
  }
}
