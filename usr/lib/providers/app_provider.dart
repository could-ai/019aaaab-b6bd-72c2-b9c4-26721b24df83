import 'package:flutter/material.dart';
import '../models/app_models.dart';

class AppProvider with ChangeNotifier {
  UserProfile _userProfile = UserProfile();
  final List<FoodEntry> _foodLog = [];
  bool _isProfileSet = false;

  UserProfile get userProfile => _userProfile;
  List<FoodEntry> get foodLog => _foodLog;
  bool get isProfileSet => _isProfileSet;

  int get totalCaloriesConsumed {
    return _foodLog.fold(0, (sum, item) => sum + item.calories);
  }

  void updateUserProfile(UserProfile newProfile) {
    _userProfile = newProfile;
    _isProfileSet = true;
    notifyListeners();
  }

  void addFoodEntry(FoodEntry entry) {
    _foodLog.add(entry);
    notifyListeners();
  }

  // Mock AI Analysis
  Future<FoodEntry> analyzeImage(String imagePath) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Return a mock result
    return FoodEntry(
      id: DateTime.now().toString(),
      name: "Grilled Chicken Salad",
      calories: 450,
      protein: 40,
      carbs: 15,
      fat: 20,
      timestamp: DateTime.now(),
      imagePath: imagePath,
    );
  }
}
