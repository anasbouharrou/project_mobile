import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button2 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  Button2({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.yellow,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: (MediaQuery.of(context).size.height +
                      MediaQuery.of(context).size.width) *
                  0.014,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ));
  }
}
