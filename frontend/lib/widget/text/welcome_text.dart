import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_services.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServices>(
      builder: (context, auth, _) {
        final email = auth.userEmail;
        if (email.isEmpty) {
          return const CircularProgressIndicator();
        }
        final name = email.split('@')[0];
        return Text(
          'Hoşgeldin,\n$name',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        );
      },
    );
  }
}