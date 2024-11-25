import 'package:flutter/material.dart';
import '../../model/order/order.dart';
import '../../model/order/order_item.dart';
import '../../model/product/product.dart';
import '../../repo/sqlite/order_dao.dart';
import '../../util/session_manager.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/cards/order_summary_card.dart';

class OrderDetailView extends StatelessWidget {
  final Order order;

  const OrderDetailView({Key? key, required this.order}) : super(key: key);

  Future<List<OrderItem>> _fetchOrderItems(int orderId) async {
    final orderDao = OrderDao();
    return await orderDao.getOrderItems(orderId);
  }

  @override
  Widget build(BuildContext context) {
    final sessionManager = SessionManager();

    return Scaffold(
      appBar: AppBar(
        title: Text("Order #${order.id}"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA6E4FF), Color(0xFFB3FFCC)], // DetailView gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<OrderItem>>(
        future: _fetchOrderItems(order.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading order items: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No items found for this order."),
            );
          }

          final orderItems = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Order Summary Card
                OrderSummaryCard(
                  orderDate: order.orderDate.toString(), //  gelen tarih
                  totalPrice: order.totalPrice,
                ),
                const SizedBox(height: 16),

                // Product List Section
                Expanded(
                  child: ListView.builder(
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) {
                      final orderItem = orderItems[index];

                      // Map OrderItem to Product for ProductCard
                      final product = Product(
                        id: orderItem.productId,
                        name: orderItem.productName,
                        image: orderItem.productImage,
                        price: orderItem.price,
                        category: orderItem.category,
                        brand: orderItem.brand,
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ProductCard
                            Expanded(
                              child: ProductCard(
                                product: product,
                                sessionManager: sessionManager,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Quantity Display
                            Text(
                              "x${orderItem.quantity}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
