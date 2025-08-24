import 'package:flutter/material.dart';

class EcoHeroAvatar extends StatelessWidget {
  final String image;
  const EcoHeroAvatar({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(image, width: 56, height: 56, fit: BoxFit.cover),
    );
  }
}
