import 'package:flutter/material.dart';
import 'package:todo_app/ProfilePage.dart';
import 'package:todo_app/customAppBar.dart';
import 'package:todo_app/homePage.dart';
import 'package:todo_app/postListScreen.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const ProfilePage(),
    const PostListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> pageTitles = [
      'Halaman Utama',
      'Profil Pengguna',
      'Post CRUD',
    ];

    return Scaffold(
      appBar: CustomAppBar(
        titleText: pageTitles[_selectedIndex],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Post CRUD',
          ),
        ],
        currentIndex: _selectedIndex, // Indeks yang sedang aktif
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped, // Panggil fungsi saat item diklik
      ),
    );
  }
}
