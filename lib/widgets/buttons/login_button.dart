import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth/user_cubit.dart';
import '../../util/design/app_colors.dart'; // AppColors import edildi
import '../../util/design/app_text_styles.dart';
import '../../util/lottie/lottie_helper.dart';

class LoginButton extends StatelessWidget {
  final String username;
  final String password;
  final Function(String errorMessage)? onError;

  const LoginButton({
    Key? key,
    required this.username,
    required this.password,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final success = await context.read<UserCubit>().login(username, password);

        if (success) {
          // Login başarılıysa LottieHelper ile animasyonu göster
          LottieHelper.showAnimation(
            context: context,
            animation: LottieAnimations.success,
            speed: 9,
            width: 150,
            height: 150,
            onComplete: () {
              Navigator.pushReplacementNamed(context, '/main'); // Animasyon tamamlandığında yönlendirme
            },
          );

        } else {
          // Login başarısızsa hata mesajını geri bildir
          if (onError != null) {
            onError!("Invalid username or password!");
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, // AppColors'dan sarı renk kullanıldı
        padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Oval kenarlar
        ),
        elevation: 4, // Hafif gölge efekti
      ),
      child: const Text(
        "   Login   ",
        style: AppTextStyles.button, // AppTextStyles'dan button stili kullanıldı
      ),
    );
  }
}
