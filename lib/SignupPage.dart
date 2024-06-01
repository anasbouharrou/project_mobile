import 'package:flutter/material.dart';
import 'RoundedButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'TextInput.dart';
import 'Button.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color.fromRGBO(247, 246, 238, 1),
          body: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        child: Roundedbutton(
                            icon: Icons.arrow_back_ios_new_rounded),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Opert din profil",
                        style: GoogleFonts.outfit(
                            fontSize: (MediaQuery.of(context).size.height +
                                        MediaQuery.of(context).size.width) *
                                    0.008 +
                                15,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        "For at oprette et marked,skal du oprette en profil",
                        style: GoogleFonts.outfit(
                            fontSize: (MediaQuery.of(context).size.height +
                                        MediaQuery.of(context).size.width) *
                                    0.0003 +
                                15,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(236, 233, 218, 1),
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextInput(hintText: "Fornav"),
                      TextInput(hintText: "Efternavn"),
                      TextInput(hintText: "Email"),
                      TextInput(hintText: "Adgangskode"),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Button(text: "Opret profil"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
