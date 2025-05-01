import 'package:flutter/material.dart';
import 'package:flutter_challenge/Providers/user_places.dart';
import 'package:flutter_challenge/models/place.dart';
import 'package:flutter_challenge/screens/add_place.dart';
import 'package:flutter_challenge/widgets/places_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Places extends ConsumerStatefulWidget {
  const Places({super.key});

  @override
  ConsumerState<Places> createState() => _PlacesState();
}

class _PlacesState extends ConsumerState<Places> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return PlacesList(
                onDismissed:
                    (direction, place) => ref
                        .read(userPlacesProvider.notifier)
                        .removePlace(place),
                places: userPlace,
              );
            }
          },
        ),
      ),
    );
  }
}
