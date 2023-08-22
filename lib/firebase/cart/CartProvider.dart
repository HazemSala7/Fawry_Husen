// import 'package:flutter/material.dart';

// import 'CartController.dart';
// import 'cart.dart'; // Import your CartItem model

// class CartProvider extends ChangeNotifier {
//   List<CartItem> cartItems = []; // Change the type to your CartItem model

//   final CartService _cartService = CartService();

//   Future<void> loadCartItems(String userId) async {
//     cartItems = await _cartService.getCartItemsForUser(userId).first;
//     notifyListeners();
//   }

//   Future<void> addToCart(CartItem cartItem) async {
//     await _cartService.addToCart(cartItem);
//     cartItems.add(cartItem);
//     notifyListeners();
//   }

//   Future<void> removeFromCart(String cartItemId) async {
//     await _cartService.deleteCartItemFunction(cartItemId);
//     cartItems.removeWhere((item) => item.id == cartItemId);
//     notifyListeners();
//   }

//   // ... Other methods for updating and deleting cart items
// }
