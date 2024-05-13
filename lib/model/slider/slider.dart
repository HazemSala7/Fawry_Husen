class Silder {
  String image;
  String description;
  String title;
  String product_id;
  String action;

  Silder({
    required this.image,
    required this.description,
    required this.title,
    required this.product_id,
    required this.action,
  });

  factory Silder.fromJson(Map<String, dynamic> json) {
    return Silder(
      image: json['image_url'] ?? "",
      product_id: json['url'] ?? "",
      description: json['description'] ?? "",
      title: json['title'] ?? "",
      action: json['action'] ?? "",
    );
  }
}
