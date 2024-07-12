import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Map<String, TextEditingController> _openingHourControllers = {};
  Map<String, TextEditingController> _closingHourControllers = {};

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.store['title']);
    _descriptionController = TextEditingController(text: widget.store['description']);
    _phoneController = TextEditingController(text: widget.store['phone']);
    _addressController = TextEditingController(text: widget.store['address'] ?? '');
    _appointmentController = TextEditingController(text: widget.store['appointment'] ?? '');

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

  Future<void> _updateStore() async {
    try {
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
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Store updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating store: $e')));
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
            _buildOpeningHours(),
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
