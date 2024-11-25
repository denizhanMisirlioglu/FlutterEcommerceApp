import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/product/product.dart';
import '../../cubit/order_basket/basket_cubit.dart';
import '../../cubit/navigation/navigation_cubit.dart';
import '../../util/lottie/lottie_helper.dart';
import '../../util/session_manager.dart';
import '../../util/design/app_colors.dart';
import '../../util/design/app_text_styles.dart';

class AddToBasketButton extends StatelessWidget {
  final Product product;
  final int quantity;
  final SessionManager sessionManager;

  const AddToBasketButton({
    Key? key,
    required this.product,
    required this.quantity,
    required this.sessionManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12), // Genişlik ve yükseklik
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Oval kenarlar
        ),
      ),
      onPressed: () async {
        final basketCubit = context.read<BasketCubit>();
        try {
          final username = await sessionManager.getUsername();
          if (username == null) {
            throw Exception("Username is null. User might not be logged in.");
          }

          await basketCubit.repo.addProductToBasket(product, quantity, username);
          basketCubit.getBasketItems();

          //Sepete başarıyla eklendi animasyonu
          LottieHelper.showAnimation(
            context: context,
            animation: LottieAnimations.addToCart,
            speed: 1.5,
            width: 300,
            height: 300,
            onComplete: () {
              // Animasyon tamamlandığında yapılacak işlem
              context.read<NavigationCubit>().navigateTo(2); // Sepet sayfasına yönlendir
              Navigator.pop(context);
            },
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add product to basket: $e')),
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min, // Butonun içeriği kadar geniş olması için
        children: [
          const Text(
            'Add to Basket',
            style: AppTextStyles.button, // Yazı stili
          ),
          const SizedBox(width: 16), // Yazı ile ikon arasındaki boşluk
          const Icon(Icons.shopping_cart_outlined, color:Colors.black), // Sepet ikonu
        ],
      ),
    );
  }
}
