import 'package:flutter_ecommerce_project/model/basket/basket_item.dart';

class BasketItemResponse {
  List<BasketItem> basketItem;
  int success;

  BasketItemResponse({required this.basketItem, required this.success});


  factory BasketItemResponse.fromJson(Map<String, dynamic>? json) { // basketItem webservis cevabı
    if (json == null || json.isEmpty) {
      return BasketItemResponse(basketItem: [], success: 0);
    }

    int success = json["success"] as int? ?? 0;
    if (success == 0 || json["urunler_sepeti"] == null) {
      return BasketItemResponse(basketItem: [], success: success);
    }

    var jsonArray = json["urunler_sepeti"] as List;
    var basketItem = jsonArray.map((jsonBasketItemObject) {
      return BasketItem.fromJson(jsonBasketItemObject as Map<String, dynamic>);
    }).toList();

    return BasketItemResponse(basketItem: basketItem, success: success);
  }

}
