import 'package:car_rental/auth/auth_service.dart';
import 'package:car_rental/login_and_signup/forgotpassword.dart';
import 'package:car_rental/login_and_signup/signup.dart';
import 'package:car_rental/pages/dashboard.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final authService = AuthService();

  //text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  bool ishiddenpass = true;

  //login button pressed
  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final user = await authService.signInWithEmailPassword(email, password);

      if (user != null) {
        print("Login successful: ${user.email}"); // Debugging
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashpage()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid credentials. Please try again.")),
          );
        }
      }
    } catch (e) {
      print("Supabase Login Error: $e"); // Debugging
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")), // Show actual Supabase error
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF4B2F42),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B2F42), Colors.purple.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            offset: Offset(3, 3),
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(-3, -3),
                            blurRadius: 5,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'RenTzy',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 60,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 5,
                              offset: Offset(3, 3),
                              color: Colors.black,
                            ),
                            Shadow(
                              offset: Offset(-3, -3),
                              blurRadius: 5,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Login Below',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.email),
                                hintText: 'Email',
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'the email field is required';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: passwordController,
                              obscureText: ishiddenpass,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: togglepassword,
                                  icon:
                                      ishiddenpass
                                          ? Icon(Icons.visibility_off)
                                          : Icon(Icons.visibility),
                                ),
                                hintText: 'Password',
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'The password field is required.';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Forgotpassword(),
                                    ),
                                  );
                                },
                                child: Text('Forgot Password'),
                              ),
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                ),
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    login(); // ✅ Now it properly checks Supabase before navigating
                                  }
                                },
                                child: Text(
                                  'Log in',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('dont have an account yet?'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Signup(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void togglepassword() {
    setState(() {
      ishiddenpass = !ishiddenpass;
    });
  }
}
