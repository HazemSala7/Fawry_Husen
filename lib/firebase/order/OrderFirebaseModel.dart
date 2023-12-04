class OrderFirebaseModel {
  final String id;
  final String order_id;
  final String user_id;
  final String number_of_products;
  final String sum;
  final String tracking_number;
  final String created_at;

  OrderFirebaseModel({
    required this.id,
    required this.order_id,
    required this.user_id,
    required this.tracking_number,
    required this.sum,
    required this.number_of_products,
    required this.created_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': order_id,
      'user_id': user_id,
      'tracking_number': tracking_number,
      'sum': sum,
      'number_of_products': number_of_products,
      'created_at': created_at,
    };
  }

  factory OrderFirebaseModel.fromMap(Map<String, dynamic>? map) {
    return OrderFirebaseModel(
      id: map?['id'] ?? '',
      order_id: map?['order_id'] ?? '',
      user_id: map?['user_id'] ?? '',
      tracking_number: map?['tracking_number'] ?? "",
      number_of_products: map?['number_of_products'] ?? "",
      sum: map?['sum'] ?? "",
      created_at: map?['created_at'] ?? "",
    );
  }
}
