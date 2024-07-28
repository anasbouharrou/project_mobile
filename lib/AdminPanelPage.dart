import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'StoreDetailsPage.dart'; // Import the StoreDetailsPage

class AdminPanelPage extends StatefulWidget {
  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  List<Map<String, dynamic>> allStores = [];
  bool _isLoadingStores = true;

  @override
  void initState() {
    super.initState();
    _fetchAllStores();
  }

  Future<void> _fetchAllStores() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('stores').get();

      setState(() {
        allStores = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id, // Add document ID
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
          };
        }).toList();
        _isLoadingStores = false;
      });
    } catch (e) {
      print('Error fetching stores: $e');
      setState(() {
        _isLoadingStores = false;
      });
    }
  }

  void _navigateToStoreDetailsPage(Map<String, dynamic> store) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoreDetailsPage(store: store),
      ),
    ).then((result) {
      if (result == true) {
        // Refresh the stores list if the result indicates a change
        _fetchAllStores();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
        backgroundColor: Colors.blue,
      ),
      body: _isLoadingStores
          ? Center(child: CircularProgressIndicator())
          : allStores.isEmpty
              ? Center(
                  child: Text(
                    "No stores available",
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                )
              : ListView.builder(
                  itemCount: allStores.length,
                  itemBuilder: (context, index) {
                    final store = allStores[index];
                    final imageUrl = store['images'].isNotEmpty
                        ? store['images'][0]
                        : 'https://via.placeholder.com/100';
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error); // Handle image load error
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
                        subtitle: Text(store['category'] ?? 'Uncategorized'),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _navigateToStoreDetailsPage(store),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
