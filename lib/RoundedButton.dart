import 'package:flutter/material.dart';

class Roundedbutton extends StatelessWidget {
  final IconData icon;
  Roundedbutton({required this.icon});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Icon(
        icon,
        color: Colors.black,
        size: 30,
      ),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(15),
        backgroundColor: Color.fromRGBO(236, 233, 218, 1), // <-- Button color
        foregroundColor: Color.fromRGBO(231, 228, 210, 1),
      ),
    );
  }
}
