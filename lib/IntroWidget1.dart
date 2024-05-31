import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'IntroWidget2.dart';
import 'IntroHolder.dart';

class IntroWidget1 extends StatelessWidget {
  const IntroWidget1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(
                  image: AssetImage("assets/1.png"),
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.65,
                  fit: BoxFit.fitHeight),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black, spreadRadius: 0.7, blurRadius: 10),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color.fromRGBO(236, 233, 218, 1),
                ),
                height: MediaQuery.of(context).size.height * 0.35,
                child: Container(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Column(
                            children: [
                              Text("Gør vejen fra jord bord kortere",
                                  style: GoogleFonts.outfit(
                                      fontSize:
                                          (MediaQuery.of(context).size.height +
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width) *
                                              0.019,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w900)),
                              Center(
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      "FIND lokqle råvarer i dit nærområde Få overblik over råvarer i sæson Søg efter specifikke produkter",
                                      style: GoogleFonts.outfit(
                                          fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .height +
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width) *
                                              0.014,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal))),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Container(
                                  child: Image(
                                      image: AssetImage("assets/l1.png"),
                                      fit: BoxFit.fitHeight,
                                      width: MediaQuery.of(context).size.width *
                                          0.40),
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
                                                child: IntroWidget2())));
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
