import 'package:flutter/material.dart';
import 'package:spotify_clone/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function setUser;

  const LoginScreen({required this.setUser, Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  final RegExp emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  final RegExp passwordRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  void handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = "Please fill in all fields.";
      });
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _error = "Please enter a valid email address.";
      });
      return;
    }

    if (!passwordRegex.hasMatch(password)) {
      setState(() {
        _error =
            "Password must be at least 8 characters long, include a number, an uppercase letter, and a special character.";
      });
      return;
    }

    setState(() {
      _error = null;
    });

    // Simulate setting the user
    widget.setUser({'email': email});
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Log In",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              if (_error != null) ...[
                SizedBox(height: 16.0),
                Text(
                  _error!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle login logic (if any)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MainScreen()), // Navigate to MainScreen
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  "Log In",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // Navigate to Register Page (add this route later)
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  "Don't have an account? Register",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
