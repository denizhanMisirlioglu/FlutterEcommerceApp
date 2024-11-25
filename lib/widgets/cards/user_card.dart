import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth/user_cubit.dart';
import '../../util/design/app_text_styles.dart';

class UserCard extends StatelessWidget {
  const UserCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, Map<String, dynamic>?>(builder: (context, userState) {
      if (userState == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // Kullanıcı bilgileri
      final userName = userState['name'] ?? "Guest";
      final userAddress = userState['address'] ?? "Not provided yet";

      return Card(
        margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4, // Daha belirgin gölge
        color: const Color(0xFFF9F9F9), // Hafif gri arka plan
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    "Welcome, $userName !",
                    style: AppTextStyles.headline2,
                  ),
                  const Spacer(),
                  // Türk bayrağı ikonu
                  Image.asset(
                    'assets/turkey-flag.png', // Bayrağın asset yolu
                    width: 45,
                    height: 45,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                       "$userAddress",
                      style: AppTextStyles.subtitle1,
                      overflow: TextOverflow.ellipsis, // Uzun adreslerde sonuna "..." ekler
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      );
    });
  }
}
