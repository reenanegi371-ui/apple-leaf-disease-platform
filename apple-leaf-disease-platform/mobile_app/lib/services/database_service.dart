import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/detection_result.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('leafhealth.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history(
        id TEXT PRIMARY KEY,
        disease_name TEXT,
        confidence REAL,
        image_path TEXT,
        timestamp TEXT,
        all_probabilities TEXT
      )
    ''');
  }

  Future<int> insertResult(DetectionResult result) async {
    Database db = await instance.database;
    return await db.insert(
      'history',
      {
        'id': result.id,
        'disease_name': result.diseaseName,
        'confidence': result.confidence,
        'image_path': result.imagePath,
        'timestamp': result.timestamp.toIso8601String(),
        'all_probabilities': _encodeProbabilities(result.allProbabilities),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DetectionResult>> getHistory() async {
    Database db = await instance.database;
    final results = await db.query(
      'history',
      orderBy: 'timestamp DESC',
    );

    return results.map((json) {
      return DetectionResult(
        id: json['id'] as String,
        diseaseName: json['disease_name'] as String,
        confidence: json['confidence'] as double,
        imagePath: json['image_path'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        allProbabilities: _decodeProbabilities(json['all_probabilities'] as String),
      );
    }).toList();
  }

  Future<int> deleteResult(String id) async {
    Database db = await instance.database;
    return await db.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearHistory() async {
    Database db = await instance.database;
    await db.delete('history');
  }

  String _encodeProbabilities(Map<String, double> probabilities) {
    return probabilities.entries
        .map((e) => '${e.key}:${e.value}')
        .join('|');
  }

  Map<String, double> _decodeProbabilities(String encoded) {
    if (encoded.isEmpty) return {};
    
    return encoded.split('|').fold({}, (map, entry) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        map[parts[0]] = double.parse(parts[1]);
      }
      return map;
    });
  }
}