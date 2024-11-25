import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/model/basket/basket_item.dart';
import 'package:flutter_ecommerce_project/repo/ecommerce_dao_repository.dart';

import '../../util/session_manager.dart';

class BasketCubit extends Cubit<List<BasketItem>> {
  final EcommerceDaoRepository repo;
  final SessionManager sessionManager;

  BasketCubit(this.repo,this.sessionManager) : super(<BasketItem>[]);

  /// Sepetteki ürünleri yükleme
  Future<void> getBasketItems() async {
    try {
      final username = await sessionManager.getUsername(); // Kullanıcı adını dinamik olarak al
      var basketItems = await repo.getBasketItems(username!); // sepetten ürünleri alırken username kullanılıyor
      emit(basketItems);
    } catch (e) {
      print("Error fetching basket items: $e");
    }
  }

  /// Sepetten ürün silme
  Future<void> deleteBasketItem(BasketItem basketItem) async {
    try {
      final username = await sessionManager.getUsername();
      await repo.deleteBasketItem(basketItem,username!);
      await getBasketItems();
    } catch (e) {
      print("Error deleting basket item: $e");
    }
  }

  /// Sepeti tamamen temizleme
  Future<void> clearBasket() async {
    try {
      final username = await sessionManager.getUsername();
      await repo.clearBasket(username!); // Tüm sepet öğelerini silmek için repo çağrısı
      emit([]); // Sepeti sıfırla
      print("Basket cleared.");
    } catch (e) {
      print("Error clearing basket: $e");
    }
  }

  /// Sepetteki ürünleri order formatına dönüştür
  List<Map<String, dynamic>> prepareOrderDetails() {
    return state.map((basketItem) {
      return {
        "productId": basketItem.id,
        "productName": basketItem.name,
        "quantity": basketItem.orderAmount,
        "price": basketItem.price,
      };
    }).toList();
  }
}
