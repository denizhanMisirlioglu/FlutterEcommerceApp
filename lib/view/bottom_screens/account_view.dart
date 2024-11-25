import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth/account_cubit.dart';
import '../../model/order/order.dart';
import '../../widgets/buttons/logout_button.dart';
import '../../widgets/cards/user_card.dart';
import '../../widgets/cards/order_card.dart';
import '../detail/order_detail_view.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AccountCubit'in yükleme işlemini tetikleyelim
    context.read<AccountCubit>().loadAccountInfo();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Kullanıcı bilgileri ve UserCard (kendi içinde kullanıcı bilgilerini alır)
          const UserCard(),

          // Sipariş listesi
          Expanded(
            child: BlocBuilder<AccountCubit, Map<String, dynamic>>(
              builder: (context, accountState) {
                if (accountState.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = accountState['orders'] as List<Order>? ?? [];

                if (orders.isEmpty) {
                  return const Center(
                    child: Text(
                      "No orders found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return OrderCard(
                      order: order,
                      orderNumber: index, // index değeri sıralama için kullanılıyor
                      onTap: () {
                        // OrderDetailView'e yönlendirme
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailView(
                              order: order,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          // Logout butonu
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: const LogoutButton(),
            ),
          ),
        ],
      ),
    );
  }
}
