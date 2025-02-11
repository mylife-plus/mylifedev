import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  AppDatabase._privateConstructor() {

    _dbFuture = _initDb();
  }


  static final AppDatabase instance = AppDatabase._privateConstructor();

  late final Future<Database> _dbFuture;

  Future<Database> get database => _dbFuture;

  Future<Database> _initDb() async {

    final dbPath = await getDatabasesPath();

    final path = join(dbPath, 'app.db');


    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        // Memory table
        await db.execute('''
          CREATE TABLE Memory (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            createdAt TEXT,
            updatedAt TEXT,
            xCoordinate REAL,
            yCoordinate REAL,
            address TEXT,
            text TEXT
          )
        ''');

        // Hashtag table
        await db.execute('''
          CREATE TABLE Hashtag (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            unicode TEXT
          )
        ''');



        // MemoryMedia table
        await db.execute('''
          CREATE TABLE MemoryMedia (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            memory_id INTEGER,
            media_path TEXT,
            FOREIGN KEY(memory_id) REFERENCES Memory(id)
          )
        ''');

        // Contacts table
        await db.execute('''
          CREATE TABLE Contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            metadata TEXT
          )
        ''');

        // Groups table
        await db.execute('''
          CREATE TABLE Groups (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');





        // Many-to-Many between Memory and Contacts
        await db.execute('''
          CREATE TABLE MemoryContacts (
            memory_id INTEGER,
            contact_id INTEGER,
            PRIMARY KEY(memory_id, contact_id),
            FOREIGN KEY(memory_id) REFERENCES Memory(id),
            FOREIGN KEY(contact_id) REFERENCES Contacts(id)
          )
        ''');

        // Many-to-Many between Contacts and Groups
        await db.execute('''
          CREATE TABLE ContactGroups (
            contact_id INTEGER,
            group_id INTEGER,
            PRIMARY KEY(contact_id, group_id),
            FOREIGN KEY(contact_id) REFERENCES Contacts(id),
            FOREIGN KEY(group_id) REFERENCES Groups(id)
          )
        ''');

        // Many-to-Many between Memory and Hashtag
        await db.execute('''
          CREATE TABLE MemoryHashtags (
            memory_id INTEGER,
            hashtag_id INTEGER,
            PRIMARY KEY(memory_id, hashtag_id),
            FOREIGN KEY(memory_id) REFERENCES Memory(id),
            FOREIGN KEY(hashtag_id) REFERENCES Hashtag(id)
          )
        ''');
      },
    );
  }
}
