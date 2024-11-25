import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import '../../model/order/order_item.dart';
import '../../model/basket/basket_item.dart';

class OrderDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // BasketItem'ları OrderItem'lara dönüştürme fonksiyonu
  List<OrderItem> convertBasketItemsToOrderItems(
      List<BasketItem> basketItems, int orderId) {
    return basketItems.map((basketItem) {
      return OrderItem(
        id: 0,
        orderId: orderId,
        productId: basketItem.id,
        productName: basketItem.name,
        productImage: basketItem.image,
        quantity: basketItem.orderAmount,
        price: basketItem.price,
        brand: basketItem.brand ,
        category: basketItem.category ,
      );
    }).toList();
  }

  // Sipariş ve sipariş ürünlerini ekleme
  Future<void> addOrder(int totalPrice, String userName, List<OrderItem> items) async {
    final db = await _dbHelper.database;
    final orderDate = DateTime.now().toIso8601String();

    try {
      if (userName.isEmpty || items.isEmpty) {
        throw Exception("Invalid userName or empty order items.");
      }

      await db.transaction((txn) async {
        final orderId = await txn.insert(
          'orders',
          {
            'user_name': userName,
            'total_price': totalPrice,
            'order_date': orderDate,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        print("Order added with ID: $orderId for user: $userName");

        for (var item in items) {
          await txn.insert(
            'order_items',
            {
              'order_id': orderId,
              'product_id': item.productId,
              'product_name': item.productName,
              'product_image': item.productImage,
              'quantity': item.quantity,
              'price': item.price,
              'brand': item.brand, // Brand ekleme
              'category': item.category, // Category ekleme
            },
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
        print("Order items added for Order ID: $orderId");
      });
    } catch (e) {
      print("Error adding order: $e");
      throw Exception("Failed to add order.");
    }
  }

  // Kullanıcının tüm siparişlerini alma
  Future<List<Map<String, dynamic>>> getOrders(String userName) async {
    final db = await _dbHelper.database;
    try {
      print("Running query for user: $userName...");
      final orders = await db.query(
        'orders',
        where: 'user_name = ?',
        whereArgs: [userName],
      );

      if (orders.isEmpty) {
        print("No orders found for user: $userName.");
      } else {
        print("Orders found for user: $userName. Total: ${orders.length}");
      }
      return orders;
    } catch (e) {
      print("Error fetching orders for user: $userName. Error: $e");
      throw Exception("Failed to fetch orders.");
    }
  }

  // Siparişi ve ilişkili ürünleri silme
  Future<void> deleteOrder(int orderId) async {
    final db = await _dbHelper.database;
    try {
      if (orderId <= 0) {
        throw Exception("Invalid orderId: $orderId");
      }

      await db.transaction((txn) async {
        // Önce 'order_items' tablosundan ürünleri sil
        final itemsDeleted = await txn.delete(
          'order_items',
          where: 'order_id = ?',
          whereArgs: [orderId],
        );

        print("$itemsDeleted items deleted for Order ID: $orderId.");

        // Ardından 'orders' tablosundan siparişi sil
        final ordersDeleted = await txn.delete(
          'orders',
          where: 'id = ?',
          whereArgs: [orderId],
        );

        if (ordersDeleted == 0) {
          print("No order found with ID $orderId to delete.");
        } else {
          print("Order ID $orderId deleted successfully.");
        }
      });
    } catch (e) {
      print("Error deleting order: $e");
      throw Exception("Failed to delete order.");
    }
  }

  // Belirli bir siparişin ürünlerini getirme
  Future<List<OrderItem>> getOrderItems(int orderId) async {
    final db = await _dbHelper.database;
    try {
      print("Fetching order items for order ID: $orderId...");
      final items = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );

      if (items.isEmpty) {
        print("No items found for Order ID: $orderId.");
        return [];
      }

      print("Order items fetched for Order ID: $orderId. Total: ${items.length}");
      return items.map((item) => OrderItem.fromMap(item)).toList();
    } catch (e) {
      print("Error fetching items for Order ID: $orderId. Error: $e");
      throw Exception("Failed to fetch order items.");
    }
  }
}
