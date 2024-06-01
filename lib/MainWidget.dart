import 'package:flutter/material.dart';
import 'RoundedButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'MainCard.dart';
import 'GardenCardWidget.dart';

class MainWidget extends StatelessWidget {
  int a = 0;
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
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.50 + 50,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Text(
                              "Markeder",
                              style: GoogleFonts.outfit(
                                  fontSize: (MediaQuery.of(context)
                                              .size
                                              .height +
                                          MediaQuery.of(context).size.width) *
                                      0.018,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height:
                                MediaQuery.of(context).size.height * 0.18 + 70,
                            child: ListView(
                              // This next line does the trick.
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                GardenCardWidget(
                                  title: 'Holmebiksen',
                                  distance: '1,5 km',
                                  imagePath: 'assets/m1.jpeg',
                                ),
                                GardenCardWidget(
                                  title: 'Søegaards Frut',
                                  distance: '2,8 km',
                                  imagePath: 'assets/m2.jpeg',
                                ),
                                GardenCardWidget(
                                  title: 'Holmebiksen Frut',
                                  distance: '4 km',
                                  imagePath: 'assets/m3.jpg',
                                ),
                                GardenCardWidget(
                                  title: 'Holmebiksen',
                                  distance: '1,5 km',
                                  imagePath: 'assets/m1.jpeg',
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Text(
                              "Frugt",
                              style: GoogleFonts.outfit(
                                  fontSize: (MediaQuery.of(context)
                                              .size
                                              .height +
                                          MediaQuery.of(context).size.width) *
                                      0.018,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height:
                                MediaQuery.of(context).size.height * 0.18 + 70,
                            child: ListView(
                              // This next line does the trick.
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                GardenCardWidget(
                                  title: 'Andersens Baghave',
                                  distance: '1,9 km',
                                  imagePath: 'assets/m4.jpeg',
                                ),
                                GardenCardWidget(
                                  title: 'Hos Roberts',
                                  distance: '1,5 km',
                                  imagePath: 'assets/m5.jpg',
                                ),
                                GardenCardWidget(
                                  title: 'Holmebiksen Roberts',
                                  distance: '1,5 km',
                                  imagePath: 'assets/m6.jpg',
                                ),
                                GardenCardWidget(
                                  title: 'Holmebiksen',
                                  distance: '1,5 km',
                                  imagePath: 'assets/m1.jpeg',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                    ],
                  )),
            ],
          )),
        )),
      ),
    );
  }
}
