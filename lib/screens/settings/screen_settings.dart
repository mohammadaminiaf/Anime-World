import 'package:anime_world/common/mixins/dialog_mixin.dart';
import 'package:anime_world/common/widgets/profile_tile.dart';
import 'package:anime_world/core/screens/error_screen.dart';
import 'package:anime_world/core/widgets/loader.dart';
import 'package:anime_world/models/auth/user.dart';
import 'package:anime_world/notifiers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/common/styles/paddings.dart';
import '/constants/app_config.dart';
import '/cubits/anime_title_language_cubit.dart';
import '/cubits/theme_cubit.dart';
import '/screens/auth/screen_login.dart';
import '/widgets/settings/settings_button.dart';
import '/widgets/settings/settings_switch.dart';

class ScreenSettings extends ConsumerWidget with DialogMixin {
  const ScreenSettings({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    // Show the dialog and wait for user confirmation
    final confirmed = await showTwoOptionDialog(
      context: context,
      title: 'Confirm Logout',
      content: 'Are you sure you want to log out?',
      yesButtonText: 'Logout',
      noButtonText: 'Cancel',
    );

    if (confirmed == true) {
      // Perform logout if confirmed
      await ref.read(authProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, child) {
      final userData = ref.watch(authProvider);

      return userData.when(
        data: (user) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            body: Padding(
              padding: Paddings.horizontalPadding,
              child: Column(
                children: [
                  if (user == null) const SizedBox(height: 10),
                  if (user != null) _buildProfileInfo(user: user),

                  // Dark Mode Switch
                  const AppThemeSwitch(),

                  const SizedBox(height: 10),

                  // Anime Title Language Switch
                  const AnimeTitleLanguageSwitch(),

                  const SizedBox(height: 10),

                  // Login Button or Logout Button
                  if (user == null)
                    SettingsButton(
                      title: 'Login',
                      onPressed: () => context.push(ScreenLogin.routeName),
                    ),
                  if (user != null)
                    SettingsButton(
                      title: 'Logout',
                      onPressed: () => _logout(context, ref),
                    ),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => ErrorScreen(error: error.toString()),
        loading: () => const Loader(),
      );
    });
  }

  Widget _buildProfileInfo({required User user}) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const ProfileTile(
          profileURL: '',
        ),
        title: Text(user.name ?? ''),
        subtitle: Text(user.email ?? ''),
      );
}

class AppThemeSwitch extends StatelessWidget {
  const AppThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        final isDarkMode = state == ThemeMode.dark;

        return SettingsSwitch(
          title: 'Dark Theme',
          value: isDarkMode,
          onChanged: (value) {
            context.read<ThemeCubit>().changeTheme(isDarkMode: value);
          },
        );
      },
    );
  }
}

class AnimeTitleLanguageSwitch extends StatelessWidget {
  const AnimeTitleLanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeTitleLanguageCubit, bool>(
      builder: (context, state) {
        return SettingsSwitch(
          title: 'Use English Names',
          value: state,
          onChanged: (value) {
            context.read<AnimeTitleLanguageCubit>().changeAnimeTitleLanguage(
                  isEnglish: value,
                );
          },
        );
      },
    );
  }
}
