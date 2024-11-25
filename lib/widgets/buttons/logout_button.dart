import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth/user_cubit.dart';
import '../../util/design/app_colors.dart';
import '../../util/design/app_text_styles.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        print("LogoutButton: Logout process initiated.");

        // UserCubit'in logout fonksiyonunu çağır
        await context.read<UserCubit>().logout();
        print("LogoutButton: User successfully logged out.");

        // Login ekranına yönlendirme
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login', // Login sayfasının route'u
              (route) => false, // Mevcut tüm sayfaları kaldır
        );
        print("LogoutButton: Navigated to Login screen.");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, // AppColors'dan sarı renk kullanıldı
        padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Oval kenarlar
        ),
      ),
      child: const Text(
        "Logout",
        style: AppTextStyles.button, // AppTextStyles'dan button stili kullanıldı
      ),
    );
  }
}
