import '../model/eating_habit.dart';

class EatingHabitsRepository {
  final List<EatingHabit> eatingHabits = [
    EatingHabit()
      ..name = "Intermittent Fasting"
      ..description = "Eating only within an 8-hour window each day."
      ..from = DateTime(2025, 1, 1, 12, 0)
      ..to = DateTime(2025, 1, 1, 20, 0)
      ..isEatingFlag = true,

    EatingHabit()
      ..name = "No Sugar"
      ..description = "Avoiding refined sugar in all meals and drinks."
      ..from = DateTime(2025, 1, 2)
      ..to = DateTime(2025, 2, 2)
      ..isEatingFlag = true,

    EatingHabit()
      ..name = "Plant-Based Diet"
      ..description = "Focusing on vegetables, fruits, legumes, and grains."
      ..from = DateTime(2025, 3, 1)
      ..to = DateTime(2025, 6, 1)
      ..isEatingFlag = true,

    EatingHabit()
      ..name = "No Late-Night Snacks"
      ..description = "Avoid eating after 9 PM."
      ..from = DateTime(2025, 1, 1)
      ..to = DateTime(2025, 12, 31)
      ..isEatingFlag = false,

    EatingHabit()
      ..name = "Hydration Focus"
      ..description = "Drink at least 8 glasses of water per day."
      ..from = DateTime(2025, 1, 5)
      ..to = DateTime(2025, 12, 31)
      ..isEatingFlag = true,

    EatingHabit()
      ..name = "Mindful Eating"
      ..description = "Eat slowly, focus on taste and portion control."
      ..from = DateTime(2025, 2, 1)
      ..to = DateTime(2025, 4, 1)
      ..isEatingFlag = true,

    EatingHabit()
      ..name = "No Processed Food"
      ..description = "Avoid fast food and pre-packaged meals."
      ..from = DateTime(2025, 1, 10)
      ..to = DateTime(2025, 3, 10)
      ..isEatingFlag = false,

    EatingHabit()
      ..name = "Balanced Breakfast"
      ..description = "Have a protein-rich breakfast every morning."
      ..from = DateTime(2025, 1, 1, 7, 0)
      ..to = DateTime(2025, 1, 1, 9, 0)
      ..isEatingFlag = true,

    EatingHabit()
      ..name = "Calorie Tracking"
      ..description = "Log all meals to track daily calorie intake."
      ..from = DateTime(2025, 1, 1)
      ..to = DateTime(2025, 3, 31)
      ..isEatingFlag = true,

    EatingHabit()
      ..name = "Fruit Snack Swap"
      ..description = "Replace sugary snacks with fruits."
      ..from = DateTime(2025, 2, 10)
      ..to = DateTime(2025, 4, 10)
      ..isEatingFlag = true,
  ];

  List<EatingHabit> getHabits() {
    return eatingHabits;
  }
}
