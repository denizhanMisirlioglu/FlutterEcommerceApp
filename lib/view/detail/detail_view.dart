import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/product/product.dart';
import '../../cubit/detail_cubit.dart';
import '../../util/session_manager.dart';
import '../../widgets/buttons/add_basket_button.dart';
import '../../util/design/app_text_styles.dart';

class DetailView extends StatelessWidget {
  final Product product;
  final SessionManager sessionManager;

  const DetailView({Key? key, required this.product, required this.sessionManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailCubit = context.read<DetailCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        titleTextStyle: AppTextStyles.headline1,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA6E4FF), Color(0xFFB3FFCC)], // CustomAppBar'daki gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Ürün Resmi
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  height: 275,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Ürün Fiyatı
            Text(
              "  ${product.price} ₺",
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Brand ve Category Detayları
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.branding_watermark_outlined,
                      size: 24,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Brand: ${product.brand.isNotEmpty ? product.brand : "Unknown"}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.category,
                      size: 24,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Category: ${product.category.isNotEmpty ? product.category : "Unknown"}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // Miktar Ayarlama Butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => detailCubit.decrementQuantity(),
                  icon: const Icon(Icons.remove_circle_outline_outlined, size: 32),
                ),
                BlocBuilder<DetailCubit, int>(
                  builder: (context, quantity) {
                    return Text(
                      "$quantity",
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                IconButton(
                  onPressed: () => detailCubit.incrementQuantity(),
                  icon: const Icon(Icons.add_circle_outline_outlined, size: 32),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Sepete Ekle Butonu
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: BlocBuilder<DetailCubit, int>(
                builder: (context, quantity) {
                  return AddToBasketButton(
                    product: product,
                    quantity: quantity,
                    sessionManager: sessionManager,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
