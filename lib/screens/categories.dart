import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(
      {super.key,
      required this.onToggleFavourite,
      required this.selectedFilters});

  final void Function(Meal meal) onToggleFavourite;
  final Map<Filter, bool> selectedFilters;

  void _selectCategory(BuildContext context, Category category) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MealsScreen(
                  category,
                  onToggleFavourite: onToggleFavourite,
                  selectedFilters: selectedFilters,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(category, () {
            _selectCategory(context, category);
          })
      ],
    );
  }
}
