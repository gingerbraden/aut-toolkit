import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/features/authentication/view/authentication_page.dart';
import 'package:aut_toolkit/features/eating_habits/view/eating_habit_detail.dart';
import 'package:aut_toolkit/features/eating_habits/view/eating_habit_edit.dart';
import 'package:aut_toolkit/features/eating_habits/view/eating_habits_list.dart';
import 'package:aut_toolkit/features/home/view/home_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../features/eating_habits/domain/model/eating_habit.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final user = _auth.currentUser;
    final loggingIn = state.matchedLocation == RouterUtils.SLASH;

    if (user != null) {
      return loggingIn ? RouterUtils.HOME : null;
    } else {
      return !loggingIn ? RouterUtils.SLASH : null;
    }
  },
  routes: [
    GoRoute(path: RouterUtils.SLASH, builder: (context, state) => AuthenticationPage()),
    GoRoute(
      path: RouterUtils.HOME,
      builder: (context, state) => HomeNavigation(),
      routes: [
        GoRoute(
          path: RouterUtils.EATING_HABITS,
          builder: (context, state) => EatingHabitsList(),
          routes: [
            GoRoute(
              path: RouterUtils.EATING_HABIT_DETAIL,
              builder: (context, state) {
                final habit = state.extra as EatingHabit;
                return EatingHabitDetail(habit: habit);
              },
              routes: [
                GoRoute(
                  path: RouterUtils.EATING_HABIT_EDIT,
                  builder: (context, state) {
                    final habit = state.extra as EatingHabit;
                    return EatingHabitEdit(habit: habit, isNew: false,);
                  },
                )
              ]
            ),
            GoRoute(
              path: RouterUtils.EATING_HABIT_EDIT,
              builder: (context, state) {
                final habit = state.extra as EatingHabit;
                return EatingHabitEdit(habit: habit, isNew: true,);
              },
            )
          ],
        ),
      ],
    ),
  ],
);

