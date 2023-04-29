import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meal.dart';
import 'package:meals_app/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen(this.category,
      {super.key,
      required this.onToggleFavourite,
      this.meals,
      this.selectedFilters});

  final Category category;
  final void Function(Meal meal) onToggleFavourite;
  final List<Meal>? meals;
  final Map<Filter, bool>? selectedFilters;

  void _onSelectMeal(BuildContext context, Meal meal) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MealScreen(
                  meal,
                  onToggleFavourite: onToggleFavourite,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final List<Meal> filteredMeals = meals ??
        dummyMeals
            .where((meal) => meal.categories.contains(category.id))
            .where((meal) {
          if (selectedFilters![Filter.glutenFree]! && !meal.isGlutenFree) {
            return false;
          }

          if (selectedFilters![Filter.lactoseFree]! && !meal.isLactoseFree) {
            return false;
          }

          if (selectedFilters![Filter.vegetarian]! && !meal.isVegetarian) {
            return false;
          }

          if (selectedFilters![Filter.vegan]! && !meal.isVegan) {
            return false;
          }

          return true;
        }).toList();

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
