class AddressItem {
  final int? id;
  final String name;
  final String user_id;
  final String city_id;
  final String area_id;
  final String area_name;

  AddressItem({
    this.id,
    required this.user_id,
    required this.area_id,
    required this.city_id,
    required this.area_name,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'name': name,
      'area_name': area_name,
      'area_id': area_id,
      'city_id': city_id,
    };
  }

  factory AddressItem.fromJson(Map<String, dynamic> json) {
    return AddressItem(
      id: json['id'],
      user_id: json['user_id'],
      name: json['name'],
      area_name: json['area_name'],
      area_id: json['area_id'],
      city_id: json['city_id'],
    );
  }

  AddressItem copyWith({
    int? id,
    String? user_id,
    String? city_id,
    String? area_id,
    String? area_name,
    String? name,
  }) {
    return AddressItem(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      area_id: area_id ?? this.area_id,
      city_id: city_id ?? this.city_id,
      area_name: area_name ?? this.area_name,
      name: name ?? this.name,
    );
  }
}
