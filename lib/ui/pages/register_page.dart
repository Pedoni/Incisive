import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/register/register_bloc.dart';
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
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  void _register() {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(title: "Errore", text: "Compilare tutti i campi."),
      );
    } else if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(title: "Errore", text: "Le password non coincidono."),
      );
    } else if (!EmailValidator.validate(_emailController.text)) {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(title: "Errore", text: "Email non valida."),
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
                              BlocConsumer<RegisterBloc, BaseState>(
                                listener: (context, state) {
                                  if (state is Error) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ErrorDialog(title: "Errore", text: state.errorString ?? 'Errore sconosciuto'),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return LoginButton(
                                    usernameController: _emailController,
                                    passwordController: _passwordController,
                                    isLoading: state is Loading,
                                    login: _register,
                                    color: IncisiveColors.primary,
                                    title: 'Create account',
                                  );
                                },
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
            foregroundColor: IncisiveColors.primary,
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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }
}
