import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInput extends StatelessWidget {
  final String hintText;
  TextInput({required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
      child: Container(
        margin: EdgeInsets.all(10),
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
                suffixIcon: IconButton(
                  icon: Icon(Icons.gps_not_fixed_rounded),
                  onPressed: () {},
                ),
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
