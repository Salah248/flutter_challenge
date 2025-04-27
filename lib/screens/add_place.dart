import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_challenge/Providers/user_places.dart';
import 'package:flutter_challenge/models/place.dart';
import 'package:flutter_challenge/widgets/image_input.dart';
import 'package:flutter_challenge/widgets/location_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _placeLocation;
  _savePlace() {
    final name = _nameController.text;
    if (name.isEmpty || _selectedImage == null || _placeLocation == null) {
      return;
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(name, _selectedImage!, _placeLocation!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Place')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              textInputAction: TextInputAction.next,
              controller: _nameController,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            ImageInput(
              onImageSelected: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 16),
            LocationInput(
              onSelectLocation: (PlaceLocation location) {
                _placeLocation = location;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
