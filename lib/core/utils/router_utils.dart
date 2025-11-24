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
  static final String GOOD_HABITS = 'good-habits';
  static final String GOOD_HABITS_DETAIL = 'good-habit-detail';
  static final String GOOD_HABIT_EDIT = 'good-habit-edit';
  static final String CARDS = 'cards';
  static final String NEW_CARD = 'new-card';
  static final String CARD_ADD_ARASAAC = 'card-add-arasaac';
  static final String CARD_DETAIL = 'card-detail';
  static final String VISUAL_SUPPORTS = 'visual-supports';
  static final String FIRST_THEN_BOARDS = 'first-then-boards';
  static final String NEW_FIRST_THEN_BOARD = 'new-first-then-board';
  static final String USER_CARD_PICKER = 'user-card-picker';
  static final String FIRST_THEN_BOARD_SHOW = 'first-then-board-show';
  static final String VISUAL_LISTS = 'visual_lists';
  static final String NEW_VISUAL_LIST = 'new-visual-list';
  static final String NEW_VISUAL_LIST_CARD_PICKER = 'new-visual-list-card-picker';
  static final String VISUAL_LIST_DIAGRAM_SHOW = 'visual-list-diagram-show';
  static final String VISUAL_LIST_SCHEDULE_SHOW = 'visual-list-schedule-show';

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

  static String getGoodHabitsPath() => HOME + SLASH + GOOD_HABITS;
  static String getGoodHabitDetailPath() => getGoodHabitsPath() + SLASH + GOOD_HABITS_DETAIL;
  static String getGoodHabitDetailEditPath() => getGoodHabitDetailPath() + SLASH + GOOD_HABIT_EDIT;
  static String getNewGoodHabitPath() => getGoodHabitsPath() + SLASH + GOOD_HABIT_EDIT;

  static String getCardsPath() => HOME + SLASH + CARDS;
  static String getNewCardPath() => getCardsPath() + SLASH + NEW_CARD;
  static String getCardsARASAACPath() => getNewCardPath() + SLASH + CARD_ADD_ARASAAC;
  static String getCardDetailPath() => getCardsPath() + SLASH + CARD_DETAIL;
  static String getEditCardPath() => getCardDetailPath() + SLASH + NEW_CARD;
  static String getEditCardARASAACPath() => getEditCardPath() + SLASH + CARD_ADD_ARASAAC;

  static String getVisualSupportsPagePath() => HOME + SLASH + VISUAL_SUPPORTS;
  static String getFirstThenBoardsPath() => getVisualSupportsPagePath() + SLASH + FIRST_THEN_BOARDS;
  static String getNewFirstThenBoardPath() => getFirstThenBoardsPath() + SLASH + NEW_FIRST_THEN_BOARD;
  static String getNewFirstThenBoardUserCardPickerPath() => getNewFirstThenBoardPath() + SLASH + USER_CARD_PICKER;
  static String getFirstThenBoardShowPath() => getFirstThenBoardsPath() + SLASH + FIRST_THEN_BOARD_SHOW;
  static String getVisualListsPath() => getVisualSupportsPagePath() + SLASH + VISUAL_LISTS;
  static String getNewVisualListPath() => getVisualListsPath() + SLASH + NEW_VISUAL_LIST;
  static String getNewVisualListCardPickerPath() => getNewVisualListPath() + SLASH + NEW_VISUAL_LIST_CARD_PICKER;
  static String getVisualListDiagramShowPath() => getVisualListsPath() + SLASH + VISUAL_LIST_DIAGRAM_SHOW;
  static String getVisualListScheduleShowPath() => getVisualListsPath() + SLASH + VISUAL_LIST_SCHEDULE_SHOW;

  }