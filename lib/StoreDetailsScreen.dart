import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'MapScreen.dart' as MapPage; // Alias for MapScreen

class StoreDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> store;
  StoreDetailsScreen({required this.store});
  @override
  _StoreDetailsScreenState createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  double? _distance;

  @override
  void initState() {
    super.initState();
    _calculateDistance();
  }

  void _calculateDistance() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      widget.store['latitude'],
      widget.store['longitude'],
    ) / 1000; // Convert to kilometers
    setState(() {
      _distance = distance;
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final openingHours = store['openingHours'] as Map<String, List<String>>?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(247, 246, 238, 1),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.all(0),
            iconSize: 25,
            color: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: Colors.black,
                size: 25,
              ),
              onPressed: () {
                // Add functionality for favorite button
              },
              padding: EdgeInsets.all(0),
              iconSize: 25,
              color: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(247, 246, 238, 1),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                store['title'] ?? 'No Title',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _distance != null ? '${_distance!.toStringAsFixed(1)} km' : 'Calculating distance...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  store['images'].isNotEmpty ? store['images'][0] : 'https://via.placeholder.com/400x200',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                store['description'] ?? 'No Description Available',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.info, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Opening Hours:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              if (openingHours != null) ...openingHours.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text(
                        '${entry.key}: ',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        entry.value.join(', '),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.black),
                  SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (store['phone'] != null) {
                          launchUrl(Uri.parse('tel:${store['phone']}'));
                        }
                      },
                      child: Text(
                        store['phone'] ?? 'No Phone Available',
                        style: TextStyle(fontSize: 16, color: store['phone'] != null ? Colors.blue : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: (store['products'] as List<dynamic>).map((product) {
                  return buildProductCard(product['name'], product['price'], product['image']);
                }).toList(),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  height: 200,
                  child: MapPage.MapScreen( // Use alias MapPage
                    stores: [
                      {'latitude': store['latitude'], 'longitude': store['longitude']},
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductCard(String name, String price, String imageUrl) {
    return Container(
      width: 150,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              child: Image.network(
                imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
