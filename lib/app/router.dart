import 'package:aut_toolkit/features/authentication/view/authentication_page.dart';
import 'package:aut_toolkit/features/eating_habits/view/eating_habits_list.dart';
import 'package:aut_toolkit/features/home/view/home_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final user = _auth.currentUser;
    final loggingIn = state.matchedLocation == '/';

    if (user != null) {
      // User is logged in, redirect from '/' to '/home'
      return loggingIn ? '/home' : null;
    } else {
      // User is not logged in, redirect to '/' if trying to access other pages
      return !loggingIn ? '/' : null;
    }
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => AuthenticationPage()),
    GoRoute(
        path: '/home', builder: (context, state) => HomeNavigation(), routes: [
      GoRoute(path: 'eating-habits',
          builder: (context, state) => EatingHabitsList()),
    ]),
  ],
);