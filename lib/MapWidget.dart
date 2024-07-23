import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'StoreMapScreen.dart';
class MapWidget extends StatefulWidget {
  final List<Map<String, dynamic>> stores;
  MapWidget({required this.stores});
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreMapScreen(
              stores: widget.stores,
            ),
          ),
        );
      },
      child: FlutterMap(
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
