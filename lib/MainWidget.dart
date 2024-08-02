import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SearchRoundedButton.dart';
import 'MainCard.dart';
import 'GardenCardWidget.dart';
import 'MapScreen.dart' as MapPage; // Use alias for MapScreen
import 'StoreDetailsScreen.dart'; // Import the StoreDetailsScreen
import 'HomePage.dart'; // Import HomePage for navigation
import 'RoundedButton2.dart';

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

  List<String> categories = [
    "ALLE",
    "FRUGT",
    "GRUNT",
    "Bær & Nødder",
    "Svampe",
    "Krydderurter",
    "Blomster",
    "Planter",
    "Frø",
    "Hjemmelavet",
    "Drikkevarer"
  ];

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
        allStores = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final openingHours = <String, List<String>>{};
          if (data['openingHours'] != null) {
            (data['openingHours'] as Map<String, dynamic>).forEach((key, value) {
              openingHours[key] = List<String>.from(value);
            });
          }

          return {
            'id': doc.id,
            'title': data['title'] ?? 'No Title',
            'latitude': data['latitude'] ?? 0.0,
            'longitude': data['longitude'] ?? 0.0,
            'images': List<String>.from(data['images'] ?? []),
            'openingHours': openingHours,
            'category': data['category'] ?? 'Uncategorized',
            'phone': data['phone'] ?? 'No Phone Available',
            'description': data['description'] ?? 'No Description Available',
            'products': (data['products'] as List<dynamic>? ?? []).map((product) => {
              'name': product['name'] ?? 'No Name',
              'price': product['price'] ?? 'No Price',
              'image': product['image'] ?? 'https://via.placeholder.com/100'
            }).toList(),
          };
        }).toList();
        _filterStores();
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
      stores = filteredStores;
    } else {
      stores = filteredStores.where((store) => store['category'] == category || store['category'] == 'ALLE').toList();
    }

    for (var store in stores) {
      store['distance'] = calculateDistance(userPosition.latitude, userPosition.longitude, store['latitude'], store['longitude']).toStringAsFixed(1) + ' km';
    }
    return stores;
  }

  List<Map<String, dynamic>> getCategoryStores(Position userPosition, String category) {
    List<Map<String, dynamic>> stores = filteredStores.where((store) => store['category'] == category || store['category'] == 'ALLE').toList();

    for (var store in stores) {
      store['distance'] = calculateDistance(userPosition.latitude, userPosition.longitude, store['latitude'], store['longitude']).toStringAsFixed(1) + ' km';
    }
    return stores;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Roundedbutton2(
                        icon: Icons.arrow_back_ios_sharp,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
                          );
                        },
                      ),
                      SearchRoundedbutton(icon: Icons.favorite_border),
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
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MapPage.MapScreen(stores: filteredStores), // Use alias MapPage
                                                ),
                                              );
                                            },
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
                                  child: Container(
                                    height: 180, // Adjust the height to fit the cards properly
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        children: categories.map((category) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                            child: MainCard(
                                              iconLink: "assets/ig1.png", // Update the icons based on your assets
                                              selectedIconLink: "assets/ii1.png",
                                              text: category,
                                              isSelected: selectedCard == category,
                                              onTap: () {
                                                setState(() {
                                                  selectedCategory = category;
                                                  selectedCard = category;
                                                });
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
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
                                            selectedCategory,
                                            style: GoogleFonts.outfit(
                                              fontSize: 18, // Fixed font size for both
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(vertical: 10),
                                          height: MediaQuery.of(context).size.height * 0.18 + 100,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: getFilteredStores(userPosition, selectedCategory).map((store) => GardenCardWidget(
                                              title: store['title'] ?? 'No Title',
                                              distance: store['distance'] ?? 'Calculating...',
                                              imagePath: (store['images'] as List<String>?)?.isNotEmpty == true ? store['images'][0] : 'https://via.placeholder.com/150',
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => StoreDetailsScreen(store: store),
                                                  ),
                                                );
                                              },
                                            )).toList(),
                                          ),
                                        ),
                                      ],
                                      if (selectedCategory == "ALLE") ...[
                                        for (var category in categories.where((cat) => cat != "ALLE")) ...[
                                          Text(
                                            category,
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
                                              children: getCategoryStores(userPosition, category).map((store) => GardenCardWidget(
                                                title: store['title'] ?? 'No Title',
                                                distance: store['distance'] ?? 'Calculating...',
                                                imagePath: (store['images'] as List<String>?)?.isNotEmpty == true ? store['images'][0] : 'https://via.placeholder.com/150',
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => StoreDetailsScreen(store: store),
                                                    ),
                                                  );
                                                },
                                              )).toList(),
                                            ),
                                          ),
                                        ],
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
    );
  }
}
