import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/state_management/blocs/login_bloc/login_bloc.dart';
import 'package:incisive/ui/pages/home_page.dart';
import 'package:incisive/ui/pages/register_page.dart';
import 'package:incisive/ui/widgets/login_button.dart';
import 'package:incisive/ui/widgets/login_textfield.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/loginPage';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TapGestureRecognizer _tapRecognizer;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _tapRecognizer = TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, RegisterPage.routeName);
  }

  Widget _buildLoginContent() {
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
                                "LOGIN",
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
                              const SizedBox(height: 15),
                              BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  return LoginButton(
                                    usernameController: _usernameController,
                                    passwordController: _passwordController,
                                    isLoading: state is TryLoginState,
                                    login: () {
                                      context.read<LoginBloc>().login(_usernameController.text, _passwordController.text);
                                      Navigator.pushNamed(context, HomePage.routeName);
                                    },
                                    color: Color.fromARGB(255, 141, 90, 35),
                                    title: 'Enter',
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              RichText(
                                text: TextSpan(
                                  text: 'or ',
                                  style: TextStyle(color: Color.fromARGB(255, 141, 90, 35)),
                                  children: [
                                    TextSpan(
                                      text: 'register',
                                      style: TextStyle(color: Color.fromARGB(255, 141, 90, 35), decoration: TextDecoration.underline),
                                      recognizer: _tapRecognizer,
                                    ),
                                  ],
                                ),
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
    return Center(child: _buildLoginContent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: null,
          resizeToAvoidBottomInset: true,
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: SizedBox(child: _buildMobileLayout(context)),
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
