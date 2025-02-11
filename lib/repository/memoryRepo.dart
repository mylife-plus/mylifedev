import 'package:flutter_contacts/contact.dart';
import 'package:mapbox_maps_example/models/memoryWrapper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/contactModel.dart';
import '../models/hashtag.dart';
import '../models/memory.dart';
import 'dbUtils.dart';
class MemoryRepository {
  MemoryRepository._privateConstructor();
  static final MemoryRepository instance = MemoryRepository._privateConstructor();

  // Basic CRUD for Memory
  Future<int> insertMemory(Memory memory) async {
    final db = await AppDatabase.instance.database;
    return db.insert('Memory', memory.toMap());
  }

  Future<List<Memory>> fetchAllMemories() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('Memory');
    return maps.map((m) => Memory.fromMap(m)).toList();
  }

  Future<Memory?> fetchMemoryById(int id) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('Memory', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Memory.fromMap(maps.first);
  }

  Future<int> updateMemory(Memory memory) async {
    final db = await AppDatabase.instance.database;
    return db.update('Memory', memory.toMap(), where: 'id = ?', whereArgs: [memory.id]);
  }

  Future<int> deleteMemory(int id) async {
    final db = await AppDatabase.instance.database;
    // Remove relationships before deleting the memory
    await db.delete('MemoryHashtags', where: 'memory_id = ?', whereArgs: [id]);
    await db.delete('MemoryContacts', where: 'memory_id = ?', whereArgs: [id]);
    await db.delete('MemoryMedia', where: 'memory_id = ?', whereArgs: [id]);
    return db.delete('Memory', where: 'id = ?', whereArgs: [id]);
  }

  // -----------------------------------------------------------
  // Methods to Handle Hashtag Relationship (Many-to-Many)
  // -----------------------------------------------------------

  /// Link an existing hashtag to a memory
  Future<void> addHashtagToMemory(int memoryId, int hashtagId) async {
    final db = await AppDatabase.instance.database;
    await db.insert('MemoryHashtags', {
      'memory_id': memoryId,
      'hashtag_id': hashtagId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Remove a hashtag from a memory
  Future<void> removeHashtagFromMemory(int memoryId, int hashtagId) async {
    final db = await AppDatabase.instance.database;
    await db.delete('MemoryHashtags',
        where: 'memory_id = ? AND hashtag_id = ?', whereArgs: [memoryId, hashtagId]);
  }

  /// Fetch all hashtags associated with a given memory
  Future<List<Hashtag>> fetchHashtagsForMemory(int memoryId) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.rawQuery('''
      SELECT Hashtag.id, Hashtag.unicode
      FROM Hashtag
      INNER JOIN MemoryHashtags 
      ON Hashtag.id = MemoryHashtags.hashtag_id
      WHERE MemoryHashtags.memory_id = ?
    ''', [memoryId]);

    return maps.map((m) => Hashtag.fromMap(m)).toList();
  }

  Future<void> addMediaToMemory(int memoryId, List<String> mediaPath) async {

    final db = await AppDatabase.instance.database;

    //Clear existing relationships


    for (var path in mediaPath){

      await db.insert('MemoryMedia', {'memory_id':memoryId, 'media_path': path});
    }

  }

  /// Update all hashtags for a memory by removing old links and adding new ones
  Future<void> updateHashtagsForMemory(int memoryId, List<int> hashtagIds) async {
    final db = await AppDatabase.instance.database;
    // Clear existing relationships
    await db.delete('MemoryHashtags', where: 'memory_id = ?', whereArgs: [memoryId]);
    // Add new ones
    for (var id in hashtagIds) {
      await addHashtagToMemory(memoryId, id);
    }
  }

  // -----------------------------------------------------------
  // Methods to Handle Contact Relationship (Many-to-Many)
  // -----------------------------------------------------------

  /// Link an existing contact to a memory
  Future<void> addContactToMemory(int memoryId, int contactId) async {
    final db = await AppDatabase.instance.database;
    await db.insert('MemoryContacts', {
      'memory_id': memoryId,
      'contact_id': contactId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Remove a contact from a memory
  Future<void> removeContactFromMemory(int memoryId, int contactId) async {
    final db = await AppDatabase.instance.database;
    await db.delete('MemoryContacts',
        where: 'memory_id = ? AND contact_id = ?', whereArgs: [memoryId, contactId]);
  }

  /// Fetch all contacts associated with a given memory
  Future<List<ContactModel>> fetchContactsForMemory(int memoryId) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.rawQuery('''
      SELECT Contacts.*
      FROM Contacts
      INNER JOIN MemoryContacts 
      ON Contacts.id = MemoryContacts.contact_id
      WHERE MemoryContacts.memory_id = ?
    ''', [memoryId]);

    return maps.map((m) => ContactModel.fromMap(m)).toList();
  }

  /// Update all contacts for a memory by removing old links and adding new ones
  Future<void> updateContactsForMemory(int memoryId, List<int> contactIds) async {
    final db = await AppDatabase.instance.database;
    // Clear existing relationships
    await db.delete('MemoryContacts', where: 'memory_id = ?', whereArgs: [memoryId]);
    // Add new ones
    for (var id in contactIds) {
      await addContactToMemory(memoryId, id);
    }
  }


  Future<List<MemoryWrapper>>  getAllMemoriesWithMedia() async {

    final db = await AppDatabase.instance.database;


    List<Memory> memories =   await  fetchAllMemories();


    List<MemoryWrapper> list =[];

    for (Memory m in memories) {
      var result = await db.query("MemoryMedia", where: 'memory_id = ?', whereArgs: [m.id]);
      list.add(MemoryWrapper(memory: m, mediaPath: result.map((e)=>e["media_path"] as String).toList()));
    }

    list.forEach((e)=>print(e.toMap()));
    return list;


  }





  Future<void> insertMemoryWithHashtagContactsMedia(Memory memory, List<Hashtag> hashtags, List<Contact> contactList,List<String> media) async {

    int id = await insertMemory(memory);
   await updateContactsForMemory(id, [...contactList.map((e)=>int.parse(e.id))]);

    print("Contacts updated Successfuly");

    await updateHashtagsForMemory(id, [...hashtags.map((e)=>e.id)]);

    print("Hashtags updated successfully");

    await addMediaToMemory(id, media);



  }
}
