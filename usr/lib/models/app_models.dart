enum Gender { male, female, other }
enum Goal { loseWeight, maintain, gainMuscle, health }

class UserProfile {
  Gender gender;
  int age;
  double weight; // in kg
  double height; // in cm
  Goal goal;

  UserProfile({
    this.gender = Gender.male,
    this.age = 25,
    this.weight = 70,
    this.height = 175,
    this.goal = Goal.maintain,
  });

  // Simple BMR Calculation (Mifflin-St Jeor Equation)
  double get dailyCalorieTarget {
    double bmr;
    if (gender == Gender.male) {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    // Adjust based on goal (assuming moderate activity factor 1.55 for simplicity)
    double tdee = bmr * 1.55;

    switch (goal) {
      case Goal.loseWeight:
        return tdee - 500;
      case Goal.gainMuscle:
        return tdee + 300;
      case Goal.maintain:
      case Goal.health:
        return tdee;
    }
  }

  String get dietPlanRecommendation {
    switch (goal) {
      case Goal.loseWeight:
        return "Focus on high protein, high fiber, and a caloric deficit. Aim for 40% Protein, 30% Fat, 30% Carbs.";
      case Goal.gainMuscle:
        return "High protein intake is key. Surplus calories required. Aim for 30% Protein, 20% Fat, 50% Carbs.";
      case Goal.maintain:
        return "Balanced diet with whole foods. 25% Protein, 30% Fat, 45% Carbs.";
      case Goal.health:
        return "Focus on micronutrients, vegetables, and lean meats. Avoid processed sugars.";
    }
  }
}

class FoodEntry {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime timestamp;
  final String? imagePath;

  FoodEntry({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.timestamp,
    this.imagePath,
  });
}
