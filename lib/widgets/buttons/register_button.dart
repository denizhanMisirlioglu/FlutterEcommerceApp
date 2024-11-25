import 'package:flutter/material.dart';
import '../../repo/sqlite/user_dao.dart';
import '../../util/design/app_colors.dart';
import '../../util/design/app_text_styles.dart';

class RegisterButton extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final Function(String errorMessage)? onError;
  final VoidCallback onSuccess;

  const RegisterButton({
    Key? key,
    required this.usernameController,
    required this.passwordController,
    required this.nameController,
    required this.addressController,
    required this.onSuccess,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final username = usernameController.text.trim();
        final password = passwordController.text.trim();
        final name = nameController.text.trim();
        final address = addressController.text.trim();

        if (username.isNotEmpty &&
            password.isNotEmpty &&
            name.isNotEmpty &&
            address.isNotEmpty) {
          try {
            // Kullanıcı verilerini ekle
            final userDao = UserDao();
            await userDao.insertUser(username, password, name, address);

            // Başarı callback'i çağır
            onSuccess();
          } catch (e) {
            // Hata durumunda geri bildirim
            if (onError != null) {
              onError!("Error registering user: $e");
            }
          }
        } else {
          // Eksik alan mesajı
          if (onError != null) {
            onError!("Please fill all fields.");
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Oval kenarlar
        ),
        elevation: 4, // Hafif gölge efekti
      ),
      child: const Text(
        "Register",
        style: AppTextStyles.button,
      ),
    );
  }
}
