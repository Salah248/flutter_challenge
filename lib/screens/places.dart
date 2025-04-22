import 'package:flutter/material.dart';
import 'package:flutter_challenge/Providers/user_places.dart';
import 'package:flutter_challenge/models/place.dart';
import 'package:flutter_challenge/screens/add_place.dart';
import 'package:flutter_challenge/widgets/places_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Places extends ConsumerWidget {
  const Places({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Place> userPlace = ref.watch(userPlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPlace()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PlacesList(places: userPlace),
    );
  }
}
