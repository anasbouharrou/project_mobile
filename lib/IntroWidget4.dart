import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroWidget4 extends StatelessWidget {
  const IntroWidget4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.06, 0, 0, 0),
              child: Container(
                child: Center(
                  child: Image(
                      image: AssetImage("assets/4.png"),
                      width: MediaQuery.of(context).size.width * 0.60,
                      height: MediaQuery.of(context).size.height * 0.30,
                      fit: BoxFit.fitHeight),
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color.fromRGBO(247, 246, 238, 1),
                ),
                height: MediaQuery.of(context).size.height * 0.50,
                child: Container(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Column(
                            children: [
                              Text("app under udvikling",
                                  style: GoogleFonts.outfit(
                                      fontSize:
                                          (MediaQuery.of(context).size.height +
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width) *
                                              0.018,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold)),
                              Center(
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      "appen er ikke klar endnu, du tilføjer din markedsplads fra hjemmesiden",
                                      style: GoogleFonts.outfit(
                                          fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .height +
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width) *
                                              0.016,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal))),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      0,
                                      MediaQuery.of(context).size.height * 0.15,
                                      0,
                                      0),
                                  child: Container(
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.yellow,
                                        ),
                                        onPressed: () {},
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Text(
                                            "tilføje marked",
                                            style: GoogleFonts.outfit(
                                              fontSize: (MediaQuery.of(context)
                                                          .size
                                                          .height +
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width) *
                                                  0.018,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )),
                                  )),
                            ],
                          ),
                        ))))
          ],
        ),
      ),
    );
  }
}
