import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white), 
      ),
      backgroundColor: Colors.red, 
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}