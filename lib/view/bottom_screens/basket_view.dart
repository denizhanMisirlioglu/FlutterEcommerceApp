import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/order_basket/basket_cubit.dart';
import '../../model/basket/basket_item.dart';
import '../../repo/sqlite/order_dao.dart';
import '../../util/session_manager.dart';
import '../../widgets/cards/basket_item_card.dart';
import '../../widgets/buttons/place_order_button.dart';

class BasketView extends StatefulWidget {
  const BasketView({Key? key}) : super(key: key);

  @override
  State<BasketView> createState() => _BasketViewState();
}

class _BasketViewState extends State<BasketView> {
  final SessionManager _sessionManager = SessionManager();
  final OrderDao _orderDao = OrderDao();

  @override
  void initState() {
    super.initState();
    context.read<BasketCubit>().getBasketItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BasketCubit, List<BasketItem>>(
        builder: (context, basketItems) {
          if (basketItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your basket is empty!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          int totalPrice = basketItems.fold(
            0,
                (sum, item) => sum + (item.price * item.orderAmount),
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: basketItems.length,
                  itemBuilder: (context, index) {
                    final item = basketItems[index];
                    return BasketItemCard(
                      item: item,
                      onDelete: () {
                        context.read<BasketCubit>().deleteBasketItem(item);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.payment_outlined, color: Colors.black, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          "Total  $totalPrice ₺",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    PlaceOrderButton(
                      basketItems: basketItems,
                      totalPrice: totalPrice,
                      sessionManager: _sessionManager,
                      orderDao: _orderDao,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
