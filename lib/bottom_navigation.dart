import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/Screen/HomeScreen.dart';
import 'package:pdf_reader/Screen/main_page.dart';
import 'package:pdf_reader/Screen/setting.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  @override
  int currentIndexValue = 0;
  List screenList = [
    const HomeScreen(),
    const MainPage(),
    const Setting(),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      
    body: screenList[currentIndexValue],
      bottomNavigationBar: CurvedNavigationBar(
        height: 50.0,
        backgroundColor: Colors.transparent, // page background
        color: Colors.black87, // bar color
        buttonBackgroundColor: Colors.redAccent, // middle button color
        animationDuration: Duration(milliseconds: 300),

        items: const [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.search, color: Colors.white, size: 30),
          Icon(Icons.settings, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          setState(() {
            currentIndexValue = index;
          });
        },

      ),
    );
  }
}