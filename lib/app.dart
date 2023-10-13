import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:tamini_app/themes/primary_theme.dart';
import 'package:tamini_app/pages/home_page.dart';
import 'package:tamini_app/pages/owner_tracking_requests.dart';
import 'package:tamini_app/pages/profile.dart';
import 'package:tamini_app/pages/registration.dart';
import 'package:tamini_app/pages/request_quotations.dart';
import 'package:tamini_app/pages/request_refund.dart';
import 'package:tamini_app/pages/user_tracking_requests.dart';

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return checkUserAuthentication() ? const HomePage() : const Registration();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'registration',
            builder: (BuildContext context, GoRouterState state) {
              return const Registration();
            },
          ),
          GoRoute(
            path: 'request_quotations',
            builder: (BuildContext context, GoRouterState state) {
              return const RequestQuotations();
            },
          ),
          GoRoute(
            path: 'request_refund',
            builder: (BuildContext context, GoRouterState state) {
              return const RequestRefund();
            },
          ),
          GoRoute(
            path: 'user_tracking_requests',
            builder: (BuildContext context, GoRouterState state) {
              return const UserTrackingRequests();
            },
          ),
          GoRoute(
            path: 'owner_tracking_requests',
            builder: (BuildContext context, GoRouterState state) {
              return const OwnerTrackingRequests();
            },
          ),
          GoRoute(
            path: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              return const ProfilePage();
            },
          ),
        ],
      ),
    ],
  );

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set the directories where the translation JSON files are located
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return MaterialApp.router(
      routerConfig: _router,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      locale: const Locale('ar', 'SA'), // Set the default locale to Arabic
      supportedLocales: const [
        Locale('ar', 'SA'), // Arabic
        Locale('en', 'US'), // English
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        // If the device's language is Arabic and Arabic is supported by the app
        if (deviceLocale?.languageCode == 'ar' && supportedLocales.contains(const Locale('ar', 'SA'))) {
          return const Locale('ar', 'SA'); // Use Arabic
        } else {
          return const Locale('en', 'US'); // Use English otherwise
        }
      },
      theme: primaryTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

bool checkUserAuthentication() {
  /// Get the current user from Firebase Authentication
  /// Check if the firebaseUser is not null, indicating the user is authenticated
  /// Return true if authenticated, otherwise return false

  return FirebaseAuth.instance.currentUser != null ? true : false;
}
