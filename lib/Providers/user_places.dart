import 'dart:io';

import 'package:flutter_challenge/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sqflite;

Future<sqflite.Database> _getdatabase() async {
  // this databasePath is used to get the path of the database
  final databasePath = await sqflite.getDatabasesPath();
  // this db variable is used to open the database used sqflite.openDatabase

  final db = await sqflite.openDatabase(
    path.join(databasePath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
      );
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  // in this method we are going to add places to the database
  // and also to the state of the app which is a list of places
  // we use the sqflite package to interact with the database and we use the provider package to notify the state of the app
  // we use the path_provider package to get the path of the app directory
  void addPlace(String title, File image, PlaceLocation placeLocation) async {
    // this appDir variable is used to get the path of the app directory
    // we use the path_provider package to get the path of the app directory
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    // this imageName variable is used to get the name of the image file
    // we use the path package to get the name of the image file
    final imageName = path.basename(image.path);
    // this imageCopy variable is used to copy the image file to the app directory
    // we make copy to the image file to the app directory so that we can access it later
    final imageCopy = await image.copy('${appDir.path}/$imageName');
    // this newPlace variable is used to create a new Place object
    // then we add the new Place object to the state of the app
    final newPlace = Place(
      name: title,
      image: imageCopy,
      location: placeLocation,
    );

    final sqflite.Database db = await _getdatabase();

    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.name,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [newPlace, ...state];
  }

  Future<void> loadPlaces() async {
    final sqflite.Database db = await _getdatabase();
    final data = await db.query('user_places');
    final places =
        data
            .map(
              (row) => Place(
                id: row['id'] as String,
                name: row['title'] as String,
                image: File(row['image'] as String),
                location: PlaceLocation(
                  latitude: row['lat'] as double,
                  longitude: row['lng'] as double,
                  address: row['address'] as String,
                ),
              ),
            )
            .toList();
    state = places;
  }

  void removePlace(Place place) async {
    final sqflite.Database db = await _getdatabase();
    await db.delete('user_places', where: 'id = ?', whereArgs: [place.id]);
    state = state.where((p) => p != place).toList();
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );
