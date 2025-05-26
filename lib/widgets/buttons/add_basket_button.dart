import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/product/product.dart';
import '../../cubit/order_basket/basket_cubit.dart';
import '../../cubit/navigation/navigation_cubit.dart';
import '../../util/session_manager.dart';
import '../../util/design/app_colors.dart';
import '../../util/design/app_text_styles.dart';

class AddToBasketButton extends StatefulWidget {
  final Product product;
  final int quantity;
  final SessionManager sessionManager;
  final ButtonStyle? style;

  const AddToBasketButton({
    Key? key,
    required this.product,
    required this.quantity,
    required this.sessionManager,
    this.style,
  }) : super(key: key);

  @override
  _AddToBasketButtonState createState() => _AddToBasketButtonState();
}

class _AddToBasketButtonState extends State<AddToBasketButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    // 1) güçlü pop animasyonu
    await _ctrl.forward();
    await _ctrl.reverse();

    // 2) sepete ekleme + navigation
    final basketCubit = context.read<BasketCubit>();
    try {
      final username = await widget.sessionManager.getUsername();
      if (username == null) throw Exception("User not logged in");

      await basketCubit.repo
          .addProductToBasket(widget.product, widget.quantity, username);
      basketCubit.getBasketItems();

      context.read<NavigationCubit>().navigateTo(2);
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add to basket: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: ElevatedButton(
        style: widget.style ??
            ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
              backgroundColor: AppColors.primary,   // eski sarı rengin geri geldiği yer
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
        onPressed: _onTap,  // artık null değil, buton etkin
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Add to Cart', style: AppTextStyles.button),
            SizedBox(width: 16),
            Icon(Icons.shopping_cart_outlined, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
