import 'package:anime_world/screens/animes/screen_favorite_animes.dart';
import 'package:anime_world/screens/auth/screen_register.dart';
import 'package:anime_world/screens/settings/screen_update_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/common/mixins/dialog_mixin.dart';
import '/common/styles/paddings.dart';
import '/common/widgets/profile_tile.dart';
import '/cubits/anime_title_language_cubit.dart';
import '/cubits/theme_cubit.dart';
import '/models/auth/user.dart';
import '/notifiers/auth_notifier.dart';
import '/screens/auth/screen_login.dart';
import '/widgets/settings/settings_button.dart';
import '/widgets/settings/settings_switch.dart';

class ScreenSettings extends ConsumerWidget with DialogMixin {
  const ScreenSettings({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showTwoOptionDialog(
      context: context,
      title: 'Confirm Logout',
      content: 'Are you sure you want to log out?',
      yesButtonText: 'Logout',
      noButtonText: 'Cancel',
    );

    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the user state, but don't handle loading or error states here
    final user = ref.watch(authProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: Paddings.horizontalPadding,
        child: Column(
          children: [
            // Show user info if logged in, otherwise show spacing
            // if (user != null) _buildProfileInfo(user: user),
            if (user == null) const SizedBox(height: 10),

            // Dark Mode Switch
            const AppThemeSwitch(),

            const SizedBox(height: 10),

            // Anime Title Language Switch
            const AnimeTitleLanguageSwitch(),

            const SizedBox(height: 10),

            // Login or Logout Button
            if (user == null) ...[
              SettingsButton(
                title: 'Login',
                onPressed: () => context.push(ScreenLogin.routeName),
              ),
              SettingsButton(
                title: 'Register',
                onPressed: () => context.push(ScreenRegister.routeName),
              ),
            ],
            if (user != null) ...[
              SettingsButton(
                title: 'Favorite Animes',
                onPressed: () => context.push(
                  ScreenFavoriteAnimes.routeName,
                  extra: user,
                ),
              ),
              SettingsButton(
                title: 'Update Profile',
                onPressed: () => context.push(
                  ScreenUpdateProfile.routeName,
                  extra: user,
                ),
              ),
              SettingsButton(
                title: 'Logout',
                onPressed: () => _logout(context, ref),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo({required User user}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Card(
          color: Colors.white.withAlpha(50),
          margin: EdgeInsets.zero,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            leading: ProfileTile(radius: 30, profileURL: user.profileUrl),
            title: Text(user.name),
            subtitle: Text(user.email ?? 'No Email'),
          ),
        ),
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
