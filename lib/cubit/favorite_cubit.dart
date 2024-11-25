import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/product/product.dart';
import '../repo/sqlite/favorite_dao.dart';
import '../util/session_manager.dart';

class FavoriteCubit extends Cubit<List<Product>> {
  final FavoriteDao _favoriteDAO;
  final SessionManager _sessionManager;

  FavoriteCubit(this._favoriteDAO, this._sessionManager) : super([]);

  // Kullanıcı adı kontrolü
  Future<String> _getUsername() async {
    final username = await _sessionManager.getUsername();
    if (username == null) {
      throw Exception("Username not found in session.");
    }
    return username;
  }

  // Tüm favori ürünleri yükleme
  Future<void> loadFavorites() async {
    try {
      final username = await _getUsername();
      print("Loading all favorite products for user: $username...");
      final favorites = await _favoriteDAO.getFavoriteProducts(username);

      // Eksik verileri filtrele
      final validFavorites = favorites.where((product) {
        final isValid = product.name.isNotEmpty &&
            product.image.isNotEmpty &&
            product.category.isNotEmpty &&
            product.brand.isNotEmpty &&
            product.price > 0;
        if (!isValid) {
          print("Skipping incomplete product -> ID: ${product.id}");
        }
        return isValid;
      }).toList();

      print("Valid favorites loaded for $username: ${validFavorites.length} items.");
      emit(validFavorites);
    } catch (e) {
      print("Error loading favorites: $e");
      emit([]);
    }
  }

  // Ürünü favorilere ekleme
  Future<void> addFavorite(Product product) async {
    try {
      final username = await _getUsername();
      await _favoriteDAO.addToFavorites(product, username);
      print("Product successfully added to favorites for user $username: ${product.name}");
      await loadFavorites();
    } catch (e) {
      print("Error adding product to favorites: $e");
    }
  }

  // Ürünü favorilerden çıkarma
  Future<void> removeFavorite(Product product) async {
    try {
      final username = await _getUsername();
      await _favoriteDAO.removeFromFavorites(product.id, username);
      print("Product successfully removed from favorites for user $username: ${product.name}");
      await loadFavorites();
    } catch (e) {
      print("Error removing product from favorites: $e");
    }
  }

  // Belirli bir ürünün favori olup olmadığını kontrol etme
  bool isFavorite(int productId) {
    final isFav = state.any((product) => product.id == productId);
    return isFav;
  }

  // Tüm favori ürünleri sıfırlama
  void clearFavorites() {
    emit([]);
    print("Favorites cleared for current session.");
  }
}
