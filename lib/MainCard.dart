import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainCard extends StatelessWidget {
  final String iconLink;
  final String text;
  MainCard({required this.iconLink, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: 40 + MediaQuery.of(context).size.height * 0.12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(color: Colors.black, spreadRadius: 0.5, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.12,
            child: Image(
                image: AssetImage(iconLink),
                fit: BoxFit.fitHeight,
                width: MediaQuery.of(context).size.width * 0.40),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(text,
                style: GoogleFonts.outfit(
                    fontSize: (MediaQuery.of(context).size.height +
                                MediaQuery.of(context).size.width) *
                            0.001 +
                        15,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w900)),
          )
        ],
      ),
    );
  }
}
