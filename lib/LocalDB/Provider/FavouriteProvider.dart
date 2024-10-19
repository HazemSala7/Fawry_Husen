import 'package:flutter/material.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import '../DataBase/DataBase.dart';
import '../Models/FavoriteItem.dart';

class FavouriteProvider extends ChangeNotifier {
  List<FavoriteItem> _favouritesItems = [];
  CartDatabaseHelper _dbHelper = CartDatabaseHelper();

  List<FavoriteItem> get favoriteItems => _favouritesItems;

  CartProvider() {
    _init();
  }

  getFavouritesItems() {
    _favouritesItems = [];
    for (int i = 0; i < LocalStorage().favorites.length; i++) {
      _favouritesItems.add(FavoriteItem(
          id: LocalStorage().favorites[i]["id"],
          productId: LocalStorage().favorites[i]["productId"],
          name: LocalStorage().favorites[i]["name"],
          image: LocalStorage().favorites[i]["image"],
          price: LocalStorage().favorites[i]["price"]));
    }
  }

  Future<void> _init() async {
    _favouritesItems = await _dbHelper.getFavoriteItems();
    notifyListeners();
  }

  Future<void> addToFavorite(FavoriteItem item) async {
    final existingIndex = _favouritesItems
        .indexWhere((cartItem) => cartItem.productId == item.productId);
    // Item does not exist in the cart, add it as a new item
    await _dbHelper.insertFavoriteItem(item);
    _favouritesItems.add(item);
    // Refresh _cartItems with the latest data from the database
    _favouritesItems = await _dbHelper.getFavoriteItems();

    notifyListeners();
  }

  bool isProductFavorite(int productId) {
    return _favouritesItems.any((item) => item.productId == productId);
  }

  Future<void> removeFromFavorite(int productId) async {
    // await _dbHelper.deleteFavoriteItem(productId);
    // _favouritesItems.removeWhere((item) => item.productId == productId);
    LocalStorage().deleteFavorite(productId.toString());
    notifyListeners();
  }

  Future<void> clearCart() async {
    _favouritesItems.clear(); // Clear the cart items in memory
    await _dbHelper.clearCart(); // Clear the cart items from the local database
    notifyListeners(); // Notify the listeners about the change
  }

  Future<FavoriteItem?> getFavoriteItemByProductId(int productId) async {
    return await CartDatabaseHelper().getFavoriteItemByProductId(productId);
  }

  List<Map<String, dynamic>> getProductsArray() {
    List<Map<String, dynamic>> productsArray = [];

    for (FavoriteItem item in _favouritesItems) {
      Map<String, dynamic> productData = {
        'product_id': item.productId,
        'name': item.name,
        'image': item.image,
        'price': item.price,
      };
      productsArray.add(productData);
    }

    return productsArray;
  }
}
