import 'package:flutter/material.dart';
import 'package:spotify_clone/screens/login_screen.dart';
import 'package:spotify_clone/screens/main_screen.dart';

void main() {
  runApp(SpotifyCloneApp());
}

class SpotifyCloneApp extends StatefulWidget {
  @override
  _SpotifyCloneAppState createState() => _SpotifyCloneAppState();
}

class _SpotifyCloneAppState extends State<SpotifyCloneApp> {
  Map<String, dynamic>? _user;

  void setUser(Map<String, dynamic> user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.green,
      ),
      home: _user == null
          ? LoginScreen(setUser: setUser)
          : MainScreen(), // Navigate based on login state
      routes: {
        '/main': (context) => MainScreen(),
        // Add other routes like '/register' or '/profile' as needed
      },
    );
  }
}
