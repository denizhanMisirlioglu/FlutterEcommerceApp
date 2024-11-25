import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için intl paketi kullanılıyor

class OrderSummaryCard extends StatelessWidget {
  final String orderDate;
  final double totalPrice;

  const OrderSummaryCard({
    Key? key,
    required this.orderDate,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tarih formatlama: Yalnızca tarih, saat ve dakika gösterilir
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(orderDate));

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.black),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Order Date:  $formattedDate",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.payment_outlined, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  "Total Price:  ${totalPrice.toStringAsFixed(2)} ₺",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
