import 'package:flutter/material.dart';
import 'Roundedbutton2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'TextInput2.dart';
import 'Button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomePage.dart'; // Import HomePage for navigation

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signup() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup successful!")));
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
                            MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
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
                        "Opret din profil",
                        style: GoogleFonts.outfit(
                          fontSize: (MediaQuery.of(context).size.height + MediaQuery.of(context).size.width) * 0.008 + 15,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "For at oprette et marked, skal du oprette en profil",
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
                      TextInput2(hintText: "Fornav", controller: _firstNameController),
                      TextInput2(hintText: "Efternavn", controller: _lastNameController),
                      TextInput2(hintText: "Email", controller: _emailController),
                      TextInput2(hintText: "Adgangskode", controller: _passwordController, obscureText: true),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Button2(
                          text: "Opret profil",
                          onPressed: _signup,
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