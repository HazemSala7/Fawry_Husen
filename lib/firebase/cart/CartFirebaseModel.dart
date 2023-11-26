class CartFirebaseModel {
  final String id;
  final String user_id;
  final String product_id;
  final String user_token;

  CartFirebaseModel({
    required this.id,
    required this.user_id,
    required this.product_id,
    required this.user_token,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'product_id': product_id,
      'user_token': user_token,
    };
  }

  factory CartFirebaseModel.fromMap(Map<String, dynamic>? map) {
    return CartFirebaseModel(
      id: map?['id'] ?? '',
      user_id: map?['user_id'] ?? '',
      product_id: map?['product_id'] ?? "",
      user_token: map?['user_token'] ?? "",
    );
  }
}
