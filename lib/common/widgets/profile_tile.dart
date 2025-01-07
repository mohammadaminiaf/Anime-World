import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final String? profileURL;
  final void Function()? onTap;
  final bool isGroup;
  final String? text;
  final double radius;
  final double iconSize;

  const ProfileTile({
    super.key,
    required this.profileURL,
    this.onTap,
    this.isGroup = false,
    this.text,
    this.radius = 20.0,
    this.iconSize = 24.0,
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
      size: iconSize,
    );

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.primaries[_getColorIndexFromText()],
        child: profileURL == null || profileURL!.isEmpty
            ? avatarIcon
            : ClipOval(
                child: CachedNetworkImage(
                  imageUrl: profileURL!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator.adaptive(),
                  errorWidget: (context, url, error) => avatarIcon,
                ),
              ),
      ),
    );
  }
}

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class ProfileTile extends StatelessWidget {
//   final void Function()? onTap;
//   final bool? isGroup;
//   final String? text;
//   final double? radius;
//   final double? iconSize;

//   const ProfileTile({
//     super.key,
//     required this.profileURL,
//     this.isGroup,
//     this.radius,
//     this.onTap,
//     this.text,
//     this.iconSize,
//   });

//   final String? profileURL;

//   int checkMiddleCharacter() {
//     if (text == null) {
//       return 1; // Return -1 for null or empty text
//     }

//     int midIndex = text!.length ~/ 2;
//     String? middleChar;

//     if (text != null && text!.isNotEmpty) {
//       int midIndex = text!.length ~/ 2;
//       middleChar =
//           text!.length % 2 == 0 ? text![midIndex - 1] : text![midIndex];
//     } else {
//       middleChar = null; // Handle the case where the string is null or empty
//     }

//     switch (middleChar) {
//       case 'a':
//         return 1;
//       case 'b':
//         return 2;
//       case 'c':
//         return 3;
//       case 'd':
//         return 4;
//       case 'e':
//         return 5;
//       case 'f':
//         return 6;
//       case 'g':
//         return 7;
//       case 'h':
//         return 8;
//       case 'i':
//         return 9;
//       case 'j':
//         return 10;
//       case 'k':
//         return 11;
//       case 'l':
//         return 12;
//       default:
//         return 0; // Return 0 if the middle character is not in the specified list
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final avatarChild = isGroup == true
//         ? Icon(
//             CupertinoIcons.person_3_fill,
//             color: theme.scaffoldBackgroundColor,
//             size: iconSize ?? 30,
//           )
//         : Icon(
//             CupertinoIcons.person_fill,
//             color: theme.scaffoldBackgroundColor,
//             size: iconSize ?? 30,
//           );

//     var circleAvatar = CircleAvatar(
//       radius: radius ?? 17,
//       backgroundColor: Colors.primaries[checkMiddleCharacter()],
//       child: profileURL == null || profileURL?.isEmpty == true
//           ? avatarChild
//           : ClipRRect(
//               borderRadius: BorderRadius.circular(radius ?? 100),
//               child: CachedNetworkImage(
//                 imageUrl: profileURL ?? '',
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) =>
//                     const CircularProgressIndicator.adaptive(),
//                 errorWidget: (context, url, error) => avatarChild,
//               ),
//             ),
//     );
//     return GestureDetector(
//       onTap: onTap,
//       child: circleAvatar,
//     );
//   }
// }
