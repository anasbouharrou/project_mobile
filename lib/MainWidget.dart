import 'package:flutter/material.dart';
import 'RoundedButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'MainCard.dart';
import 'GardenCardWidget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String selectedCategory = "ALLE";
  String selectedCard = "ALLE";
  Future<Position>? _userPositionFuture;
  List<Map<String, dynamic>> allStores = [];
  List<Map<String, dynamic>> filteredStores = [];
  bool _isLoadingStores = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userPositionFuture = _getUserLocation();
    _fetchStoresFromFirestore();
    _searchController.addListener(_filterStores);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchStoresFromFirestore() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('stores').get();
      setState(() {
        allStores = snapshot.docs.map((doc) => {
          'title': doc['title'],
          'latitude': doc['latitude'],
          'longitude': doc['longitude'],
          'imagePath': doc['imagePath'],
          'category': doc['category']
        }).toList();
        filteredStores = allStores;
        _isLoadingStores = false;
      });
    } catch (e) {
      print('Error fetching stores: $e');
      setState(() {
        _isLoadingStores = false;
      });
    }
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
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude) / 1000;
  }

  void _filterStores() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredStores = allStores.where((store) {
        return store['title'].toLowerCase().contains(query);
      }).toList();
    });
  }

  List<Map<String, dynamic>> getFilteredStores(Position userPosition, String category) {
    List<Map<String, dynamic>> stores;
    if (category == "ALLE") {
      stores = filteredStores.where((store) => store['category'] != 'ALLE').toList();
    } else {
      stores = filteredStores.where((store) => store['category'] == category).toList();
    }

    for (var store in stores) {
      store['distance'] = calculateDistance(userPosition.latitude, userPosition.longitude, store['latitude'], store['longitude']).toStringAsFixed(1) + ' km';
    }
    return stores;
  }

  List<Map<String, dynamic>> getCategoryStores(Position userPosition, String category) {
    List<Map<String, dynamic>> stores = filteredStores.where((store) => store['category'] == category).toList();

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
                    child: _isLoadingStores
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
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
                                      controller: _searchController,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        iconColor: Colors.black,
                                        hoverColor: Colors.white70,
                                        focusColor: Colors.white,
                                        hintText: "Søg efter markedpladser",
                                        hintStyle: GoogleFonts.outfit(
                                          fontSize: 16, // Fixed font size
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
                                            fontSize: 18, // Fixed font size for both
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
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
                                    if (selectedCategory == "ALLE") ...[
                                      Text(
                                        "Frugt",
                                        style: GoogleFonts.outfit(
                                          fontSize: 18, // Fixed font size for both
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
                                          fontSize: 18, // Fixed font size for both
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
