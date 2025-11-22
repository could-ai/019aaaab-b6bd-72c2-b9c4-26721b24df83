import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_models.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final user = appProvider.userProfile;
    final consumed = appProvider.totalCaloriesConsumed;
    final target = user.dailyCalorieTarget.round();
    final remaining = target - consumed;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calorie Tracker Pro"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate back to survey to edit profile if needed
              Navigator.pushNamed(context, '/survey');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatColumn(context, "Eaten", "$consumed", Colors.orange),
                      _buildCircularIndicator(context, consumed, target),
                      _buildStatColumn(context, "Remaining", "$remaining", Colors.green),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Target: $target kcal",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),

            // Diet Plan Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Your Diet Plan",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Goal: ${_getGoalName(user.goal)}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(user.dietPlanRecommendation),
                  ],
                ),
              ),
            ),

            // Recent Meals
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Meals",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            
            if (appProvider.foodLog.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: Text("No meals logged yet. Tap + to add.")),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appProvider.foodLog.length,
                itemBuilder: (context, index) {
                  final food = appProvider.foodLog[appProvider.foodLog.length - 1 - index]; // Reverse order
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade100,
                      child: const Icon(Icons.fastfood, color: Colors.orange),
                    ),
                    title: Text(food.name),
                    subtitle: Text("${food.protein}g Pro • ${food.carbs}g Carb • ${food.fat}g Fat"),
                    trailing: Text(
                      "${food.calories} kcal",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                },
              ),
            
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
        },
        label: const Text("Scan Food"),
        icon: const Icon(Icons.camera_alt),
      ),
    );
  }

  String _getGoalName(Goal goal) {
    switch (goal) {
      case Goal.loseWeight: return "Lose Weight";
      case Goal.gainMuscle: return "Gain Muscle";
      case Goal.maintain: return "Maintain Weight";
      case Goal.health: return "Healthy Lifestyle";
    }
  }

  Widget _buildStatColumn(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildCircularIndicator(BuildContext context, int current, int target) {
    double progress = target > 0 ? current / target : 0;
    if (progress > 1) progress = 1;

    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: progress * 100,
                  color: Theme.of(context).colorScheme.primary,
                  radius: 10,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: (1 - progress) * 100,
                  color: Colors.grey.shade300,
                  radius: 10,
                  showTitle: false,
                ),
              ],
              startDegreeOffset: 270,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
