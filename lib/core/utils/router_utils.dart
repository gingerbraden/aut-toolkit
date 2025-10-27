class RouterUtils {

  static final String HOME = '/home';
  static final String SLASH = '/';
  static final String EATING_HABITS = 'eating-habits';
  static final String EATING_HABIT_DETAIL = 'eating-habit-detail';
  static final String EATING_HABIT_EDIT = 'eating-habit-edit';
  static final String CHALLENGING_BEHAVIOURS = 'challenging-behaviours';
  static final String CHALLENGING_BEHAVIOUR_DETAIL = 'challenging-behaviour-detail';
  static final String CHALLENGING_BEHAVIOUR_EDIT = 'challenging-behaviour-edit';
  static final String CHALLENGING_BEHAVIOUR_DIARY_ENTRY_DETAIL = 'challenging-behaviour-diary-entry';
  static final String CHALLENGING_BEHAVIOUR_DIARY_ENTRY_EDIT = 'challenging-behaviour-diary-entry-edit';




  static String getEatingHabitsPath() => HOME + SLASH + EATING_HABITS;
  static String getEatingHabitDetailPath() => getEatingHabitsPath() + SLASH + EATING_HABIT_DETAIL;
  static String getEatingHabitDetailEditPath() => getEatingHabitDetailPath() + SLASH + EATING_HABIT_EDIT;
  static String getNewEatingHabitPath() => getEatingHabitsPath() + SLASH + EATING_HABIT_EDIT;

  static String getChallengingBehavioursPath() => HOME + SLASH + CHALLENGING_BEHAVIOURS;
  static String getChallengingBehaviourDetailPath() => getChallengingBehavioursPath() + SLASH + CHALLENGING_BEHAVIOUR_DETAIL;
  static String getNewChallengingBehaviourPath() => getChallengingBehavioursPath() + SLASH + CHALLENGING_BEHAVIOUR_EDIT;
  static String getChallengingBehaviourEditPath() => getChallengingBehaviourDetailPath() + SLASH + CHALLENGING_BEHAVIOUR_EDIT;
  static String getChallengingBehaviourDiaryEntryDetailPath() => getChallengingBehaviourDetailPath() + SLASH + CHALLENGING_BEHAVIOUR_DIARY_ENTRY_DETAIL;
  static String getNewChallengingBehaviourDiaryEntryPath() => getChallengingBehaviourDetailPath() + SLASH + CHALLENGING_BEHAVIOUR_DIARY_ENTRY_EDIT;
  static String getChallengingBehaviourDiaryEntryEditPath() => getChallengingBehaviourDiaryEntryDetailPath() + SLASH + CHALLENGING_BEHAVIOUR_DIARY_ENTRY_EDIT;

}