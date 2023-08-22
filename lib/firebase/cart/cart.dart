// class CartItem {
//   final String id;
//   final String user_id;
//   final String product_id;

//   CartItem({
//     required this.id,
//     required this.user_id,
//     required this.product_id,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'user_id': user_id,
//       'product_id': product_id,
//     };
//   }

//   factory CartItem.fromMap(Map<String, dynamic>? map) {
//     return CartItem(
//       id: map?['id'] ?? '',
//       user_id: map?['user_id'] ?? '',
//       product_id: map?['product_id'] ?? "",
//     );
//   }
// }
