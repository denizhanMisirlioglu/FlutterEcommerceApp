import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/buttons/register_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void dispose() {
    // Bellek sızıntılarını önlemek için controller'ları temizle
    usernameController.dispose();
    passwordController.dispose();
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF0F4FF)], // LoginView ile aynı arka plan
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85, // Yüksekliği ekran boyutuna göre ayarla
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
        ),
      ),
    );
  }
}
