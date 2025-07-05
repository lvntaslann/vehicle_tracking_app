import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_services.dart';
import '../../widget/button/alternatif-login-button.dart';
import '../../widget/button/auth-button.dart';
import '../../widget/mydivider.dart';
import '../../widget/textfield/auth-text.dart';
import '../../widget/textfield/custom-textfield.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController retryPassWordController = TextEditingController();

  final AuthServices authServices = AuthServices();
  @override
  void dispose() {
    emailController.dispose();
    passWordController.dispose();
    retryPassWordController.dispose();
    super.dispose();
  }

  void onTapRegister() async {
    String emailValue = emailController.text.trim();
    String passwordValue = passWordController.text.trim();

    try {
      await authServices.register(emailValue, passwordValue);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kayıt başarılı! Hoş geldiniz"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamed(context, '/login');
      });
    } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kayıt başarısız: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration:const Duration(seconds: 1),
        ),
      );
      debugPrint('Hata: $e');
    }
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
              const SizedBox(height: 100),
              Text(
                "Hesap oluştur",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AuthText(
                text1: "Zaten hesabınız var mı ?",
                text2: 'Giriş yapın',
                onTap: () => Navigator.pushNamed(context, '/login'),
              ),
              const SizedBox(height: 15),
              CustomTextField(
                  subText: 'Email',
                  controller: emailController,
                  height: 54,
                  width: 348,
                  isPassword: false),
              const SizedBox(height: 8),
              CustomTextField(
                  subText: 'Şifre',
                  controller: passWordController,
                  height: 54,
                  width: 348,
                  isPassword: true),
              const SizedBox(height: 8),
              CustomTextField(
                  subText: 'Şifre onayla',
                  controller: retryPassWordController,
                  height: 54,
                  width: 348,
                  isPassword: true),
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
                              onTap: onTapRegister,
                            ),
                      const SizedBox(height: 15),
                    ],
                  );
                },
              ),
              const SizedBox(height: 15),
              const MyDivider(),
              const SizedBox(height: 15),
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
