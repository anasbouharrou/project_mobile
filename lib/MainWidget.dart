import 'package:flutter/material.dart';
import 'RoundedButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'MainCard.dart';

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(247, 246, 238, 1),
        body: Container(
            child: Padding(
          padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
          child: Container(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Roundedbutton(icon: Icons.settings),
                  Roundedbutton(icon: Icons.favorite_border),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                child: Container(
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
                          hintText: "Søg efter markedpladser",
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
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MainCard(
                        iconLink: "assets/i1.png",
                        text: "ALLE",
                      ),
                      MainCard(iconLink: "assets/i2.png", text: "FRUGT"),
                      MainCard(iconLink: "assets/i3.png", text: "GRUNT")
                    ],
                  ),
                ),
              )
            ],
          )),
        )),
      ),
    );
  }
}
