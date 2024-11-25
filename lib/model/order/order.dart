import 'order_item.dart';

class Order {
  final int id;
  final String userName;
  final double totalPrice;
  final DateTime orderDate;
  List<OrderItem> items;

  Order({
    required this.id,
    required this.userName,
    required this.totalPrice,
    required this.orderDate,
    this.items = const [],
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int,
      userName: map['user_name'] as String,
      totalPrice: map['total_price'] as double,
      orderDate: DateTime.parse(map['order_date'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_name': userName,
      'total_price': totalPrice,
      'order_date': orderDate.toIso8601String(),
    };
  }
}
