import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_ecommerce_project/model/basket/basket_item.dart';
import 'package:flutter_ecommerce_project/model/product/product.dart';
import '../model/basket/basket_item_response.dart';
import '../model/product/product_response.dart';

class EcommerceDaoRepository {
  // Singleton yapı
  EcommerceDaoRepository._privateConstructor();

  static final EcommerceDaoRepository _instance =
  EcommerceDaoRepository._privateConstructor();

  factory EcommerceDaoRepository() {
    return _instance;
  }

  final String baseUrl = "http://kasimadalan.pe.hu/urunler/";

  /// Tüm ürünleri getirir.
  Future<List<Product>> getProducts() async {
    var url = "${baseUrl}tumUrunleriGetir.php";
    var response = await Dio().get(url);
    return ProductResponse.fromJson(json.decode(response.data)).product;
  }

  /// Sepetteki ürünleri getirir.
  Future<List<BasketItem>> getBasketItems(String username) async {
    var url = "${baseUrl}sepettekiUrunleriGetir.php";
    var data = {"kullaniciAdi": username};
    try {
      var response = await Dio().post(url, data: FormData.fromMap(data));
      print("Response data: ${response.data}");

      if (response.data == null || response.data.toString().isEmpty) {
        print("Boş bir yanıt geldi, sepet boş.");
        return [];
      }

      return BasketItemResponse.fromJson(json.decode(response.data)).basketItem;
    } catch (e) {
      print("Hata: $e");
      return [];
    }
  }

  /// Sepete ürün ekler. Mevcut bir ürün varsa miktarını günceller.
  Future<void> addProductToBasket(Product product, int quantity,String username) async {
    try {
      // Mevcut sepeti al
      var basketItems = await getBasketItems(username);

      // Aynı ürün sepette olup olmadığını kontrol et
      BasketItem? existingItem;

      if (basketItems.isNotEmpty) {
        try {
          existingItem = basketItems.firstWhere(
                (item) => item.name == product.name && item.userName == username,
          );
        } catch (e) {
          existingItem = null; // Eğer eşleşme yoksa, null olarak ayarla
        }
      } else {
        existingItem = null; // Sepet boşsa null olarak ayarla
      }

      if (existingItem != null) {
        // Eğer ürün zaten varsa, sadece miktarı güncelle
        var updatedQuantity = existingItem.orderAmount + quantity;
        var url = '${baseUrl}sepeteUrunEkle.php';
        var data = {
          "ad": product.name,
          "resim": product.image,
          "kategori": product.category,
          "fiyat": product.price,
          "marka": product.brand,
          "siparisAdeti": updatedQuantity,
          "kullaniciAdi": username,
        };

        // Sepete ekleme işlemi
        await Dio().post(url, data: FormData.fromMap(data));

        // Eski basket item'ı sil
        await deleteBasketItem(existingItem,username);
      } else {
        // Eğer ürün sepette yoksa yeni bir ürün olarak ekle
        var url = '${baseUrl}sepeteUrunEkle.php';
        var data = {
          "ad": product.name,
          "resim": product.image,
          "kategori": product.category,
          "fiyat": product.price,
          "marka": product.brand,
          "siparisAdeti": quantity,
          "kullaniciAdi": username,
        };

        // Sepete ekleme işlemi
        await Dio().post(url, data: FormData.fromMap(data));
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  /// Sepetten ürün siler.
  Future<void> deleteBasketItem(BasketItem basketItem,String username) async {
    var url = "${baseUrl}sepettenUrunSil.php";
    var data = {"sepetId": basketItem.id, "kullaniciAdi": username};
    var response = await Dio().post(url, data: FormData.fromMap(data));
    var jsonResponse = json.decode(response.data);

    if (jsonResponse["success"] != 1) {
      throw Exception(
          "Silme işlemi başarısız: ${jsonResponse["message"] ?? "Bilinmeyen bir hata"}");
    }
    print("Basket item deleted: ${basketItem.name}");
  }

  /// Sepeti tamamen temizler.
  Future<void> clearBasket(String username) async {
    try {
      // Sepetteki ürünleri al
      final basketItems = await getBasketItems(username);

      // Sepette ürün yoksa işlem yapma
      if (basketItems.isEmpty) {
        print("Basket is already empty.");
        return;
      }

      // Sepetteki her ürünü sil
      for (var item in basketItems) {
        await deleteBasketItem(item,username);
      }

      print("All items in the basket have been cleared.");
    } catch (e) {
      print("Error clearing basket: $e");
      throw Exception("Failed to clear basket.");
    }
  }

  /// Belirtilen bir ürünün tam URL'sini döndürür.
  Future<String> getProductImage(String imageName) async {
    return "${baseUrl}resimler/$imageName";
  }

  /// Belirli bir ürün adını kullanarak ürünü getirir.
  Future<Product?> getProductByName(String productName) async {
    try {
      // Tüm ürünleri getir
      final products = await getProducts();

      // Ürün adını kontrol et
      final matchingProducts =
      products.where((product) => product.name == productName);
      return matchingProducts.isNotEmpty ? matchingProducts.first : null;
    } catch (e) {
      print("Error finding product with name $productName: $e");
      return null; // Hata veya ürün bulunamazsa null döner
    }
  }
}
