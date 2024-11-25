import 'package:flutter_ecommerce_project/model/product/product.dart';

class ProductResponse {
  List<Product> product;
  int success;

  ProductResponse({required this.product, required this.success});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    // JSON'dan 'urunler' alanını al ve 'List'e dönüştür
    var jsonArray =
        json["urunler"] as List? ?? []; // Eğer 'urunler' null ise boş liste ata
    int success = json["success"] as int? ?? -1; // Eğer 'success' null ise varsayılan değer -1 ata

    // Her bir JSON nesnesini 'Product' sınıfına dönüştür
    var product = jsonArray.map((jsonProductObject) {
      return Product.fromJson(jsonProductObject as Map<String, dynamic>);
    }).toList();

    return ProductResponse(product: product, success: success);
  }
}

//success = 0 -> İşlem başarısız.
//success = 1 -> İşlem başarılı.
//success = -1 -> JSON eksik veya bozuk.
