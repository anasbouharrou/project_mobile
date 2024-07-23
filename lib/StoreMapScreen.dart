import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreMapScreen extends StatefulWidget {
  final List<Map<String, dynamic>> stores;
  StoreMapScreen({required this.stores});
  @override
  _StoreMapScreenState createState() => _StoreMapScreenState();
}

class _StoreMapScreenState extends State<StoreMapScreen> {
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  void _addMarkers() {
    widget.stores.forEach((store) {
      _markers.add(
        Marker(
          point: LatLng(store['latitude'], store['longitude']),
          width: 80,
          height: 80,
          child: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 50.0,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Marketplace Location',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(247, 246, 238, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(widget.stores[0]['latitude'], widget.stores[0]['longitude']),
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: _markers,
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
