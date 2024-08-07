import 'dart:convert';
import 'package:flutter/material.dart';
import '../DataBase/DataBase.dart';
import '../Models/CartModel.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  CartDatabaseHelper _dbHelper = CartDatabaseHelper();

  List<CartItem> get cartItems => _cartItems;
  int get cartItemsCount => _cartItems.length;

  CartProvider() {
    _init();
  }

  Future<void> _init() async {
    _cartItems = await _dbHelper.getCartItems();
    notifyListeners();
  }

  double calculateTotal() {
    double total = 0;
    for (CartItem item in _cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  Future<void> updateCartItemById(int productId, CartItem updatedItem) async {
    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      _cartItems[index] = updatedItem;
      await _dbHelper.updateCartItem(updatedItem);
      notifyListeners();
    }
  }

  Future<void> addToCart(CartItem item) async {
    final existingIndex = _cartItems
        .indexWhere((cartItem) => cartItem.productId == item.productId);

    if (existingIndex != -1) {
      // Item already exists in the cart, increment the quantity
      _cartItems[existingIndex].quantity += item.quantity;
      await _dbHelper.updateCartItem(
          _cartItems[existingIndex]); // Update the item in the database
    } else {
      // Item does not exist in the cart, add it as a new item
      await _dbHelper.insertCartItem(item);
      _cartItems.add(item);
    }

    // Refresh _cartItems with the latest data from the database
    _cartItems = await _dbHelper.getCartItems();

    notifyListeners();
  }

  Future<void> removeFromCart(int productId) async {
    await _dbHelper.deleteCartItem(productId);
    _cartItems.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cartItems.clear(); // Clear the cart items in memory
    await _dbHelper.clearCart(); // Clear the cart items from the local database
    notifyListeners(); // Notify the listeners about the change
  }

  void updateCartItem(CartItem item) async {
    await _dbHelper.updateCartItem(item);
    // Refresh _cartItems with the latest data from the database
    _cartItems = await _dbHelper.getCartItems();
    notifyListeners();
  }

  bool isProductCart(int productId) {
    return _cartItems.any((item) => item.productId == productId);
  }

  Future<CartItem?> getCartItemByProductId(int productId) async {
    return await CartDatabaseHelper().getCartItemByProductId(productId);
  }

  List<Map<String, dynamic>> getProductsArray() {
    List<Map<String, dynamic>> productsArray = [];

    for (CartItem item in _cartItems) {
      Map<String, dynamic> productData = {
        'product_id': item.productId,
        'name': item.name,
        'image': item.image,
        'price': item.price,
        'quantity': item.quantity,
        'sku': item.sku,
        'vendor_sku': item.vendor_sku,
        'nickname': item.nickname,
        'availability': item.availability,
        'quantityExist': item.quantityExist,
      };
      productsArray.add(productData);
    }

    return productsArray;
  }
}
