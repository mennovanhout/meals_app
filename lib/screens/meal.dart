import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';

class MealScreen extends StatelessWidget {
  const MealScreen(this.meal, {super.key, required this.onToggleFavourite});

  final Meal meal;
  final void Function (Meal meal) onToggleFavourite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [IconButton(onPressed: () {
          onToggleFavourite(meal);
        }, icon: Icon(Icons.star))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              meal.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 14,
            ),
            Text('Ingredients',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            for (final ingredient in meal.ingredients)
              Text(ingredient,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground)),
            const SizedBox(
              height: 14,
            ),
            Text('Steps',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 14,
            ),
            for (final step in meal.steps)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(step,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground)),
              ),
          ],
        ),
      ),
    );
  }
}
