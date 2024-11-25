import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/favorite_cubit.dart';
import '../../model/product/product.dart';

class FavoriteButton extends StatelessWidget {
  final Product product;

  const FavoriteButton({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, List<Product>>(
      builder: (context, favoriteProducts) {
        // Ürünün favori olup olmadığını kontrol et
        final isFavorite = context.read<FavoriteCubit>().isFavorite(product.id);

        // Kontrol ve loglama
        print("Rendering FavoriteButton for Product -> ID: ${product.id}, Name: ${product.name}");
        print(isFavorite
            ? "Product is marked as favorite."
            : "Product is NOT marked as favorite.");

        return IconButton(
          onPressed: () {
            if (isFavorite) {
              // Favorilerden çıkarma işlemi
              print(
                  "Removing Product -> ID: ${product.id}, Name: ${product.name}, Category: ${product.category}, Brand: ${product.brand} from favorites.");
              context.read<FavoriteCubit>().removeFavorite(product);
            } else {
              // Favorilere ekleme işlemi
              print(
                  "Adding Product -> ID: ${product.id}, Name: ${product.name}, Category: ${product.category}, Brand: ${product.brand} to favorites.");
              context.read<FavoriteCubit>().addFavorite(product);
            }
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          tooltip: isFavorite
              ? "Remove from favorites"
              : "Add to favorites", // Kullanıcı için bilgi mesajı
        );
      },
    );
  }
}
