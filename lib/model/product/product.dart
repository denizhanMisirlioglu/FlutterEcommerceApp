class Product {
  int id;
  String name;
  String image;
  String category;
  int price;
  String brand;

  Product(
      {required this.id,
      required this.name,
      required this.image,
      required this.category,
      required this.price,
      required this.brand});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()) ?? -1, // hatalı tür ve null kontrolü
      name: json["ad"]?.toString() ?? "No Name",
      image: json["resim"]?.toString() ?? "No Image",
      category: json["kategori"]?.toString() ?? "No Category",
      price: json["fiyat"] is int ? json["fiyat"] : int.tryParse(json["fiyat"].toString()) ?? 0,
      brand: json["marka"]?.toString() ?? "No Brand",
    );
  }
}
