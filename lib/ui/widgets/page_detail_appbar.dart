import 'package:flutter/material.dart';

class PageDetailAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const PageDetailAppbar({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 25,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 141, 90, 35),
        ),
      ),
      foregroundColor: Color.fromARGB(255, 141, 90, 35),
      backgroundColor: const Color(0xFFFFF8E8),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
