import 'package:flutter/material.dart';
import 'RoundedButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'MainCard.dart';
import 'GardenCardWidget.dart';
import 'package:geolocator/geolocator.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String selectedCategory = "ALLE";
  String selectedCard = "ALLE";
  Future<Position>? _userPositionFuture;

  final List<Map<String, dynamic>> allStores = [
    {'title': 'Holmebiksen', 'latitude': 55.6761, 'longitude': 12.5683, 'imagePath': 'assets/m1.jpeg', 'category': 'ALLE'},
    {'title': 'Søegaards Frut', 'latitude': 55.6771, 'longitude': 12.5693, 'imagePath': 'assets/m2.jpeg', 'category': 'FRUGT'},
    {'title': 'Holmebiksen Frut', 'latitude': 55.6781, 'longitude': 12.5703, 'imagePath': 'assets/m3.jpg', 'category': 'FRUGT'},
    {'title': 'Andersens Baghave', 'latitude': 55.6791, 'longitude': 12.5713, 'imagePath': 'assets/m4.jpeg', 'category': 'FRUGT'},
    {'title': 'Hos Roberts', 'latitude': 55.6801, 'longitude': 12.5723, 'imagePath': 'assets/m5.jpg', 'category': 'GRUNT'},
    {'title': 'Holmebiksen Roberts', 'latitude': 55.6811, 'longitude': 12.5733, 'imagePath': 'assets/m6.jpg', 'category': 'GRUNT'},
  ];

  @override
  void initState() {
    super.initState();
    _userPositionFuture = _getUserLocation();
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude) / 1000;
  }

  List<Map<String, dynamic>> getFilteredStores(Position userPosition, String category) {
    List<Map<String, dynamic>> stores;
    if (category == "ALLE") {
      stores = allStores.where((store) => store['category'] != 'ALLE').toList();
    } else {
      stores = allStores.where((store) => store['category'] == category).toList();
    }

    for (var store in stores) {
      store['distance'] = calculateDistance(userPosition.latitude, userPosition.longitude, store['latitude'], store['longitude']).toStringAsFixed(1) + ' km';
    }
    return stores;
  }

  List<Map<String, dynamic>> getCategoryStores(Position userPosition, String category) {
    List<Map<String, dynamic>> stores = allStores.where((store) => store['category'] == category).toList();

    for (var store in stores) {
      store['distance'] = calculateDistance(userPosition.latitude, userPosition.longitude, store['latitude'], store['longitude']).toStringAsFixed(1) + ' km';
    }
    return stores;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(247, 246, 238, 1),
        body: FutureBuilder<Position>(
          future: _userPositionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final userPosition = snapshot.data!;
              return Column(
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
                                    iconLink: "assets/ig1.png",
                                    selectedIconLink: "assets/ii1.png",
                                    text: "ALLE",
                                    isSelected: selectedCard == "ALLE",
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = "ALLE";
                                        selectedCard = "ALLE";
                                      });
                                    },
                                  ),
                                  MainCard(
                                    iconLink: "assets/ig2.png",
                                    selectedIconLink: "assets/ii2.png",
                                    text: "FRUGT",
                                    isSelected: selectedCard == "FRUGT",
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = "FRUGT";
                                        selectedCard = "FRUGT";
                                      });
                                    },
                                  ),
                                  MainCard(
                                    iconLink: "assets/ig3.png",
                                    selectedIconLink: "assets/ii3.png",
                                    text: "GRUNT",
                                    isSelected: selectedCard == "GRUNT",
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = "GRUNT";
                                        selectedCard = "GRUNT";
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
                                        children: getCategoryStores(userPosition, 'FRUGT').map((store) => GardenCardWidget(
                                          title: store['title']!,
                                          distance: store['distance'] ?? 'Calculating...',
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
                                        children: getCategoryStores(userPosition, 'GRUNT').map((store) => GardenCardWidget(
                                          title: store['title']!,
                                          distance: store['distance'] ?? 'Calculating...',
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
                                        children: getFilteredStores(userPosition, selectedCategory).map((store) => GardenCardWidget(
                                          title: store['title']!,
                                          distance: store['distance'] ?? 'Calculating...',
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
              );
            }
            return Center(child: Text('Unexpected state'));
          },
        ),
      ),
    );
  }
}
