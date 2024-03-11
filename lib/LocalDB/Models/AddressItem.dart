class AddressItem {
  final int? id;
  final String name;
  final String user_id;

  AddressItem({
    this.id,
    required this.user_id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'name': name,
    };
  }

  factory AddressItem.fromJson(Map<String, dynamic> json) {
    return AddressItem(
      id: json['id'],
      user_id: json['user_id'],
      name: json['name'],
    );
  }

  AddressItem copyWith({
    int? id,
    String? user_id,
    String? name,
  }) {
    return AddressItem(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      name: name ?? this.name,
    );
  }
}
