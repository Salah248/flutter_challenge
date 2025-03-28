// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key, required this.currentFilters});

  final Map<Filter, bool> currentFilters;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

// this enum contains all the filters that can be applied to the meals
enum Filter { glutenFree, lactoseFree, vegan, vegeterian }

class _FilterScreenState extends State<FilterScreen> {
  bool _isGlutenFree = false;
  bool _isLactoseFree = false;
  bool _veganFilter = false;
  bool _vegeterianFilter = false;

  @override
  void initState() {
    super.initState();
    _isGlutenFree = widget.currentFilters[Filter.glutenFree]!;
    _isLactoseFree = widget.currentFilters[Filter.lactoseFree]!;
    _veganFilter = widget.currentFilters[Filter.vegan]!;
    _vegeterianFilter = widget.currentFilters[Filter.vegeterian]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filters')),
      // this will allow the user to go back to the previous screen and apply the filters
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop({
            Filter.glutenFree: _isGlutenFree,
            Filter.lactoseFree: _isLactoseFree,
            Filter.vegan: _veganFilter,
            Filter.vegeterian: _vegeterianFilter,
          });
          return false;
        },
        child: Column(
          children: [
            switchList(
              context,
              title: 'Gluten Free',
              subtitle: 'Only include gluten free meals.',
              _isGlutenFree,
              (value) => setState(() {
                _isGlutenFree = value;
              }),
            ),
            switchList(
              context,
              title: 'Lactose Free',
              subtitle: 'Only include Lactose free meals.',
              _isLactoseFree,
              (value) => setState(() {
                _isLactoseFree = value;
              }),
            ),
            switchList(
              context,
              title: 'Vegan',
              subtitle: 'Only include Vegan free meals.',
              _veganFilter,
              (value) => setState(() {
                _veganFilter = value;
              }),
            ),
            switchList(
              context,
              title: 'Vegeterian',
              subtitle: 'Only include Vegeterian free meals.',
              _vegeterianFilter,
              (value) => setState(() {
                _vegeterianFilter = value;
              }),
            ),
          ],
        ),
      ),
    );
  }

  SwitchListTile switchList(
    BuildContext context,
    bool filter,
    void Function(bool)? onChanged, {
    required String title,
    required String subtitle,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      activeColor: Theme.of(context).colorScheme.tertiary,
      contentPadding: const EdgeInsets.only(left: 34, right: 22),
      value: filter,
      onChanged: onChanged,
    );
  }
}
