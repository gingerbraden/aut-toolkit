import '../../app/router.dart';

class RouterUtils {

  static final String HOME = '/home';
  static final String SLASH = '/';
  static final String EATING_HABITS = 'eating-habits';
  static final String EATING_HABIT_DETAIL = 'eating-habit-detail';
  static final String EATING_HABIT_EDIT = 'eating-habit-edit';
  static final String NEW_EATING_HABIT = 'eating-habit-edit';

  static  String getEatingHabitsPath() => HOME + SLASH + EATING_HABITS;
  static String getEatingHabitDetailPath() => getEatingHabitsPath() + SLASH + EATING_HABIT_DETAIL;
  static String getEatingHabitDetailEditPath() => getEatingHabitDetailPath() + SLASH + EATING_HABIT_EDIT;
  static String getNewEatingHabitPath() => getEatingHabitsPath() + SLASH + NEW_EATING_HABIT;


}