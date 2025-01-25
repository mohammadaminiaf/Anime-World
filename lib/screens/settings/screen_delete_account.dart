import 'package:anime_world/common/buttons/round_button.dart';
import 'package:anime_world/common/utils/utils.dart';
import 'package:anime_world/constants/app_config.dart';
import 'package:anime_world/notifiers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ScreenDeleteAccount extends ConsumerWidget {
  static const String routeName = '/screen-delete-account';

  const ScreenDeleteAccount({super.key});

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final userId = AppConfig().currentUser?.id ?? '';
      await ref.read(authProvider.notifier).deleteUser(userId: userId);
    }
  }

  void _listen(BuildContext context, WidgetRef ref) {
    ref.listen(
      authProvider,
      (prev, next) {
        if (prev is AsyncLoading) {
          if (next is AsyncError) {
            Utils.showSnackBar(
              text: 'Could not delete account',
              context: context,
            );
          } else if (next is AsyncData) {
            Utils.showSnackBar(
              text: 'Your account was delete successfully',
              context: context,
            );
            context.pop();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listen(context, ref);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            RoundButton(
              onPressed: () => _showDeleteDialog(context, ref),
              label: 'Delete Account',
              isLoading: ref.watch(authProvider).isLoading,
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

// Success screen after account deletion
class AccountDeletedSuccessScreen extends StatelessWidget {
  const AccountDeletedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Account Deleted Successfully',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the home screen or login screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// Mock home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
