import 'package:flutter/material.dart';
import '../../util/design/app_text_styles.dart';
import '../../widgets/buttons/login_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // Klavye açıldığında UI yeniden boyutlandırılsın
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // AppBar yüksekliği
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFA6E4FF), Color(0xFFB3FFCC)],
                // Gradient renkler
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0, // Gölgeyi kaldırdık
          title: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min, // Yatay ortalama
              children: [
                Icon(
                  Icons.login, // Login ikonu
                  color: Colors.black, // Siyah renk
                  size: 32, // İkon boyutu
                ),
                const SizedBox(width: 8), // İkon ve yazı arasına boşluk
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400, // Kalınlık
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true, // Hem yatayda hem dikeyde ortalama
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF0F4FF)],
            // Hafif gradient arka plan
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView( // Kaydırılabilir içerik
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.6, // İçeriği ekrana göre boyutlandır
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        // Kullanıcı adı ikonu
                        labelText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Oval köşe
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock), // Şifre ikonu
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Oval köşe
                        ),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: AppTextStyles.error,
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  LoginButton(
                    username: _usernameController.text,
                    password: _passwordController.text,
                    onError: (errorMessage) {
                      setState(() {
                        _errorMessage = errorMessage;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      "Don't have an account? Register here",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32), // Alt kısımda ek boşluk
            ],
          ),
        ),
      ),
    );
  }
}
