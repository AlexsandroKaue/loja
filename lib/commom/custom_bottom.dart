import 'package:flutter/material.dart';

class CustomBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.grey[700],), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.list, color: Colors.grey[700]), label: 'home2'),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_add_check, color: Colors.grey[700]), label: 'home3'),
        ],
    );
  }
}
