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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black87,
        onTap: (index) {
          setState(() {
            currentIndexValue = index;
          });
        },
        currentIndex: currentIndexValue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}