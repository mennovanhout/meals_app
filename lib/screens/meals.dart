import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/filters_provider.dart';
import 'package:meals_app/screens/meal.dart';
import 'package:meals_app/widgets/meal_item.dart';

class MealsScreen extends ConsumerWidget {
  const MealsScreen(this.category, {super.key, this.meals});

  final Category category;
  final List<Meal>? meals;

  void _onSelectMeal(BuildContext context, Meal meal) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MealScreen(
                  meal,
                )));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredMealsFromProvider = ref.watch(filteredMealsProvider);

    final List<Meal> filteredMeals = meals ??
        filteredMealsFromProvider
            .where((meal) => meal.categories.contains(category.id))
            .toList();

    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Uh oh... Nothing here!',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(color: category.color),
          ),
          const SizedBox(
            height: 10,
          ),
          Text('Try selecting a different category',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: category.color))
        ],
      ),
    );

    if (filteredMeals.isNotEmpty) {
      content = ListView.builder(
          itemCount: filteredMeals.length,
          itemBuilder: (context, index) =>
              MealItem(filteredMeals[index], category.color, () {
                _onSelectMeal(context, filteredMeals[index]);
              }));
    }

    if (category.id == 'fav') {
      return content;
    }

    return Scaffold(appBar: AppBar(title: Text(category.title)), body: content);
  }
}
