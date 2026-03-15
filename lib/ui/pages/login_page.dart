import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/navigation/app_routes.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/login/login_bloc.dart';
import 'package:incisive/ui/widgets/auth_scaffold.dart';
import 'package:incisive/ui/widgets/error_dialog.dart';
import 'package:incisive/ui/widgets/login_button.dart';
import 'package:incisive/ui/widgets/login_textfield.dart';
import 'package:incisive/utils/incisive_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final TapGestureRecognizer _tapRecognizer;

  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()..onTap = () => context.push(AppRoutes.register);
  }

  void _login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(title: "Errore", text: "Compilare tutti i campi."),
      );
    } else {
      context.read<LoginBloc>().login(_emailController.text, _passwordController.text);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      formContent: BlocConsumer<LoginBloc, BaseState>(
        listener: (context, state) {
          if (state is Error) {
            showDialog(
              context: context,
              builder:
                  (_) => ErrorDialog(
                    title: "Errore",
                    text: state.errorString ?? 'Errore sconosciuto',
                  ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: IncisiveColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              LoginTextField(
                isTextVisible: true,
                title: "Email",
                controller: _emailController,
              ),
              const SizedBox(height: 10),
              LoginTextField(
                isTextVisible: false,
                title: "Password",
                controller: _passwordController,
              ),
              const SizedBox(height: 15),
              LoginButton(
                usernameController: _emailController,
                passwordController: _passwordController,
                isLoading: state is Loading,
                login: _login,
                color: IncisiveColors.primary,
                title: 'Enter',
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'or ',
                  style: const TextStyle(color: IncisiveColors.primary),
                  children: [
                    TextSpan(
                      text: 'register',
                      style: const TextStyle(
                        color: IncisiveColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: _tapRecognizer,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
