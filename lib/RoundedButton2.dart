import 'package:flutter/material.dart';

class Roundedbutton2 extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  
  Roundedbutton2({required this.icon, required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(
        icon,
        color: Colors.black,
        size: 25,
      ),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(12),
        backgroundColor: Color.fromRGBO(236, 233, 218, 1), // <-- Button color
        foregroundColor: Color.fromRGBO(231, 228, 210, 1),
      ),
    );
  }
}
