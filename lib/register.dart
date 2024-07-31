import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart'; // Import the login file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(MaterialApp(
    home: FirebaseInit(),
  ));
}

class FirebaseInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Wait for Firebase.initializeApp() to complete before building the UI
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Firebase initialization is in progress - show loading indicator
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // Firebase initialization failed - display error message
          return Center(child: Text('Firebase initialization error'));
        }
        // Firebase initialization completed successfully - navigate to RegisterScreen
        return RegisterScreen();
      },
    );
  }
}

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  RegisterScreen({Key? key}) : super(key: key);

  void _navigateToLogin(BuildContext context) {
    Navigator.pop(context);
  }

  void _navigateToDashboard(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen(userId: userId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/logo.jpg', // Add your logo image to the assets folder and update the path
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Enter Your UserName',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter Your Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter Your Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Your Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (passwordController.text != confirmPasswordController.text) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Password Mismatch'),
                        content: Text('The passwords do not match.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userCredential.user!.uid)
                        .set({
                      'username': usernameController.text,
                      'email': emailController.text,
                      // Add additional fields as needed
                    });

                    // Registration successful, navigate to LoginScreen
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Register New User'),
                        content: Text('Registration successful!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _navigateToLogin(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    print('Error registering user: $e');
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Registration Error'),
                        content: Text('There was an error registering your account. Please try again.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Register'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Already Have An Account'),
              TextButton(
                onPressed: () {
                  _navigateToLogin(context);
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final String userId;

  DashboardScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome! User ID: $userId'),
            ElevatedButton(
              onPressed: () {
                // Implement dashboard functionality
              },
              child: Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
