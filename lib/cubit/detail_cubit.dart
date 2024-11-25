import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/model/product/product.dart';
import 'package:flutter_ecommerce_project/repo/ecommerce_dao_repository.dart';
import '../util/session_manager.dart';

class DetailCubit extends Cubit<int> {
  final EcommerceDaoRepository repo;
  final SessionManager sessionManager;

  DetailCubit(this.repo,this.sessionManager) : super(1); // Varsayılan seçili ürün   miktarı 1

  /// Sepetteki ürün miktarı
  int get quantity => state;

  /// Miktarı artırma
  void incrementQuantity() {  // sepete eklenecek ürün miktarını 1 arttır
    emit(quantity + 1);
  }

  /// Miktarı azaltma
  void decrementQuantity() { // sepete eklenecek ürün miktarını 1 azaltır
    if (quantity > 1) {
      emit(quantity - 1);
    }
  }

  /// Sepete ürün ekleme
  Future<void> addProductToBasket(Product product) async {
    try {
      final username = await sessionManager.getUsername(); // Oturumdaki kullanıcı adını  al
      await repo.addProductToBasket(product, quantity,username!); // Repository çağrısı
    } catch (e) {
      print("Error adding product to basket: $e");
    }
  }
}
