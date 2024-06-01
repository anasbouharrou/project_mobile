import 'package:flutter/material.dart';
import 'RoundedButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'TextInput.dart';
import 'Button.dart';

class Settingspage extends StatelessWidget {
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
                        "Indstillinger",
                        style: GoogleFonts.outfit(
                            fontSize: (MediaQuery.of(context).size.height +
                                        MediaQuery.of(context).size.width) *
                                    0.008 +
                                15,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        "Administér nuværende markeder eller åben nye markeder",
                        style: GoogleFonts.outfit(
                            fontSize: (MediaQuery.of(context).size.height +
                                        MediaQuery.of(context).size.width) *
                                    0.0003 +
                                14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(236, 233, 218, 1),
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.all(20),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            "Du har intet marked",
                            style: GoogleFonts.outfit(
                                fontSize: (MediaQuery.of(context).size.height +
                                            MediaQuery.of(context).size.width) *
                                        0.012 +
                                    15,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            "Opret din egen markedsplads for kun 99kr om måneden og prøv den første måned helt gratis",
                            style: GoogleFonts.outfit(
                                fontSize: (MediaQuery.of(context).size.height +
                                            MediaQuery.of(context).size.width) *
                                        0.0003 +
                                    14,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Button(text: "Opret nyt marked"),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          )),
    );
  }
}
