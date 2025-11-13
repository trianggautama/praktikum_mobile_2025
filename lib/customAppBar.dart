import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    required this.titleText,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titleText, style: TextStyle(color: Colors.white)),
      backgroundColor: backgroundColor,
    );
  }

  // Menentukan ukuran preferensi AppBar, wajib saat implements PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
