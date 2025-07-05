import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_services.dart';
import '../../widget/button/alternatif-login-button.dart';
import '../../widget/button/auth-button.dart';
import '../../widget/mydivider.dart';
import '../../widget/textfield/auth-text.dart';
import '../../widget/textfield/custom-textfield.dart';
import '../main_page.dart';
import '../../model/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final AuthServices authServices = AuthServices();
  @override
  void dispose() {
    emailController.dispose();
    passWordController.dispose();
    super.dispose();
  }

  void onTapLogin() async {
    final authServices = Provider.of<AuthServices>(context, listen: false);

    String emailValue = emailController.text.trim();
    String passwordValue = passWordController.text.trim();

    try {
      final result = await authServices.login(emailValue, passwordValue);
      debugPrint('Giriş başarılı: ${result['uid']}');
      final authUser = Auth.fromJson(result, passwordValue);
      debugPrint('Auth nesnesi: uid=${authUser.uid}, email=${authUser.email}');

      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          content: Text("Giriş başarılı! Hoş geldiniz"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      });
    } catch (e) {
      debugPrint('Hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Giriş başarısız: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration:const Duration(seconds: 1),
        ),
      );
    }
  }

  void onTap() {
    Navigator.pushNamed(context, '/signup');
  }

  void loginWithGoogle() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Text(
                "Giriş yap",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AuthText(
                text1: "Hesabın henüz yok mu ?",
                text2: 'Hesap oluştur',
                onTap: onTap,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                subText: 'Email',
                controller: emailController,
                height: 54,
                width: 348,
                isPassword: false,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                subText: 'Şifre',
                controller: passWordController,
                height: 54,
                width: 348,
                isPassword: true,
              ),
              const SizedBox(height: 8),
              Consumer<AuthServices>(
                builder: (context, authServices, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      authServices.isLoading
                          ? const Padding(
                              padding: EdgeInsets.only(left: 150),
                              child: CircularProgressIndicator(
                                color: Color(0xFF4B69FF),
                              ),
                            )
                          : AuthButton(
                              buttonText: "Giriş Yap",
                              onTap: onTapLogin,
                            ),
                      const SizedBox(height: 15),
                    ],
                  );
                },
              ),

              /*  Text(
                "Şifremi unuttum",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              */
              const SizedBox(height: 20),
              MyDivider(),
              const SizedBox(height: 20),
              AlternatifLoginButton(
                image: 'assets/facebook.png',
                logintText: 'Facebook ile giriş yap',
                onTap: () {},
              ),
              const SizedBox(height: 15),
              AlternatifLoginButton(
                image: 'assets/google.png',
                logintText: 'Google ile giriş yap',
                onTap: loginWithGoogle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
