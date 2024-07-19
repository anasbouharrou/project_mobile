import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInput2 extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  TextInput2({required this.hintText, required this.controller, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        width: MediaQuery.of(context).size.width * 0.88,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1, 1), //(x,y)
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            cursorColor: Colors.black,
            decoration: InputDecoration(
                iconColor: Colors.black,
                hoverColor: Colors.white70,
                focusColor: Colors.white,
                hintText: hintText,
                hintStyle: GoogleFonts.outfit(
                    fontSize: (MediaQuery.of(context).size.height +
                                MediaQuery.of(context).size.width) *
                            0.005 +
                        10,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.white),
          ),
        ),
      ),
    );
  }
}
