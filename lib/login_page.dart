import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      print('User signed in: ${userCredential.user?.email}');

      Navigator.pushNamed(context, '/home');
    } catch (error) {
      print('Registration error: $error');
    }
  }

  Future<void> handleGoogleSignIn(BuildContext context) async {
    // try {
    //   await _googleSignIn.signIn();

    //   Navigator.pushNamed(context, '/home');
    // } catch (error) {
    //   print('Google Sign-In error: $error');
    // }
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushNamed(context, '/home');
    } catch (error) {
      print('Google Sign-In error: $error');
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Container(
        color: Color(0xFFF4FBFE),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16.0),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 24.0),

            ElevatedButton(
              onPressed: () {
                signInWithEmailAndPassword(context);
              }, 
              child: Text('Login')
            ),
            SizedBox(height: 12.0),

            ElevatedButton(
              onPressed: () {
                handleGoogleSignIn(context);
              },
              child: Row (
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('lib/images/google.png', height: 24.0),
                  SizedBox(width: 12.0),
                  Text('Sign in with Google'),
                ],
              ),
            ),
            SizedBox(height: 12.0),

            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Don\'t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}