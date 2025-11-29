import 'package:flutter/material.dart';
import 'package:incisive/ui/widgets/login_button.dart';
import 'package:incisive/ui/widgets/login_textfield.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/registerPage';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Widget _buildRegisterContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox()),
                  Image.asset("assets/images/logo_brown.png", height: 150),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: IntrinsicWidth(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "REGISTER",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 141, 90, 35),
                                ),
                              ),
                              const SizedBox(height: 20),
                              LoginTextField(isTextVisible: true, title: "Email", controller: _usernameController),
                              const SizedBox(height: 10),
                              LoginTextField(isTextVisible: false, title: "Password", controller: _passwordController),
                              const SizedBox(height: 10),
                              LoginTextField(isTextVisible: false, title: "Confirm password", controller: _passwordController),
                              const SizedBox(height: 15),
                              LoginButton(
                                usernameController: _usernameController,
                                passwordController: _passwordController,
                                isLoading: false,
                                login: () {},
                                color: Color.fromARGB(255, 141, 90, 35),
                                title: 'Create account',
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Image.asset("assets/images/logo_text.png", height: 15, fit: BoxFit.fitHeight),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Center(child: _buildRegisterContent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: Color.fromARGB(255, 141, 90, 35),
            backgroundColor: Colors.white,
          ),
          extendBody: true,
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: SizedBox(child: SizedBox(child: _buildMobileLayout(context))),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }
}
