import 'package:car_rental/auth/auth_service.dart';
import 'package:car_rental/pages/dashboard.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final authService = AuthService();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  String passwordMatchMessage = '';

  bool ishiddenpassword = true;
  bool ishiddenconfirmpassword = true;

  void signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmpassword = confirmpasswordController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    if (password != confirmpassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords don't match")));
      return;
    }

    try {
      final user = await authService.signUpwithEmailPassword(
        email,
        password,
        firstName,
        lastName,
      );

      if (user != null) {
        print("Sign up successful, navigating to dashboard...");
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashpage()),
          );
        }
      }
    } catch (e) {
      print("Error during sign-up: $e"); // Debugging
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
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
                              'Sign in Below',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.person),
                                hintText: 'Firstname',
                                labelText: 'Firstname',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'the name field is required';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.person),
                                hintText: 'Lastname',
                                labelText: 'Lastname',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'the Lastname field is required';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                            SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              obscureText: ishiddenpassword,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    togglepassword();
                                  },
                                  icon:
                                      ishiddenpassword
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
                                } else if (value.length < 8) {
                                  return 'The password should be atleast 8 characters long';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: confirmpasswordController,
                              obscureText: ishiddenconfirmpassword,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    toggleconfirmpassword();
                                  },
                                  icon:
                                      ishiddenconfirmpassword
                                          ? Icon(Icons.visibility_off)
                                          : Icon(Icons.visibility),
                                ),
                                hintText: 'ConfirmPassword',
                                labelText: 'ConfirmPassword',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value == passwordController.text) {
                                    passwordMatchMessage = "Passwords match ✅";
                                  } else {
                                    passwordMatchMessage =
                                        "Passwords do not match ❌";
                                  }
                                });
                              },
                            ),
                            Text(
                              passwordMatchMessage,
                              style: TextStyle(
                                color:
                                    passwordMatchMessage.contains("✅")
                                        ? Colors.green
                                        : Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                  ),
                                  onPressed: () {
                                    if (formkey.currentState!.validate()) {
                                      signUp();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => Dashpage(),
                                        ),
                                      );
                                      // Call signUp() when the button is pressed
                                    }
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Already have an account?'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Log in',
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
      ishiddenpassword = !ishiddenpassword;
    });
  }

  void toggleconfirmpassword() {
    setState(() {
      ishiddenconfirmpassword = !ishiddenconfirmpassword;
    });
  }
}
