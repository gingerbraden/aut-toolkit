import 'package:aut_toolkit/features/authentication/view/authentication_page.dart';
import 'package:aut_toolkit/features/home/view/home_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => AuthenticationPage()),
    GoRoute(path: '/home', builder: (context, state) => HomePage()),
  ],
);
