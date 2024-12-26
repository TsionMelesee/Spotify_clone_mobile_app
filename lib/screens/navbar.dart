import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(
        child: Text('Home Page',
            style: TextStyle(fontSize: 20, color: Colors.white))),
    Center(
        child: Text('Search Page',
            style: TextStyle(fontSize: 20, color: Colors.white))),
    Center(
        child: Text('Your Library',
            style: TextStyle(fontSize: 20, color: Colors.white))),
    Center(
        child: Text('Premium Page',
            style: TextStyle(fontSize: 20, color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Your Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Premium',
          ),
        ],
      ),
    );
  }
}
