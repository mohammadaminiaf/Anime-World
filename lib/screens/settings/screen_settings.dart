import 'package:anime_world/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/common/styles/paddings.dart';
import '/cubits/anime_title_language_cubit.dart';
import '/cubits/theme_cubit.dart';
import '/screens/auth/screen_login.dart';
import '/widgets/settings/settings_button.dart';
import '/widgets/settings/settings_switch.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Padding(
          padding: Paddings.defaultPadding,
          child: Column(
            children: [
              // Dark Mode Switch
              const AppThemeSwitch(),

              const SizedBox(height: 10),

              // Anime Title Language Switch
              const AnimeTitleLanguageSwitch(),

              const SizedBox(height: 10),

              // Login Button
              if (AppConfig().currentUser == null)
                SettingsButton(
                  title: 'Login',
                  onPressed: () => context.push(ScreenLogin.routeName),
                ),

              if (AppConfig().currentUser != null)
                SettingsButton(
                  title: 'Logout',
                  onPressed: () {},
                ),
            ],
          ),
        ),
      );
    });
  }
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
