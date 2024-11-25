class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final int price;
  final String brand;
  final String category;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.brand,
    required this.category,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] as int,
      orderId: map['order_id'] as int,
      productId: map['product_id'] as int,
      productName: map['product_name'] as String,
      productImage: map['product_image'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as int,
      brand: map['brand'] as String,
      category: map['category'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'quantity': quantity,
      'price': price,
      'brand': brand,
      'category': category,
    };
  }
}
