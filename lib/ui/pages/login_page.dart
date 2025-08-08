import 'package:flutter/material.dart';
import 'package:incisive_demo/ui/widgets/login_button.dart';
import 'package:incisive_demo/ui/widgets/login_textfield.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/loginPage';

  final Color color;

  const LoginPage({required this.color, super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  String? enteDesctiption;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Widget _buildLoginContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Image.asset(widget.logo, height: 80),
          const Text("Incisive logo"),
          const SizedBox(height: 25),
          if (enteDesctiption != null)
            Text(enteDesctiption!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: widget.color)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              color: const Color.fromARGB(255, 241, 243, 244),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      LoginTextField(isTextVisible: true, title: "Username", controller: _usernameController),
                      const SizedBox(height: 10),
                      LoginTextField(isTextVisible: false, title: "Password", controller: _passwordController),
                      const SizedBox(height: 15),
                      LoginButton(
                        usernameController: _usernameController,
                        passwordController: _passwordController,
                        isLoading: false,
                        login: () {},
                        color: widget.color,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Center(child: _buildLoginContent());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: null,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SizedBox(child: SizedBox(child: _buildMobileLayout(context))),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }
}
