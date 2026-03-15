import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/register/register_bloc.dart';
import 'package:incisive/ui/widgets/auth_scaffold.dart';
import 'package:incisive/ui/widgets/error_dialog.dart';
import 'package:incisive/ui/widgets/login_button.dart';
import 'package:incisive/ui/widgets/login_textfield.dart';
import 'package:incisive/utils/incisive_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  void _register() {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(title: "Errore", text: "Compilare tutti i campi."),
      );
    } else if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(title: "Errore", text: "Le password non coincidono."),
      );
    } else if (!EmailValidator.validate(_emailController.text)) {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(title: "Errore", text: "Email non valida."),
      );
    } else {
      context.read<RegisterBloc>().register(
        _emailController.text,
        _passwordController.text,
        _firstNameController.text,
        _lastNameController.text,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      formContent: BlocConsumer<RegisterBloc, BaseState>(
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
                "REGISTER",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: IncisiveColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              LoginTextField(isTextVisible: true, title: "First Name", controller: _firstNameController),
              const SizedBox(height: 10),
              LoginTextField(isTextVisible: true, title: "Last Name", controller: _lastNameController),
              const SizedBox(height: 10),
              LoginTextField(isTextVisible: true, title: "Email", controller: _emailController),
              const SizedBox(height: 10),
              LoginTextField(isTextVisible: false, title: "Password", controller: _passwordController),
              const SizedBox(height: 10),
              LoginTextField(isTextVisible: false, title: "Confirm password", controller: _confirmPasswordController),
              const SizedBox(height: 15),
              LoginButton(
                usernameController: _emailController,
                passwordController: _passwordController,
                isLoading: state is Loading,
                login: _register,
                color: IncisiveColors.primary,
                title: 'Create account',
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
