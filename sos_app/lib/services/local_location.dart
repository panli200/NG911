import 'package:sqflite/sqflite.dart';
import 'package:sos_app/services/TwentyPoints.dart';
import 'package:path/path.dart';

class DatabaseClass{
  var database;

  Future<void> insertSensor(Sensor sensor) async {
    database = openDatabase(
      join(await getDatabasesPath(), 'sensor_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE sensors(id INTEGER PRIMARY KEY, latitude TEXT, longitude TEXT)',
        );
      },
      version: 1,
    );
    // Get a reference to the database.
    final db = await database;

    await db.insert(
      'sensors',
      sensor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Sensor>> sensors() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'sensor_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE sensors(id INTEGER PRIMARY KEY, latitude TEXT, longitude TEXT)',
        );
      },
      version: 1,
    );
    // Get a reference to the database.
    final db = await database;

    // Query the table for all sensor.
    final List<Map<String, dynamic>> maps = await db.query('sensors');

    // Convert the List<Map<String, dynamic> into a List<Sensor>.
    return List.generate(maps.length, (i) {
      return Sensor(
        id: maps[i]['id'],
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
      );
    });
  }

  Future<Sensor> sensorItem(index) async {
    database = openDatabase(
      join(await getDatabasesPath(), 'sensor_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE sensors(id INTEGER PRIMARY KEY, latitude TEXT, longitude TEXT)',
        );
      },
      version: 1,
    );
    // Get a reference to the database.
    final db = await database;

    // Query the table for all sensor.
    final List<Map<String, dynamic>> maps = await db.query('sensors');

    // Convert the List<Map<String, dynamic> into a List<Sensor>.

    return Sensor(
      id: index,
      latitude: maps[index]['latitude'],
      longitude: maps[index]['longitude'],
    );
  }


  Future<void> updateSensor(Sensor sensor) async {
    database = openDatabase(
      join(await getDatabasesPath(), 'sensor_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE sensors(id INTEGER PRIMARY KEY, latitude TEXT, longitude TEXT)',
        );
      },
      version: 1,
    );
    // Get a reference to the database.
    final db = await database;

    // Update the given sensor.
    await db.update(
      'sensors',
      sensor.toMap(),
      // Ensure that the sensor has a matching id.
      where: 'id = ?',
      // Pass the sensor's id as a whereArg to prevent SQL injection.
      whereArgs: [sensor.id],
    );
  }

  Future<void> deleteSensor(int id) async {
    database = openDatabase(
      join(await getDatabasesPath(), 'sensor_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE sensors(id INTEGER PRIMARY KEY, latitude TEXT, longitude TEXT)',
        );
      },
      version: 1,
    );
    // Get a reference to the database.
    final db = await database;

    // Remove the sensor from the database.
    await db.delete(
      'sensors',
      // Use a `where` clause to delete a specific sensor.
      where: 'id = ?',
      // Pass the sensor's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
