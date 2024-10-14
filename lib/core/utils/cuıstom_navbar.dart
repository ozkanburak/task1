import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0; // Seçili olan sekmenin indeksi

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Anasayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Test',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Test',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800], 
      onTap: _onItemTapped,
    );
  }
}