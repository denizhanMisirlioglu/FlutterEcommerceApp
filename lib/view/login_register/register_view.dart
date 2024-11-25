import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/buttons/register_button.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final addressController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true, // Klavye açıldığında içerik yeniden boyutlandırılsın
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // AppBar yüksekliği
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFA6E4FF), Color(0xFFB3FFCC)], // Gradient renkler
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0, // Gölgeyi kaldırdık
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.person), // Kullanıcı adı ikonu
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)), // Oval köşeler
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)), // Oval köşeler
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)), // Oval köşeler
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Address",
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)), // Oval köşeler
                ),
              ),
            ),
            const SizedBox(height: 32),
            RegisterButton(
              usernameController: usernameController,
              passwordController: passwordController,
              nameController: nameController,
              addressController: addressController,
              onSuccess: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User registered successfully!")),
                );
                Navigator.pop(context); // Başarılı olursa login sayfasına dön
              },
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error)), // Hata mesajı
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
