import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/model/product/product.dart';
import 'package:flutter_ecommerce_project/repo/ecommerce_dao_repository.dart';

class HomeCubit extends Cubit<List<Product>> {
  final EcommerceDaoRepository repo;
  List<Product> _allProducts = [];

  HomeCubit(this.repo) : super([]);

  Future<void> getProducts() async { //ürünleri getir
    try {
      final productList = await repo.getProducts();
      for (var product in productList) {
        product.image = await repo.getProductImage(product.image);
      }
      _allProducts = productList;
      emit(productList);
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  void applyFilters({List<String>? categories, List<String>? brands}) { // filtrelemeler
    List<Product> filteredProducts = List<Product>.from(_allProducts);

    if (categories != null && categories.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) => categories.contains(product.category)).toList();
    }

    if (brands != null && brands.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) => brands.contains(product.brand)).toList();
    }

    emit(filteredProducts); // arayüzü filtreye göre güncelle
  }

  void sortProductsBy(String criteria) { //fiyata göre sırala
    List<Product> sortedProducts = List<Product>.from(state);

    switch (criteria) {
      case "Lowest Price":
        sortedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case "Highest Price":
        sortedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
        sortedProducts = List<Product>.from(state);
        break;
    }

    emit(sortedProducts); // arayüzü sıralamaya göre güncelle
  }

  List<String> getAvailableCategories() { // kategori seçeneklerini al
    return _allProducts.map((product) => product.category).toSet().toList();
  }

  List<String> getAvailableBrands() { // marka seçeneklerini al
    return _allProducts.map((product) => product.brand).toSet().toList();
  }

  // Arama Fonksiyonu
  void searchProducts(String query) {
    if (query.isEmpty) {
      resetFilters(); // Boş sorgu geldiğinde filtreleri sıfırla
    } else {
      final filteredProducts = _allProducts
          .where((product) =>
      product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.brand.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(filteredProducts); // Filtrelenmiş ürünleri gönder
    }
  }


  void resetFilters() { // filtrelemeleri temizle
    emit(List<Product>.from(_allProducts)); // Tüm ürünleri yeniden listele
  }

}

