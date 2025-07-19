import 'package:flutter/cupertino.dart';
class EcoHeroAvatar extends StatelessWidget {
  final String image;
  const EcoHeroAvatar({required this.image});
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(image, width: 56, height: 56, fit: BoxFit.cover),
    );
  }
}
