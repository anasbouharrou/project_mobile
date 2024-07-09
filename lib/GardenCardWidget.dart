import 'package:flutter/material.dart';

class GardenCardWidget extends StatelessWidget {
  final String title;
  final String distance;
  final String imagePath;
  final VoidCallback onTap; // Added onTap callback

  const GardenCardWidget({
    Key? key,
    required this.title,
    required this.distance,
    required this.imagePath,
    required this.onTap, // Added onTap to constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Added onTap to GestureDetector
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        width: 150 + MediaQuery.of(context).size.height * 0.1,
        height: 50 + MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.network(
                imagePath,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 6 +
                            (MediaQuery.of(context).size.height +
                                    MediaQuery.of(context).size.height) *
                                0.006,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      distance,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
