import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'RoundedButton2.dart';
import 'Button.dart';
import 'HomePage.dart';
import 'StoreDetailsPage.dart';  // Import the StoreDetailsPage

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Map<String, dynamic>> userStores = [];
  bool _isLoadingStores = true;
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    _fetchUserLocationAndStores();
  }

  Future<void> _fetchUserLocationAndStores() async {
    await _getUserLocation();
    await _fetchUserStores();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _userPosition = position;
      });
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude) / 1000;
  }

  Future<void> _fetchUserStores() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('stores')
            .where('ownerId', isEqualTo: user.uid)
            .get();

        final userPosition = _userPosition;
        setState(() {
          userStores = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final distance = userPosition != null
                ? calculateDistance(
                    userPosition.latitude,
                    userPosition.longitude,
                    data['latitude'] ?? 0.0,
                    data['longitude'] ?? 0.0,
                  ).toStringAsFixed(1) + ' km'
                : 'Calculating...';

            return {
              'id': doc.id,  // Add document ID
              'title': data['title'] ?? 'No Title',
              'latitude': data['latitude'] ?? 0.0,
              'longitude': data['longitude'] ?? 0.0,
              'images': List<String>.from(data['images'] ?? []),
              'openingHours': data['openingHours'],
              'category': data['category'] ?? 'Uncategorized',
              'phone': data['phone'] ?? 'No Phone Available',
              'description': data['description'] ?? 'No Description Available',
              'products': (data['products'] as List<dynamic>? ?? []).map((product) => {
                'name': product['name'] ?? 'No Name',
                'price': product['price'] ?? 'No Price',
                'image': product['image'] ?? 'https://via.placeholder.com/100'
              }).toList(),
              'distance': distance,
            };
          }).toList();
          _isLoadingStores = false;
        });
      }
    } catch (e) {
      print('Error fetching stores: $e');
      setState(() {
        _isLoadingStores = false;
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 246, 238, 1),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Roundedbutton2(
                    icon: Icons.logout,
                    onPressed: _logout,
                  ),
                ),
              ],
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    "Indstillinger",
                    style: GoogleFonts.outfit(
                      fontSize: (MediaQuery.of(context).size.height +
                                  MediaQuery.of(context).size.width) *
                              0.008 +
                          15,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "Administér nuværende markeder eller åben nye markeder",
                    style: GoogleFonts.outfit(
                      fontSize: (MediaQuery.of(context).size.height +
                                  MediaQuery.of(context).size.width) *
                              0.0003 +
                          12,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            _isLoadingStores
                ? Center(child: CircularProgressIndicator())
                : userStores.isEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(236, 233, 218, 1),
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.all(20),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                "Du har intet marked",
                                style: GoogleFonts.outfit(
                                  fontSize: (MediaQuery.of(context).size.height +
                                              MediaQuery.of(context).size.width) *
                                          0.012 +
                                      10,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                "Opret din egen markedsplads for kun 99kr om måneden og prøv den første måned helt gratis",
                                style: GoogleFonts.outfit(
                                  fontSize: (MediaQuery.of(context).size.height +
                                              MediaQuery.of(context).size.width) *
                                          0.0003 +
                                      14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Button(text: "Opret nyt marked"),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: userStores.length,
                          itemBuilder: (context, index) {
                            final store = userStores[index];
                            final imageUrl = store['images'].isNotEmpty ? store['images'][0] : 'https://via.placeholder.com/100';
                            return Card(
                              child: ListTile(
                                leading: Image.network(
                                  imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error);  // Handle image load error
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                                title: Text(store['title'] ?? 'No Title'),
                                subtitle: Text(store['distance'] ?? 'Unknown'),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StoreDetailsPage(store: store),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
