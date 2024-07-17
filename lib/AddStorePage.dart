import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _categoryController = TextEditingController();
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

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  File? _productImage;
  String? _productImageUrl;

  File? _image;
  String? _imageUrl;
  List<Map<String, dynamic>> _products = []; // List to store products locally

  @override
  void dispose() {
    _titleController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _categoryController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _productNameController.dispose();
    _productPriceController.dispose();
    _openingHourControllers.forEach((key, controller) => controller.dispose());
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
            'price': double.parse(_productPriceController.text),
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
      final openingHours = _openingHourControllers.map((key, controller) {
        return MapEntry(key, controller.text.split(','));
      });

      try {
        print('Adding store to Firestore...');
        await FirebaseFirestore.instance.collection('stores').add({
          'title': _titleController.text,
          'latitude': double.parse(_latitudeController.text),
          'longitude': double.parse(_longitudeController.text),
          'images': _imageUrl != null ? [_imageUrl] : [],
          'openingHours': openingHours,
          'category': _categoryController.text,
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
            TextInput3(hintText: 'Category', controller: _categoryController),
            TextInput3(hintText: 'Phone', controller: _phoneController),
            TextInput3(hintText: 'Description', controller: _descriptionController),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Opening Hours (comma separated for each day)',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ..._openingHourControllers.keys.map((day) {
              return TextInput3(
                hintText: '$day Opening Hours',
                controller: _openingHourControllers[day]!,
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
                        subtitle: Text('Price: \$${product['price']}'),
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
