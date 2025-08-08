import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  final bool isTextVisible;
  final String title;
  final TextEditingController controller;

  const LoginTextField({required this.isTextVisible, required this.title, required this.controller, super.key});

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  late bool show;

  @override
  void initState() {
    super.initState();
    show = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: TextField(
        enableSuggestions: true,
        keyboardType: widget.title == "Email" ? TextInputType.emailAddress : TextInputType.text,
        controller: widget.controller,
        cursorColor: Colors.blueGrey,
        obscureText: !widget.isTextVisible && !show,
        decoration: InputDecoration(
          hintText: widget.title,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 131, 128, 128)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(50.0)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(50.0)),
          prefixIconColor: Colors.black,
          filled: true,
          fillColor: const Color.fromARGB(101, 255, 255, 255),
          suffixIcon:
              widget.isTextVisible
                  ? null
                  : GestureDetector(onTap: () => setState(() => show = !show), child: Icon(show ? Icons.visibility_off : Icons.visibility)),
        ),
        style: const TextStyle(height: 1, decoration: TextDecoration.none, decorationThickness: 0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
