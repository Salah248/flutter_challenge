import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/place.dart';

class PlacesDetails extends StatelessWidget {
  const PlacesDetails({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.name)),
      body: Center(
        child: Text(
          place.name,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
