import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/features/authentication/view/authentication_page.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_diary_entry_transport.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/view/challenging_behaviour_detail.dart';
import 'package:aut_toolkit/features/challenging_behaviour/view/challenging_behaviour_diary_entry_detail.dart';
import 'package:aut_toolkit/features/challenging_behaviour/view/challenging_behaviour_diary_entry_edit.dart';
import 'package:aut_toolkit/features/challenging_behaviour/view/challenging_behaviour_edit.dart';
import 'package:aut_toolkit/features/challenging_behaviour/view/challenging_behaviour_list.dart';
import 'package:aut_toolkit/features/eating_habits/view/eating_habit_detail.dart';
import 'package:aut_toolkit/features/eating_habits/view/eating_habit_edit.dart';
import 'package:aut_toolkit/features/eating_habits/view/eating_habits_list.dart';
import 'package:aut_toolkit/features/good_habits/domain/model/good_habit.dart';
import 'package:aut_toolkit/features/good_habits/view/good_habit_detail.dart';
import 'package:aut_toolkit/features/good_habits/view/good_habit_edit.dart';
import 'package:aut_toolkit/features/good_habits/view/good_habits_list.dart';
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
    GoRoute(
      path: RouterUtils.SLASH,
      builder: (context, state) => AuthenticationPage(),
    ),
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
                    return EatingHabitEdit(habit: habit, isNew: false);
                  },
                ),
              ],
            ),
            GoRoute(
              path: RouterUtils.EATING_HABIT_EDIT,
              builder: (context, state) {
                final habit = state.extra as EatingHabit;
                return EatingHabitEdit(habit: habit, isNew: true);
              },
            ),
          ],
        ),
// =============================================================================
        GoRoute(
          path: RouterUtils.CHALLENGING_BEHAVIOURS,
          builder: (context, state) => ChallengingBehaviourList(),
          routes: [
            GoRoute(
              path: RouterUtils.CHALLENGING_BEHAVIOUR_DETAIL,
              builder: (context, state) {
                final cb = state.extra as ChallengingBehaviour;
                return ChallengingBehaviourDetail(cbdef: cb);
              },
              routes: [
                GoRoute(
                  path: RouterUtils.CHALLENGING_BEHAVIOUR_EDIT,
                  builder: (context, state) {
                    final cb = state.extra as ChallengingBehaviour;
                    return ChallengingBehaviourEdit(cb: cb, isNew: false);
                  },
                ),
                GoRoute(
                  path: RouterUtils.CHALLENGING_BEHAVIOUR_DIARY_ENTRY_EDIT,
                  builder: (context, state) {
                    final cbdeTransport = state.extra as ChallengingBehaviourDiaryEntryTransport;
                    return ChallengingBehaviourDiaryEntryEdit(cbId: cbdeTransport.cbId, isNew: cbdeTransport.isNew, entry: cbdeTransport.entry,);
                  },
                ),
                GoRoute(
                  path: RouterUtils.CHALLENGING_BEHAVIOUR_DIARY_ENTRY_DETAIL,
                  builder: (context, state) {
                    final cbdeTransport = state.extra as ChallengingBehaviourDiaryEntryTransport;
                    return ChallengingBehaviourDiaryEntryDetail(entry: cbdeTransport.entry, cbId: cbdeTransport.cbId);
                  },
                  routes: [
                    GoRoute(
                      path: RouterUtils.CHALLENGING_BEHAVIOUR_DIARY_ENTRY_EDIT,
                      builder: (context, state) {
                        final cbdeTransport = state.extra as ChallengingBehaviourDiaryEntryTransport;
                        return ChallengingBehaviourDiaryEntryEdit(cbId: cbdeTransport.cbId, isNew: cbdeTransport.isNew, entry: cbdeTransport.entry,);
                      },
                    ),
                  ]
                ),
              ],
            ),
            GoRoute(
              path: RouterUtils.CHALLENGING_BEHAVIOUR_EDIT,
              builder: (conext, state) {
                final cb = state.extra as ChallengingBehaviour;
                return ChallengingBehaviourEdit(cb: cb, isNew: true);
              },
            ),
          ],
        ),
// =============================================================================
        GoRoute(
          path: RouterUtils.GOOD_HABITS,
          builder: (context, state) => GoodHabitsList(),
          routes: [
            GoRoute(
              path: RouterUtils.GOOD_HABITS_DETAIL,
              builder: (context, state) {
                final habit = state.extra as GoodHabit;
                return GoodHabitDetail(habit: habit);
              },
              routes: [
                GoRoute(
                  path: RouterUtils.GOOD_HABIT_EDIT,
                  builder: (context, state) {
                    final habit = state.extra as GoodHabit;
                    return GoodHabitEdit(habit: habit, isNew: false);
                  },
                ),
              ],
            ),
            GoRoute(
              path: RouterUtils.GOOD_HABIT_EDIT,
              builder: (context, state) {
                final habit = state.extra as GoodHabit;
                return GoodHabitEdit(habit: habit, isNew: true);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
