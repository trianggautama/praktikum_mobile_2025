import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https://upload.wikimedia.org/wikipedia/id/6/62/Logo-uniska-ok.png',
              width: 100,
            ),
            const SizedBox(height: 15),
            const Text(
              'Selamat datang di Praktikum Mobile 1',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 27),
            ),
            const SizedBox(height: 5),
            const Text(
              'Universitas Islam Kalimantan Muhammad Arsyad Al Banjari',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
