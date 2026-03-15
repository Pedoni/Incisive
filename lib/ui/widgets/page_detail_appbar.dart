import 'package:flutter/material.dart';
import 'package:incisive/utils/incisive_colors.dart';

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
          color: IncisiveColors.primary,
        ),
      ),
      foregroundColor: IncisiveColors.primary,
      backgroundColor: const Color(0xFFFFF8E8),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
