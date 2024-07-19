import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'TextInput3.dart'; // Import the TextInput3 widget

class StoreDetailsPage extends StatefulWidget {
  final Map<String, dynamic> store;

  StoreDetailsPage({required this.store});

  @override
  _StoreDetailsPageState createState() => _StoreDetailsPageState();
}

class _StoreDetailsPageState extends State<StoreDetailsPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _appointmentController;
  late TextEditingController _productNameController;
  late TextEditingController _productPriceController;
  Map<String, TextEditingController> _openingHourControllers = {};
  Map<String, TextEditingController> _closingHourControllers = {};
  File? _storeImage;
  String? _storeImageUrl;
  File? _productImage;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _initialProducts = [];

  String _selectedCategory = 'FRUGT'; // Default category
  final List<String> _categories = ['FRUGT', 'GRUNT', 'ALLE'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.store['title']);
    _descriptionController = TextEditingController(text: widget.store['description']);
    _phoneController = TextEditingController(text: widget.store['phone']);
    _addressController = TextEditingController(text: widget.store['address'] ?? '');
    _appointmentController = TextEditingController(text: widget.store['appointment'] ?? '');
    _productNameController = TextEditingController();
    _productPriceController = TextEditingController();
    _selectedCategory = widget.store['category'] ?? 'FRUGT';

    if (widget.store['products'] != null) {
      _initialProducts = List<Map<String, dynamic>>.from(widget.store['products']);
      _products = List<Map<String, dynamic>>.from(widget.store['products']);
    }

    // Initialize opening and closing hour controllers
    List<String> days = ['Mandag', 'Tirsdag', 'Onsdag', 'Torsdag', 'Fredag', 'Lørdag', 'Søndag'];
    for (var day in days) {
      if (widget.store['openingHours'] != null && widget.store['openingHours'][day] != null) {
        var hours = widget.store['openingHours'][day] as List;
        _openingHourControllers[day] = TextEditingController(text: hours.isNotEmpty ? hours.first : '');
        _closingHourControllers[day] = TextEditingController(text: hours.length > 1 ? hours.last : '');
      } else {
        _openingHourControllers[day] = TextEditingController();
        _closingHourControllers[day] = TextEditingController();
      }
    }
  }

  Future<void> _pickStoreImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _storeImage = File(pickedFile.path);
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

  Future<void> _updateStore() async {
    try {
      if (_storeImage != null) {
        _storeImageUrl = await _uploadImage(_storeImage!);
      }

      Map<String, List<String>> updatedOpeningHours = {};
      _openingHourControllers.forEach((day, openController) {
        var closeController = _closingHourControllers[day];
        updatedOpeningHours[day] = [
          openController.text.trim(),
          closeController?.text.trim() ?? ''
        ];
      });

      await FirebaseFirestore.instance.collection('stores').doc(widget.store['id']).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'appointment': _appointmentController.text,
        'openingHours': updatedOpeningHours,
        'category': _selectedCategory,
        'images': _storeImageUrl != null ? [_storeImageUrl!] : widget.store['images'],
        'products': _products,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Store updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating store: $e')));
    }
  }

  Future<void> _addProductLocally() async {
    if (_productImage != null) {
      try {
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
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product added successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading product image: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a product image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 246, 238, 1),
      appBar: AppBar(
        title: Text(widget.store['title'], style: GoogleFonts.outfit(fontWeight: FontWeight.w900)),
        backgroundColor: Color.fromRGBO(247, 246, 238, 1),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInput3(hintText: 'Store Title', controller: _titleController),
            SizedBox(height: 10),
            TextInput3(hintText: 'Description', controller: _descriptionController, obscureText: false),
            SizedBox(height: 10),
            TextInput3(hintText: 'Phone', controller: _phoneController),
            SizedBox(height: 10),
            TextInput3(hintText: 'Address', controller: _addressController),
            SizedBox(height: 10),
            TextInput3(hintText: 'Appointment', controller: _appointmentController),
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
                child: _storeImage == null
                    ? (widget.store['images'] != null && widget.store['images'].isNotEmpty
                        ? Image.network(widget.store['images'][0], fit: BoxFit.cover)
                        : Center(child: Text('Tap to pick store image')))
                    : Image.file(_storeImage!, fit: BoxFit.cover),
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
            SizedBox(height: 10),
            _buildOpeningHours(),
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
            Center(
              child: ElevatedButton(
                onPressed: _updateStore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
                child: Text('Save', style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpeningHours() {
    List<String> days = ['Mandag', 'Tirsdag', 'Onsdag', 'Torsdag', 'Fredag', 'Lørdag', 'Søndag'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: days.map((day) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(day, style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
              ),
              Expanded(
                flex: 1,
                child: TextInput3(
                  hintText: 'Opening Time',
                  controller: _openingHourControllers[day]!,
                ),
              ),
              Expanded(
                flex: 1,
                child: TextInput3(
                  hintText: 'Closing Time',
                  controller: _closingHourControllers[day]!,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
