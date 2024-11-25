import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/favorite_cubit.dart';
import '../../model/product/product.dart';
import '../../widgets/cards/product_card.dart';
import '../../util/session_manager.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionManager = SessionManager(); // SessionManager örneği oluşturuldu

    return Scaffold(
      body: BlocBuilder<FavoriteCubit, List<Product>>(
        builder: (context, favoriteProducts) {
          // Favori listesi boşsa
          if (favoriteProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.favorite_outline_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet !',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          // Gelen favori ürünleri logla
          print("Favorites loaded: ${favoriteProducts.length} items.");
          for (var product in favoriteProducts) {
            print(
                "Product in favorites -> ID: ${product.id}, Name: ${product.name}, Image: ${product.image}, Price: ${product.price}, Category: ${product.category}, Brand: ${product.brand}");
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), // Genel padding eklendi
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];

              // Eksik veri kontrolü ve loglama
              if (product.name == "No Name" ||
                  product.image == "No Image" ||
                  product.price <= 0 ||
                  product.category == "No Category" ||
                  product.brand == "No Brand") {
                print("Warning: Skipping incomplete product with ID: ${product.id}");
                return const SizedBox.shrink(); // Eksik ürünler için boş widget döndür
              }

              // Favori ürünleri göster
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0), // Kartların arasında dikey padding
                child: ProductCard(
                  key: ValueKey(product.id), // Benzersiz Key
                  product: product,
                  sessionManager: sessionManager, // SessionManager sağlandı
                ),
              );
            },
          );
        },
      ),
    );
  }
}
