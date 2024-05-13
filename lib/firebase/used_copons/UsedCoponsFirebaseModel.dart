class UsedCoponsFirebaseModel {
  final String id;
  final String order_id;
  final String user_id;
  final String copon;

  UsedCoponsFirebaseModel({
    required this.id,
    required this.order_id,
    required this.user_id,
    required this.copon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': order_id,
      'user_id': user_id,
      'copon': copon,
    };
  }

  factory UsedCoponsFirebaseModel.fromMap(Map<String, dynamic>? map) {
    return UsedCoponsFirebaseModel(
      id: map?['id'] ?? '',
      order_id: map?['order_id'] ?? '',
      user_id: map?['user_id'] ?? '',
      copon: map?['copon'] ?? "",
    );
  }
}
