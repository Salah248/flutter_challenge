import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/place.dart';
import 'package:flutter_challenge/screens/maps_screen.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  // this _pickedLocation variable will be used to store the location selected by the user
  PlaceLocation? _pickedLocation;
  // this _isGettingLocation variable will be used to show a loading indicator while getting the location
  // this variable is set to true when the user clicks on the current location button and set to false when the location is fetched
  bool _isGettingLocation = false;

  // this address variable will be used to store the address of the selected location

  // this method is used to get the current location of the user
  // it uses the location package to get the current location of the user
  // it first checks if the location service is enabled and if not, it requests the user to enable it
  // then it checks if the user has granted permission to access the location and if not, it requests the user to grant permission
  // then it sets the _isGettingLocation variable to true and then calls the getLocation method of the location package to get the current location
  // finally, it sets the _isGettingLocation variable to false and sets the _pickedLocation variable to the current location
  Future<void> _getCurrentLocation() async {
    final loc = Location();

    bool serviceEnabled = await loc.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await loc.requestService();
      if (!serviceEnabled) return;
    }

    var permission = await loc.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await loc.requestPermission();
      if (permission != PermissionStatus.granted) return;
    }

    setState(() => _isGettingLocation = true);
    // this data variable will be used to store the current location of the user
    // it uses the getLocation method of the location package to get the current location of the user
    final data = await loc.getLocation();
    final lat = data.latitude;
    final long = data.longitude;

    setState(() => _isGettingLocation = false);

    if (lat == null || long == null) return;
    // this latlng variable will be used to store the current location of the user
    // it uses the LatLng class from the latlong2 package to create a new LatLng object with the latitude and longitude of the current location of the user
    final latlng = LatLng(lat, long);
    log('Location: $latlng');

    // ths setState method is used to update the state of the widget and rebuild the widget with the new location
    // it sets the _pickedLocation variable to the current location of the user
    final address = await getAddressFromLatLng(lat, long);
    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latlng.latitude,
        longitude: latlng.longitude,
        address: address,
      );
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  // this method is used to select a location on the map
  // it uses the Navigator class to push a new screen on the stack and then waits for the result of the screen
  // it uses the MapScreen class to create a new screen with the initial location set to the _pickedLocation variable or the default location of Cairo
  // it then sets the _pickedLocation variable to the selected location
  // it then sets the _isGettingLocation variable to false and sets the _pickedLocation variable to the selected location
  // it uses the setState method to update the state of the widget and rebuild the widget with the new location
  // it uses the LatLng class from the latlong2 package to create a new LatLng object with the latitude and longitude of the selected location
  // finally, it uses the Navigator class to pop the screen from the stack and return the selected location to the previous screen
  Future<void> _selectOnMap() async {
    // this selectedLatLng variable will be used to store the location selected by the user on the map
    // it uses the Navigator class to push a new screen on the stack and then waits for the result of the screen
    // it uses the MapScreen class to create a new screen with the initial location set to the _pickedLocation variable or the default location of Cairo
    // it then sets the _pickedLocation variable to the selected location
    final LatLng? selectedLatLng = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder:
            (ctx) => MapScreen(
              initialLocation:
                  _pickedLocation != null
                      ? LatLng(
                        _pickedLocation!.latitude,
                        _pickedLocation!.longitude,
                      )
                      : const LatLng(30.0444, 31.2357),
              isSelecting: true,
            ),
      ),
    );

    final address = await getAddressFromLatLng(
      selectedLatLng!.latitude,
      selectedLatLng.longitude,
    );

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: selectedLatLng.latitude,
        longitude: selectedLatLng.longitude,
        address: address,
      );
    });
    widget.onSelectLocation(_pickedLocation!);
  }

  // this method is used to get the address of the selected location
  // it uses the geocoding package to get the address of the selected location
  // it uses the LatLng class from the latlong2 package to create a new LatLng object with the latitude and longitude of the selected location
  // it then uses the getAddressFromLatLng method to get the address of the selected location
  // it then returns the address of the selected location
  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final geocoding.Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.country}';
      }
      return 'No address available';
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 'Error retrieving address';
    }
  }

  // this method is used to build the widget tree of the LocationInput widget
  // this LocationInput will be used to show the location input field in the form of a map and two buttons
  // it uses the FlutterMap class from the flutter_map package to create a new map with the initial location set to the _pickedLocation variable or the default location of Cairo
  // it then uses the TileLayer class from the flutter_map package to create a new tile layer with the url template set to the OpenStreetMap tile server
  // it then uses the MarkerLayer class from the flutter_map package to create a new marker layer with the marker set to the _pickedLocation variableor the default location of Cairo

  @override
  Widget build(BuildContext context) {
    // this previewContent variable will be used to store the content of the map preview
    Widget previewContent;

    if (_isGettingLocation) {
      previewContent = const Center(child: CircularProgressIndicator());
    } else if (_pickedLocation != null) {
      previewContent = FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
            _pickedLocation!.latitude,
            _pickedLocation!.longitude,
          ),
          initialZoom: 13,
        ),
        children: [
          // this TileLayer class will be used to create a new tile layer with the url template set to the OpenStreetMap tile server
          // it uses the urlTemplate property to set the url template of the tile layer
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          // this MarkerLayer class will be used to create a new marker layer with the marker set to the _pickedLocation variable or the default location of Cairo
          // it uses the markers property to set the markers of the marker layer
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  _pickedLocation!.latitude,
                  _pickedLocation!.longitude,
                ),
                width: 80,
                height: 80,
                child: Icon(
                  Icons.location_pin,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      previewContent = Text(
        'No Location Chosen',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withAlpha((0.2 * 255).round()),
            ),
          ),
          child: previewContent,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
            ),
          ],
        ),
      ],
    );
  }
}
