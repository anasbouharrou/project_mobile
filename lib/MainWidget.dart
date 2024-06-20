import 'package:flutter/material.dart';
import 'RoundedButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'MainCard.dart';
import 'GardenCardWidget.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String selectedCategory = "ALLE";
  final List<Map<String, String>> allStores = [
    {'title': 'Holmebiksen', 'distance': '1,5 km', 'imagePath': 'assets/m1.jpeg', 'category': 'ALLE'},
    {'title': 'Søegaards Frut', 'distance': '2,8 km', 'imagePath': 'assets/m2.jpeg', 'category': 'FRUGT'},
    {'title': 'Holmebiksen Frut', 'distance': '4 km', 'imagePath': 'assets/m3.jpg', 'category': 'FRUGT'},
    {'title': 'Andersens Baghave', 'distance': '1,9 km', 'imagePath': 'assets/m4.jpeg', 'category': 'FRUGT'},
    {'title': 'Hos Roberts', 'distance': '1,5 km', 'imagePath': 'assets/m5.jpg', 'category': 'GRUNT'},
    {'title': 'Holmebiksen Roberts', 'distance': '1,5 km', 'imagePath': 'assets/m6.jpg', 'category': 'GRUNT'},
  ];

  List<Map<String, String>> getFilteredStores(String category) {
    if (category == "ALLE") {
      return allStores.where((store) => store['category'] != 'ALLE').toList();
    } else {
      return allStores.where((store) => store['category'] == category).toList();
    }
  }

  List<Map<String, String>> getCategoryStores(String category) {
    return allStores.where((store) => store['category'] == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(247, 246, 238, 1),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Roundedbutton(icon: Icons.settings),
                  Roundedbutton(icon: Icons.favorite_border),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: Column(
                    children: [
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
                                  fontSize: (MediaQuery.of(context).size.height + MediaQuery.of(context).size.width) * 0.005 + 10,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.gps_not_fixed_rounded),
                                  onPressed: () {},
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MainCard(
                              iconLink: "assets/i1.png",
                              text: "ALLE",
                              onTap: () {
                                setState(() {
                                  selectedCategory = "ALLE";
                                });
                              },
                            ),
                            MainCard(
                              iconLink: "assets/i2.png",
                              text: "FRUGT",
                              onTap: () {
                                setState(() {
                                  selectedCategory = "FRUGT";
                                });
                              },
                            ),
                            MainCard(
                              iconLink: "assets/i3.png",
                              text: "GRUNT",
                              onTap: () {
                                setState(() {
                                  selectedCategory = "GRUNT";
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (selectedCategory != "ALLE") ...[
                              Container(
                                margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                child: Text(
                                  selectedCategory == "FRUGT" ? "Frugt" : "Grunt",
                                  style: GoogleFonts.outfit(
                                    fontSize: (MediaQuery.of(context).size.height + MediaQuery.of(context).size.width) * 0.018,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            if (selectedCategory == "ALLE") ...[
                              Text(
                                "Frugt",
                                style: GoogleFonts.outfit(
                                  fontSize: (MediaQuery.of(context).size.height + MediaQuery.of(context).size.width) * 0.015,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                height: MediaQuery.of(context).size.height * 0.18 + 70,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: getCategoryStores('FRUGT').map((store) => GardenCardWidget(
                                    title: store['title']!,
                                    distance: store['distance']!,
                                    imagePath: store['imagePath']!,
                                  )).toList(),
                                ),
                              ),
                              Text(
                                "Grunt",
                                style: GoogleFonts.outfit(
                                  fontSize: (MediaQuery.of(context).size.height + MediaQuery.of(context).size.width) * 0.015,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                height: MediaQuery.of(context).size.height * 0.18 + 70,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: getCategoryStores('GRUNT').map((store) => GardenCardWidget(
                                    title: store['title']!,
                                    distance: store['distance']!,
                                    imagePath: store['imagePath']!,
                                  )).toList(),
                                ),
                              ),
                            ] else ...[
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                height: MediaQuery.of(context).size.height * 0.18 + 70,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: getFilteredStores(selectedCategory).map((store) => GardenCardWidget(
                                    title: store['title']!,
                                    distance: store['distance']!,
                                    imagePath: store['imagePath']!,
                                  )).toList(),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
