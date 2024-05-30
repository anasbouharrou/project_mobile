import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroWidgetConstructor extends StatelessWidget {
  final String title;
  final String text;
  final String buttonText;
  final String imageLink1;
  final String imageLink2;
  const IntroWidgetConstructor(
      {super.key,
      required this.title,
      required this.text,
      required this.buttonText,
      required this.imageLink1,
      required this.imageLink2});

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
                  image: AssetImage(imageLink1),
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
                              Text(title,
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
                                      text,
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
                                      image: AssetImage(imageLink2),
                                      fit: BoxFit.fitHeight,
                                      width: MediaQuery.of(context).size.width *
                                          0.40),
                                ),
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.yellow,
                                  ),
                                  onPressed: () {},
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      buttonText,
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
