import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/order/order.dart';
import '../../model/order/order_item.dart';
import '../../repo/sqlite/order_dao.dart';
import '../../util/session_manager.dart';

class OrderCubit extends Cubit<List<Order>> {
  final OrderDao _orderDao;
  final SessionManager _sessionManager;

  OrderCubit(this._orderDao, this._sessionManager) : super([]);

  // Tüm siparişleri yükleme (order_items ile birlikte)
  Future<void> loadOrders() async {
    try {
      final userName = await _sessionManager.getUsername();
      if (userName == null || userName.isEmpty) {
        throw Exception("User is not logged in.");
      }

      final ordersData = await _orderDao.getOrders(userName); // Kullanıcı adına göre filtreleme
      final List<Order> orders = [];

      for (final orderMap in ordersData) {
        final order = Order.fromMap(orderMap);
        try {
          // Siparişe ait ürünleri al
          final orderItems = await _orderDao.getOrderItems(order.id);
          order.items = orderItems; // Order modeline ürünleri ekle
        } catch (e) {
          print("Error loading items for order ID: ${order.id} -> $e");
          order.items = []; // Hata durumunda boş liste atanır
        }
        orders.add(order);
      }

      emit(orders);
      print("Loaded ${orders.length} orders for user: $userName.");
    } catch (e) {
      print("Error loading orders: $e");
    }
  }

  // Yeni sipariş ekleme
  Future<void> addOrder(int totalPrice, List<OrderItem> items) async {
    try {
      final userName = await _sessionManager.getUsername();
      if (userName == null || userName.isEmpty) {
        throw Exception("User is not logged in.");
      }

      if (items.isEmpty) {
        throw Exception("Cannot place an order with no items.");
      }

      print("Adding a new order for user: $userName...");
      await _orderDao.addOrder(totalPrice, userName, items);
      await loadOrders(); // Sipariş eklendikten sonra listeyi yeniden yükle
      print("Order added successfully.");
    } catch (e) {
      print("Error adding order: $e");
    }
  }

  // Sipariş silme (order_items ile birlikte)
  Future<void> deleteOrder(int orderId) async {
    try {
      print("Deleting order with ID: $orderId...");
      await _orderDao.deleteOrder(orderId); // Sipariş ve ilişkili ürünler silinir
      await loadOrders(); // Listeyi güncelle
      print("Order deleted successfully.");
    } catch (e) {
      print("Error deleting order: $e");
    }
  }

  void clearOrders() {
    emit([]); // Sipariş listesini sıfırla
    print("OrderCubit state cleared.");
  }

}
