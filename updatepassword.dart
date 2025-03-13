import 'package:car_rental/login_and_signup/login.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Updatepassword extends StatefulWidget {
  const Updatepassword({super.key});

  @override
  State<Updatepassword> createState() => _UpdatepasswordState();
}

class _UpdatepasswordState extends State<Updatepassword> {
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client; // Access Supabase client

  bool ishiddenNewpassword = true;
  bool ishiddenconfirmpassword = true;

  Future<void> updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (newPassword.text != confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final user =
          supabase.auth.currentUser; // Get the current authenticated user

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Session expired. Please log in again.'),
            backgroundColor: Colors.red,
          ),
        );

        // Navigate to Login screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
        );

        return;
      }

      await supabase.auth.updateUser(
        UserAttributes(password: newPassword.text.trim()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      FocusScope.of(context).unfocus();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
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
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.password_sharp,
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
                        'Update Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
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
                              'Update your password below',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: newPassword,
                              obscureText: ishiddenNewpassword,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: togglePassword,
                                  icon:
                                      ishiddenNewpassword
                                          ? Icon(Icons.visibility_off)
                                          : Icon(
                                            Icons.visibility,
                                            color: Colors.deepPurple,
                                          ),
                                ),
                                hintText: 'New Password',
                                labelText: 'New Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter your new password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: confirmPassword,
                              obscureText: ishiddenconfirmpassword,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: toggleConfirmPassword,
                                  icon:
                                      ishiddenconfirmpassword
                                          ? Icon(Icons.visibility_off)
                                          : Icon(
                                            Icons.visibility,
                                            color: Colors.deepPurple,
                                          ),
                                ),
                                hintText: 'Confirm Password',
                                labelText: 'Confirm Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Confirm your password';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                              ),
                              onPressed: updatePassword,
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
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

  void togglePassword() {
    setState(() {
      ishiddenNewpassword = !ishiddenNewpassword;
    });
  }

  void toggleConfirmPassword() {
    setState(() {
      ishiddenconfirmpassword = !ishiddenconfirmpassword;
    });
  }
}
