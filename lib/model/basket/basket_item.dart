class BasketItem {
  int id;
  String name;
  String image;
  String category;
  int price;
  String brand;
  int orderAmount;
  String userName;

  BasketItem({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    required this.brand,
    required this.orderAmount,
    required this.userName,
  });

  factory BasketItem.fromJson(Map<String, dynamic> json) {
    return BasketItem(
      id: json["sepetId"] as int,
      name: json["ad"] as String,
      image: json["resim"] as String,
      category: json["kategori"] as String,
      price: json["fiyat"] as int,
      brand: json["marka"] as String,
      orderAmount: json["siparisAdeti"] as int,
      userName: json["kullaniciAdi"] as String,
    );
  }
}
