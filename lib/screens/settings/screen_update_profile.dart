import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/common/buttons/round_button.dart';
import '/common/text_fields/round_text_field.dart';
import '/common/utils/pick_image_helpers.dart';
import '/common/utils/utils.dart';
import '/common/widgets/profile_tile.dart';
import '/models/auth/user.dart';
import '/models/params/update_profile_params.dart';
import '/notifiers/auth_notifier.dart';
import '/screens/screen_home.dart';

class ScreenUpdateProfile extends ConsumerStatefulWidget {
  final User? user;

  const ScreenUpdateProfile({
    super.key,
    required this.user,
  });

  static const routeName = '/screen-edit-profile';

  @override
  ConsumerState<ScreenUpdateProfile> createState() =>
      _ScreenUpdateProfileState();
}

class _ScreenUpdateProfileState extends ConsumerState<ScreenUpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;

  // Text Fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.user?.name ?? '';
    _emailController.text = widget.user?.email ?? '';
    _phoneController.text = widget.user?.phone ?? '';
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await PickImageHelpers.pickAndCropImage();

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future _updateProfile() async {
    final userParams = UpdateProfileParams(
      userId: widget.user?.id ?? '',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      profilePhoto: _profileImage,
    );

    await ref.read(authProvider.notifier).updateUser(user: userParams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),
              // Profile Picture Display
              ProfileTile(
                text: widget.user?.name,
                radius: 50,
                profileURL:
                    _profileImage?.path ?? widget.user?.profileUrl ?? '',
                onTap: _pickImage,
                isLocal: _profileImage != null,
              ),

              const SizedBox(height: 16),
              _buildUpdateProfileForm(),
              const SizedBox(height: 16),
              Consumer(builder: (context, ref, child) {
                final user = ref.watch(authProvider);

                ref.listen(
                  authProvider,
                  (previous, next) {
                    if (next is AsyncData && next.value != null) {
                      // User successfully logged in
                      Utils.showSnackBar(
                        context: context,
                        text: 'Profile Updated Successfully!',
                      );

                      // Navigate to home screen
                      context.go(ScreenHome.routeName);
                    } else if (next is AsyncError) {
                      // Login failed
                      Utils.showSnackBar(
                        context: context,
                        text: 'Failed to update the user: ${next.error}',
                      );
                    }
                  },
                );

                return RoundButton(
                  onPressed: _updateProfile,
                  label: 'Update Profile',
                  isLoading: user.isLoading,
                  labelStyle: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateProfileForm() => Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            RoundTextField(
              controller: _nameController,
              hintText: 'Full Name',
            ),
            const SizedBox(height: 10),
            RoundTextField(
              controller: _emailController,
              hintText: 'Email',
            ),
            const SizedBox(height: 10),
            RoundTextField(
              controller: _phoneController,
              hintText: 'Phone',
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
}
