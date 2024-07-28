import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart'; // Import the geocoding package
import 'dart:io';

import 'TextInput3.dart';

class AddStorePage extends StatefulWidget {
  @override
  _AddStorePageState createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Map<String, TextEditingController> _openingHourControllers = {
    'Monday': TextEditingController(),
    'Tuesday': TextEditingController(),
    'Wednesday': TextEditingController(),
    'Thursday': TextEditingController(),
    'Friday': TextEditingController(),
    'Saturday': TextEditingController(),
    'Sunday': TextEditingController(),
  };
  final Map<String, TextEditingController> _closingHourControllers = {
    'Monday': TextEditingController(),
    'Tuesday': TextEditingController(),
    'Wednesday': TextEditingController(),
    'Thursday': TextEditingController(),
    'Friday': TextEditingController(),
    'Saturday': TextEditingController(),
    'Sunday': TextEditingController(),
  };

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  File? _productImage;
  String? _productImageUrl;

  File? _image;
  String? _imageUrl;
  List<Map<String, dynamic>> _products = []; // List to store products locally

  String _selectedCategory = 'FRUGT'; // Default category
  final List<String> _categories = ['FRUGT', 'GRUNT', 'ALLE'];

  @override
  void dispose() {
    _titleController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _productNameController.dispose();
    _productPriceController.dispose();
    _openingHourControllers.forEach((key, controller) => controller.dispose());
    _closingHourControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _pickStoreImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickProductImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref().child('store_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _addProductLocally() async {
    if (_productImage != null) {
      try {
        print('Uploading product image...');
        final imageUrl = await _uploadImage(_productImage!);
        setState(() {
          _products.add({
            'name': _productNameController.text,
            'price': int.parse(_productPriceController.text), // Store price as integer
            'image': imageUrl,
          });
          _productNameController.clear();
          _productPriceController.clear();
          _productImage = null;
          _productImageUrl = null;
        });
        print('Product added: $imageUrl');
      } catch (e) {
        print('Error uploading product image: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading product image: $e')));
      }
    } else {
      print('No product image selected');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a product image')));
    }
  }

  Future<void> _addStore() async {
    if (_image != null) {
      try {
        print('Uploading store image...');
        final imageUrl = await _uploadImage(_image!);
        setState(() {
          _imageUrl = imageUrl;
        });
        print('Store image uploaded: $imageUrl');
      } catch (e) {
        print('Error uploading store image: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading store image: $e')));
        return;
      }
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Map<String, List<String>> openingHours = {};
      _openingHourControllers.forEach((day, openController) {
        var closeController = _closingHourControllers[day];
        openingHours[day] = [
          openController.text.trim(),
          closeController?.text.trim() ?? ''
        ];
      });

      try {
        print('Adding store to Firestore...');
        await FirebaseFirestore.instance.collection('stores').add({
          'title': _titleController.text,
          'latitude': double.parse(_latitudeController.text),
          'longitude': double.parse(_longitudeController.text),
          'images': _imageUrl != null ? [_imageUrl] : [],
          'openingHours': openingHours,
          'category': _selectedCategory,
          'phone': _phoneController.text,
          'description': _descriptionController.text,
          'ownerId': user.uid,
          'products': _products, // Add products to Firestore
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Store added successfully')));
          Navigator.pop(context);  // Navigate back to the previous screen
        }
        print('Store added successfully');
      } catch (e) {
        print('Error adding store to Firestore: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding store: $e')));
        }
      }
    } else {
      print('User not authenticated');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: User not authenticated')));
      }
    }
  }

  Future<void> _getCoordinatesFromAddress() async {
    try {
      List<Location> locations = await locationFromAddress(_addressController.text);
      if (locations.isNotEmpty) {
        _latitudeController.text = locations.first.latitude.toString();
        _longitudeController.text = locations.first.longitude.toString();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No locations found for the address')));
      }
    } catch (e) {
      print('Error getting coordinates from address: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error getting coordinates from address: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 246, 238, 1),
      appBar: AppBar(
        title: Text("Add New Store"),
        backgroundColor: Color.fromRGBO(236, 233, 218, 1),
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInput3(hintText: 'Store Title', controller: _titleController),
            TextInput3(hintText: 'Address', controller: _addressController),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getCoordinatesFromAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Get Coordinates from Address',
                  style: GoogleFonts.outfit(
                    fontSize: (MediaQuery.of(context).size.height + MediaQuery.of(context).size.width) * 0.008 + 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextInput3(hintText: 'Latitude', controller: _latitudeController),
            TextInput3(hintText: 'Longitude', controller: _longitudeController),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _pickStoreImage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 150,
                width: double.infinity,
                child: _image == null
                    ? Center(child: Text('Tap to pick image'))
                    : Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: _selectedCategory,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                underline: Container(
                  height: 2,
                  color: Colors.transparent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: _categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            TextInput3(hintText: 'Phone', controller: _phoneController),
            TextInput3(hintText: 'Description', controller: _descriptionController),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Opening Hours',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ..._openingHourControllers.keys.map((day) {
              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(day, style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextInput3(
                      hintText: '$day Opening Time',
                      controller: _openingHourControllers[day]!,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextInput3(
                      hintText: '$day Closing Time',
                      controller: _closingHourControllers[day]!,
                    ),
                  ),
                ],
              );
            }).toList(),
            SizedBox(height: 20),
            Divider(),
            Text(
              'Add Products',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextInput3(hintText: 'Product Name', controller: _productNameController),
            TextInput3(hintText: 'Price', controller: _productPriceController),
            GestureDetector(
              onTap: _pickProductImage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 150,
                width: double.infinity,
                child: _productImage == null
                    ? Center(child: Text('Tap to pick product image'))
                    : Image.file(_productImage!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addProductLocally,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Add Product',
                  style: GoogleFonts.outfit(
                    fontSize: (MediaQuery.of(context).size.height + MediaQuery.of(context).size.width) * 0.008 + 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_products.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Products',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ..._products.map((product) => ListTile(
                        title: Text(product['name']),
                        subtitle: Text('Price: ${product['price']} DKK'), // Display price in DKK without decimals
                        trailing: product['image'] != null
                            ? Image.network(product['image'], width: 50, height: 50)
                            : null,
                      )),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addStore,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Add Store',
                  style: GoogleFonts.outfit(
                    fontSize: (MediaQuery.of(context).size.height + MediaQuery.of(context).size.width) * 0.008 + 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
