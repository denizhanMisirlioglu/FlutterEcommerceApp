import 'package:flutter/material.dart';
import '../../model/product/product.dart';
import '../../util/session_manager.dart';
import '../../view/detail/detail_view.dart';
import '../buttons/add_basket_button.dart';
import '../buttons/favorite_button.dart';
import '../../util/design/app_colors.dart';
import '../../util/design/app_text_styles.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final SessionManager sessionManager;

  const ProductCard({
    Key? key,
    required this.product,
    required this.sessionManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ürün bilgilerini logla
    print(
        "Rendering ProductCard for -> ID: ${product.id}, Name: ${product.name}, "
            "Image: ${product.image}, Price: ${product.price}, Brand: ${product.brand}"
    );
    // Ürün verilerinin kontrolü
    if (product.name.isEmpty ||
        product.image.isEmpty ||
        product.price <= 0 ||
        product.brand.isEmpty) {
      print("Warning: Incomplete product data detected for Product ID: ${product.id}");
    }

    return GestureDetector(
      onTap: () {
        print("Navigating to DetailView for Product -> ID: ${product.id}, Name: ${product.name}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailView(
              product: product,
              sessionManager: sessionManager,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Section
                Container(
                  color: const Color(0xFFF5F5F5),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      product.image,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        print("Error loading image for Product -> ID: ${product.id}, URL: ${product.image}");
                        return Container(
                          color: Colors.grey,
                          child: const Icon(Icons.broken_image, size: 50, color: Colors.black),
                        );
                      },
                    ),
                  ),
                ),

                // Details Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // Fiyat
                      Text(
                        product.price > 0 ? "${product.price} ₺" : "No Price",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Marka
                      Text(
                        product.brand.isNotEmpty ? product.brand : "Unknown Brand",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Sepete Ekle Butonu (yatay padding 8 ile)
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: AddToBasketButton(
                          product: product,
                          quantity: 1,
                          sessionManager: sessionManager,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            minimumSize: const Size.fromHeight(48),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Favorite Button
          Positioned(
            top: 8,
            right: 8,
            child: FavoriteButton(product: product),
          ),
        ],
      ),
    );
  }
}
