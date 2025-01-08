import 'dart:io';

class UpdateProfileParams {
  final String userId;
  final String? name;
  final String? email;
  final String? phone;
  final File? profilePhoto;

  UpdateProfileParams({
    required this.userId,
    this.name,
    this.email,
    this.phone,
    this.profilePhoto,
  });
}
