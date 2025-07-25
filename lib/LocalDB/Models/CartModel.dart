class CartItem {
  final int? id;
  final int productId; // Unique identifier for the product
  final String name;
  final String shopId;
  final String image;
  final double price;
  final String type;
  final String sku;
  final String nickname;
  final String vendor_sku;
  final String placeInWarehouse;
  int quantity;
  int quantityExist;
  int availability;
  int user_id;

  CartItem(
      {this.id,
      required this.productId,
      required this.availability,
      required this.placeInWarehouse,
      required this.name,
      required this.shopId,
      required this.type,
      required this.image,
      required this.price,
      required this.user_id,
      required this.sku,
      required this.nickname,
      required this.quantityExist,
      required this.vendor_sku,
      this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'availability': availability,
      'quantityExist': quantityExist,
      'name': name,
      'shopId': shopId,
      'sku': sku,
      'nickname': nickname,
      'vendor_sku': vendor_sku,
      'image': image,
      'price': price,
      'type': type,
      'place_in_warehouse': placeInWarehouse,
      'user_id': user_id,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      quantityExist: json['quantityExist'],
      availability: json['availability'],
      name: json['name'],
      shopId: json['shopId'],
      placeInWarehouse: json['place_in_warehouse'],
      type: json['type'],
      sku: json['sku'],
      nickname: json['nickname'],
      vendor_sku: json['vendor_sku'],
      image: json['image'],
      price: json['price'],
      user_id: json['user_id'],
      quantity: json['quantity'],
    );
  }

  CartItem copyWith({
    int? id,
    int? productId,
    int? quantityExist,
    int? availability,
    String? name,
    String? shopId,
    String? type,
    String? sku,
    String? nickname,
    String? vendor_sku,
    String? image,
    String? placeInWarehouse,
    double? price,
    int? quantity,
    int? user_id,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantityExist: quantityExist ?? this.quantityExist,
      availability: availability ?? this.availability,
      name: name ?? this.name,
      shopId: shopId ?? this.shopId,
      price: price ?? this.price,
      type: type ?? this.type,
      sku: sku ?? this.sku,
      nickname: nickname ?? this.nickname,
      vendor_sku: vendor_sku ?? this.vendor_sku,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      user_id: user_id ?? this.user_id,
      placeInWarehouse: placeInWarehouse ?? this.placeInWarehouse,
    );
  }
}
