import 'package:flutter/material.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favouriteMeals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealFavouriteStatus(Meal meal) {
    final isExisting = _favouriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favouriteMeals.remove(meal);
      });

      _showInfoMessage('Meals is no longer a favourite.');
    } else {
      setState(() {
        _favouriteMeals.add(meal);
      });

      _showInfoMessage('Meal added to favourites');
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == 'filters') {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const FiltersScreen()));
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
          MaterialPageRoute(builder: (context) => const FiltersScreen()));

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = _selectedPageIndex == 0
        ? CategoriesScreen(
            onToggleFavourite: _toggleMealFavouriteStatus,
            selectedFilters: _selectedFilters,
          )
        : MealsScreen(
            Category(
                id: 'fav',
                title: 'Favourites',
                color: Theme.of(context).colorScheme.primary),
            onToggleFavourite: _toggleMealFavouriteStatus,
            meals: _favouriteMeals,
          );
    var activePageTitle = _selectedPageIndex == 0 ? 'Categories' : 'Favourites';

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
        ],
      ),
    );
  }
}
