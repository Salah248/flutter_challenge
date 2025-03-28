// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_challenge/Providers/filter_provdier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  bool _isGlutenFree = false;
  bool _isLactoseFree = false;
  bool _veganFilter = false;
  bool _vegeterianFilter = false;

  @override
  void initState() {
    super.initState();
    final Map<Filters, bool> activeFilter = ref.read(filterMeals);
    _isGlutenFree = activeFilter[Filters.glutenFree]!;
    _isLactoseFree = activeFilter[Filters.lactoseFree]!;
    _veganFilter = activeFilter[Filters.vegan]!;
    _vegeterianFilter = activeFilter[Filters.vegeterian]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filters')),
      // this will allow the user to go back to the previous screen and apply the filters
      body: WillPopScope(
        onWillPop: () async {
          ref.read(filterMeals.notifier).setFilters({
            Filters.glutenFree: _isGlutenFree,
            Filters.lactoseFree: _isLactoseFree,
            Filters.vegan: _veganFilter,
            Filters.vegeterian: _vegeterianFilter,
          });

          return true;
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
