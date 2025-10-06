import 'package:flutter/material.dart';

class ProfileImageComponent extends StatelessWidget {
  final String? profileImage;
  final double radius;
  const ProfileImageComponent({
    super.key,
    this.profileImage,
    this.radius = 15
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: profileImage == null
        ? AssetImage('assets/images/profile.png')
        : NetworkImage(profileImage!),
    );
  }
}