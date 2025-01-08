import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/constants/endpoints.dart';

class ProfileTile extends StatelessWidget {
  final String? profileURL;
  final void Function()? onTap;
  final bool isGroup;
  final String? text;
  final double radius;
  final double iconSize;
  final bool isLocal;
  final Color borderColor;
  final double borderWidth;

  const ProfileTile({
    super.key,
    required this.profileURL,
    this.onTap,
    this.isGroup = false,
    this.text,
    this.radius = 20.0,
    this.iconSize = 24.0,
    this.isLocal = false,
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
  });

  /// Determines the middle character-based color index from `Colors.primaries`.
  int _getColorIndexFromText() {
    if (text == null || text!.isEmpty) return 0;

    final midIndex = text!.length ~/ 2;
    final middleChar = text![midIndex].toLowerCase();

    // Map characters 'a' to 'z' to indices 0-25.
    final charCode = middleChar.codeUnitAt(0);
    if (charCode >= 'a'.codeUnitAt(0) && charCode <= 'z'.codeUnitAt(0)) {
      return (charCode - 'a'.codeUnitAt(0)) % Colors.primaries.length;
    }

    // Fallback index for non-alphabetic characters.
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Default icon based on group status.
    final avatarIcon = Icon(
      isGroup ? CupertinoIcons.person_3_fill : CupertinoIcons.person_fill,
      color: theme.scaffoldBackgroundColor,
      size: radius + (radius / 5),
    );

    final image = (isLocal && profileURL != null)
        ? Image.file(
            File(profileURL!),
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            imageUrl: Endpoints.getImage(profileURL!),
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const CircularProgressIndicator.adaptive(),
            errorWidget: (context, url, error) => avatarIcon,
          );

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: radius + borderWidth,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.primaries[_getColorIndexFromText()],
          child: profileURL == null || profileURL!.isEmpty
              ? avatarIcon
              : ClipOval(child: image),
        ),
      ),
    );
  }
}
