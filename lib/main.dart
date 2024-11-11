import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task_list.dart';
import 'auth_screen.dart'; 
import 'firebase_options.dart';  // Add this import for Firebase options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize Firebase with the platform-specific options
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
    // Check if the user is logged in
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the user is logged in, navigate to the TaskListScreen
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return TaskListScreen();
          } else {
            return AuthScreen(); // If the user is not logged in, show the AuthScreen
          }
        }
        
        // While the authentication status is being checked, show a loading indicator
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
