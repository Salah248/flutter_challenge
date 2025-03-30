// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_challenge/Providers/filter_provdier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterScreen extends ConsumerWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<Filters, bool> activeFilter = ref.watch(filterMeals);
    return Scaffold(
      appBar: AppBar(title: const Text('Filters')),
      // this will allow the user to go back to the previous screen and apply the filters
      body: Column(
        children: [
          switchList(
            context,
            title: 'Gluten Free',
            subtitle: 'Only include gluten free meals.',
            activeFilter[Filters.glutenFree]!,
            (value) {
              ref
                  .read(filterMeals.notifier)
                  .setFilter(Filters.glutenFree, value);
            },
          ),
          switchList(
            context,
            title: 'Lactose Free',
            subtitle: 'Only include Lactose free meals.',
            activeFilter[Filters.lactoseFree]!,
            (value) {
              ref
                  .read(filterMeals.notifier)
                  .setFilter(Filters.lactoseFree, value);
            },
          ),
          switchList(
            context,
            title: 'Vegan',
            subtitle: 'Only include Vegan free meals.',
            activeFilter[Filters.vegan]!,
            (value) {
              ref.read(filterMeals.notifier).setFilter(Filters.vegan, value);
            },
          ),
          switchList(
            context,
            title: 'Vegeterian',
            subtitle: 'Only include Vegeterian free meals.',
            activeFilter[Filters.vegeterian]!,
            (value) {
              ref
                  .read(filterMeals.notifier)
                  .setFilter(Filters.vegeterian, value);
            },
          ),
        ],
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
