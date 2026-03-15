import 'package:flutter/material.dart';
import 'package:incisive/utils/incisive_colors.dart';

class AuthScaffold extends StatelessWidget {
  final Widget formContent;
  final bool showBackButton;

  const AuthScaffold({
    super.key,
    required this.formContent,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar:
              showBackButton
                  ? AppBar(
                    foregroundColor: IncisiveColors.primary,
                    backgroundColor: Colors.white,
                    elevation: 0,
                  )
                  : null,
          resizeToAvoidBottomInset: true,
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(child: SizedBox()),

                        Image.asset("assets/images/logo_brown.png", height: 150),
                        const SizedBox(height: 30),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                          child: IntrinsicWidth(
                            child: formContent,
                          ),
                        ),

                        const Expanded(child: SizedBox()),

                        Image.asset(
                          "assets/images/logo_text.png",
                          height: 15,
                          fit: BoxFit.fitHeight,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
