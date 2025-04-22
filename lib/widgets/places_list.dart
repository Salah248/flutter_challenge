import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/place.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    return places.isEmpty
        ? Center(
          child: Text(
            'No places yet',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        )
        : ListView.builder(
          itemCount: places.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                places[index].name,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          },
        );
  }
}
