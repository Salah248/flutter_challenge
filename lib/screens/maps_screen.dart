import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialLocation;
  final bool isSelecting; // لو بنستخدمها لاختيار مكان

  const MapScreen({
    super.key,
    required this.initialLocation,
    this.isSelecting = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  // this method is used to select the location on the map and update the state of the widget
  // it takes the tap position and the latlng of the location selected by the user
  // tapPos is used to get the position of the tap on the map and latlng is used to get the location of the tap on the map
  void _selectLocation(TapPosition tapPos, LatLng latlng) {
    if (!widget.isSelecting) return;
    setState(() {
      _pickedLocation = latlng;
    });
  }

  @override
  Widget build(BuildContext context) {
    // this markerLoc is used to show the marker on the map
    // if the user is selecting a location, it will show the selected location, otherwise it will show the initial location

    final markerLoc = _pickedLocation ?? widget.initialLocation;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Select Location' : 'Your Location'),
        // in Actions we add the check icon to select the location if the user is selecting a location
        // if the user is selecting a location, it will show the selected location, otherwise it will show the initial location
        // in onPressed we pop the selected location to the previous screen
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed:
                  _pickedLocation == null
                      ? null
                      : () => Navigator.of(context).pop(markerLoc),
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: widget.initialLocation,
          initialZoom: 13.0,
          onTap: _selectLocation,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: markerLoc,
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
      ),
    );
  }
}
