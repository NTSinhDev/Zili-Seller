import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zili_coffee/res/res.dart';

class Avatar extends StatelessWidget {
  final String? avatar;
  final double size;
  const Avatar({super.key, required this.avatar, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(color: AppColors.primary),
          ),
          child: Icon(Icons.person, size: size / 1.5, color: AppColors.primary),
        ),
        CircleAvatar(
          backgroundImage: (avatar ?? "").isNotEmpty
              ? CachedNetworkImageProvider(avatar!)
              : null,
          radius: size / 2,
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
