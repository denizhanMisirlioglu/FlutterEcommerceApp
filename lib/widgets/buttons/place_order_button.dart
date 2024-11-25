import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth/account_cubit.dart';
import '../../cubit/order_basket/basket_cubit.dart';
import '../../repo/sqlite/order_dao.dart';
import '../../util/design/app_colors.dart';
import '../../util/design/app_text_styles.dart';
import '../../model/basket/basket_item.dart';
import '../../util/lottie/lottie_helper.dart';
import '../../util/session_manager.dart';

class PlaceOrderButton extends StatelessWidget {
  final List<BasketItem> basketItems;
  final int totalPrice;
  final SessionManager sessionManager;
  final OrderDao orderDao;

  const PlaceOrderButton({
    Key? key,
    required this.basketItems,
    required this.totalPrice,
    required this.sessionManager,
    required this.orderDao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          // SessionManager'dan kullanıcı adını al
          final userName = await sessionManager.getUsername();

          if (userName == null || userName.isEmpty) {
            throw Exception("User is not logged in.");
          }

          // BasketItem'ları OrderItem'lara dönüştür
          final orderItems = orderDao.convertBasketItemsToOrderItems(
            basketItems,
            0, // OrderId burada bilinmiyor, veritabanında atanacak
          );

          // Siparişi ver ve sepeti boşalt
          await orderDao.addOrder(totalPrice, userName, orderItems);

          if (context.mounted) {
            // Sepeti temizle
            context.read<BasketCubit>().clearBasket();

            // AccountCubit'i güncelle
            context.read<AccountCubit>().loadAccountInfo();
          }
          LottieHelper.showAnimation(
            context: context,
            animation: LottieAnimations.success, // Başarı animasyonu
            speed: 8, //  hızlı oynatma
            width: 150,
            height: 150,
          );

        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to place order: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // oval kenarlar
        ),
      ),
      child: const Text(
        "Place Order",
        style: AppTextStyles.button,
      ),
    );
  }
}
