import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isLoading;
  final Function() login;
  final Color color;

  const LoginButton({
    required this.usernameController,
    required this.passwordController,
    required this.isLoading,
    required this.login,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
        backgroundColor: color,
        foregroundColor: Colors.white,
        fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
      ),
      onPressed: () {},
      child: Text(
        "Enter",
        style: const TextStyle(
          height: 1,
          color: Colors.white,
          decoration: TextDecoration.none,
          decorationThickness: 0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
