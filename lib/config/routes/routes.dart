import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '/common/screens/screen_full_images_view.dart';
import '/core/screens/error_screen.dart';
import '/models/anime_category.dart';
import '/models/auth/user.dart';
import '/screens/animes/screen_favorite_animes.dart';
import '/screens/auth/screen_login.dart';
import '/screens/auth/screen_register.dart';
import '/screens/category_animes_screen.dart';
import '/screens/settings/screen_update_profile.dart';
import '/screens/view_all_animes_screen.dart';
import '/screens/view_all_seasonal_animes_screen.dart';
import '../../common/widgets/screen_image_view.dart';
import '../../screens/screen_anime_details.dart';
import '../../screens/screen_home.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      //! Initial Route
      GoRoute(
        path: '/',
        builder: (context, state) => const ScreenHome(),
      ),

      //! Login Screen
      GoRoute(
        path: ScreenLogin.routeName,
        builder: (context, state) => const ScreenLogin(),
      ),

      //! Register Screen
      GoRoute(
        path: ScreenRegister.routeName,
        builder: (context, state) => const ScreenRegister(),
      ),

      //! Anime details route
      GoRoute(
        path: ScreenAnimeDetails.routeName,
        builder: (context, state) {
          final int id = state.extra as int? ?? 0;
          return ScreenAnimeDetails(id: id);
        },
      ),

      //! View animes list view
      GoRoute(
        path: ViewAllAnimesScreen.routeName,
        builder: (context, state) {
          final Map<String, dynamic> arguments =
              state.extra as Map<String, dynamic>;
          final String rankingType = arguments['rankingType'] as String;
          final String label = arguments['label'] as String;

          return ViewAllAnimesScreen(
            rankingType: rankingType,
            label: label,
          );
        },
      ),

      //! View all seasonal animes
      GoRoute(
        path: ViewAllSeasonalAnimesScreen.routeName,
        builder: (context, state) {
          final Map<String, dynamic> arguments =
              state.extra as Map<String, dynamic>;
          final String label = arguments['label'] as String;

          return ViewAllSeasonalAnimesScreen(
            label: label,
          );
        },
      ),

      //! Screen that displays all images
      GoRoute(
        path: ScreenFullImagesView.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final imageUrls = extra['images'];
          final index = extra['index'];
          return ScreenFullImagesView(imageUrls: imageUrls, index: index);
        },
      ),

      //! Screen to display a single full image
      GoRoute(
        path: ScreenImageView.routeName,
        builder: (context, state) {
          final String imageUrl = state.extra as String? ?? '';
          return ScreenImageView(url: imageUrl);
        },
      ),

      //! Sceen update profile
      GoRoute(
        path: ScreenUpdateProfile.routeName,
        builder: (context, state) {
          final user = state.extra as User?;
          return ScreenUpdateProfile(user: user);
        },
      ),

      //! Screen Favorite Animes
      GoRoute(
        path: ScreenFavoriteAnimes.routeName,
        builder: (context, state) => const ScreenFavoriteAnimes(),
      ),
    ],
  );
}

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ScreenAnimeDetails.routeName:
      final id = settings.arguments as int;
      return _cupertinoRoute(
        view: ScreenAnimeDetails(id: id),
      );

    case ViewAllAnimesScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final rankingType = arguments['rankingType'] as String;
      final label = arguments['label'] as String;
      return _cupertinoRoute(
        view: ViewAllAnimesScreen(
          rankingType: rankingType,
          label: label,
        ),
      );

    case ViewAllSeasonalAnimesScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final label = arguments['label'] as String;
      return _cupertinoRoute(
        view: ViewAllSeasonalAnimesScreen(
          label: label,
        ),
      );

    case CategoryanimesScreen.routeName:
      final category = settings.arguments as AnimeCategory;
      return _cupertinoRoute(
        view: CategoryanimesScreen(
          category: category,
        ),
      );

    case ScreenHome.routeName:
      final index = settings.arguments as int?;
      return _cupertinoRoute(
        view: ScreenHome(
          index: index,
        ),
      );

    case ScreenImageView.routeName:
      final imageUrl = settings.arguments as String;
      return _cupertinoRoute(
        view: ScreenImageView(
          url: imageUrl,
        ),
      );

    default:
      return _cupertinoRoute(
        view: const ErrorScreen(
          error: 'The route you entered doesn\'t exist',
        ),
      );
  }
}

CupertinoPageRoute _cupertinoRoute({
  required Widget view,
}) {
  return CupertinoPageRoute(
    builder: (_) => view,
  );
}
