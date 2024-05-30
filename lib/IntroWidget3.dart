import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'IntroWidget4.dart';
import 'IntroHolder.dart';

class IntroWidget3 extends StatelessWidget {
  const IntroWidget3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: Image(
                  image: AssetImage("assets/3.png"),
                  width: MediaQuery.of(context).size.width * 0.60,
                  height: MediaQuery.of(context).size.height * 0.30,
                  fit: BoxFit.fitHeight),
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
                              Text("Vores mission:",
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
                                      "At skabe den bedst mulige app , så endu flere er flælles om en grønnere hverdag.",
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
                              Center(
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      "Ingen skjulte agendaer og lige ud af landevejen",
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
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Container(
                                  child: Image(
                                      image: AssetImage("assets/l3.png"),
                                      width: MediaQuery.of(context).size.width *
                                          0.30),
                                  height: 30,
                                ),
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.yellow,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Introholder(
                                                child: IntroWidget4())));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      "Næste",
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
                            ],
                          ),
                        ))))
          ],
        ),
      ),
    );
  }
}
