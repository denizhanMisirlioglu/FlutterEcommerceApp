import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/order/order.dart';
import '../../repo/sqlite/order_dao.dart';
import '../../util/session_manager.dart';

class AccountCubit extends Cubit<Map<String, dynamic>> {
  final OrderDao _orderDao;
  final SessionManager _sessionManager;

  AccountCubit(this._orderDao, this._sessionManager) : super({});

  // Kullanıcı bilgilerini ve siparişlerini yükle
  Future<void> loadAccountInfo() async {
    try {
      final userName = await _sessionManager.getUsername();
      if (userName == null || userName.isEmpty) {
        throw Exception("Invalid or missing username in session.");
      }

      print("Fetching orders for user: $userName...");
      final ordersData = await _orderDao.getOrders(userName);

      // Map verisini order object listesine dönüştür
      final orders =
          ordersData.map<Order>((orderMap) => Order.fromMap(orderMap)).toList();

      print("Orders fetched: $orders");
      emit({
        "userName": userName,
        "orders": orders,
      });

      print("Emitting account state: userName: $userName, orders: $orders");
    } catch (e) {
      print("Error loading account info: $e");
      emit({});
    }
  }

  // AccountCubit'i sıfırla
  void clearAccount() {
    emit({}); // Cubit'i boş bir state ile sıfırla
    print("AccountCubit cleared.");
  }
}
