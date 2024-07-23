import 'package:flutter/material.dart';
import 'Roundedbutton2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'TextInput2.dart';
import 'Button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SettingsPage.dart';
import 'SellerPage.dart'; // Import SellerPage for navigation

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      );

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 246, 238, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Roundedbutton2(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SellerPage()), // Navigate to SellerPage
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Log ind på din profil",
                        style: GoogleFonts.outfit(
                          fontSize: (MediaQuery.of(context).size.height + MediaQuery.of(context).size.width) * 0.008 + 15,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "Indtast dine oplysninger for at logge ind",
                        style: GoogleFonts.outfit(
                          fontSize: (MediaQuery.of(context).size.height + MediaQuery.of(context).size.width) * 0.0003 + 15,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(236, 233, 218, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextInput2(hintText: "Email", controller: _emailController),
                      TextInput2(hintText: "Adgangskode", controller: _passwordController, obscureText: true),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Button2(
                          text: "Log ind",
                          onPressed: _login,
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
}
