import 'package:flutter/material.dart';
import '../../model/order/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;
  final int orderNumber; // UI üzerindeki sıralama numarası

  const OrderCard({
    Key? key,
    required this.order,
    required this.onTap,
    required this.orderNumber, // Yeni parametre
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4, // Hafif bir gölge efekti
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Order ID ve Total Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #${orderNumber + 1}", // Kullanıcının sıralı sipariş numarası
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Total: ${order.totalPrice.toStringAsFixed(2)} ₺",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Date: ${order.orderDate}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Sağ köşedeki ikon
              const Icon(
                Icons.receipt_long_outlined,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
