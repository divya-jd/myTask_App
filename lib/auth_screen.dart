import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task_list.dart';
import 'auth_screen.dart'; 
import 'firebase_options.dart';  // Import the firebase_options.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize Firebase with the correct options
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthOrTaskScreen(),
    );
  }
}

class AuthOrTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use StreamBuilder to listen to the authentication state
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // If the user is logged in, show the TaskListScreen
            return TaskListScreen();
          } else {
            // If the user is not logged in, show the AuthScreen
            return AuthScreen();
          }
        }

        // Show a loading spinner while checking the authentication state
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class AuthScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      // Sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      // Handle error, e.g., show a snack bar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

  Future<void> _register(BuildContext context) async {
    try {
      // Create a new user with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      // Handle error, e.g., show a snack bar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context), // Perform login action
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () => _register(context), // Perform register action
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
