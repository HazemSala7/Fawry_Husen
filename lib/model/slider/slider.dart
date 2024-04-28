class Silder {
  String image;
  String description;
  String title;
  String product_id;

  Silder({
    required this.image,
    required this.description,
    required this.title,
    required this.product_id,
  });

  factory Silder.fromJson(Map<String, dynamic> json) {
    return Silder(
      image: json['image'] ?? "",
      product_id: json['url'] ?? "",
      description: json['description'] ?? "",
      title: json['title'] ?? "",
    );
  }
}
