import 'package:flutter/material.dart';

class PasswordDialog extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final String correctPassword;
  final Function onCorrectPassword;

  PasswordDialog({
    required this.correctPassword,
    required this.onCorrectPassword,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Admin Password'),
      content: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(hintText: 'Password'),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Submit'),
          onPressed: () {
            if (_passwordController.text == correctPassword) {
              Navigator.of(context).pop(); // Close the dialog
              onCorrectPassword();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Incorrect password'),
              ));
            }
          },
        ),
      ],
    );
  }
}
