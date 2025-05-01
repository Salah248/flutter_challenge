import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/place.dart';
import 'package:flutter_challenge/screens/places_details.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({
    super.key,
    required this.places,
    required this.onDismissed,
  });

  final List<Place> places;
  final void Function(DismissDirection, Place) onDismissed;

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
            final place = places[index];
            return Dismissible(
              key: ValueKey(place.id),
              background: Container(
                color: Theme.of(context).colorScheme.error,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white, size: 40),
              ),
              onDismissed: (direction) => onDismissed(direction, place),
              child: ListTile(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PlacesDetails(place: places[index]),
                      ),
                    ),
                title: Text(
                  places[index].name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                leading: CircleAvatar(
                  radius: 16,
                  backgroundImage: FileImage(places[index].image),
                ),
                subtitle: Text(
                  places[index].location.address,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            );
          },
        );
  }
}
