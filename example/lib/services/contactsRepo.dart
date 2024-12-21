import 'package:sqflite/sqflite.dart';
import '../models/contact.dart';
import 'dbUtils.dart';

class ContactRepository {
  ContactRepository._privateConstructor();
  static final ContactRepository instance = ContactRepository._privateConstructor();

  // Basic CRUD for Contacts
  Future<int> insertContact(Contact contact) async {
    final db = await AppDatabase.instance.database;
    return db.insert('Contacts', contact.toMap());
  }

  Future<List<Contact>> fetchAllContacts() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('Contacts');
    return maps.map((m) => Contact.fromMap(m)).toList();
  }

  Future<Contact?> fetchContactById(int id) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('Contacts', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Contact.fromMap(maps.first);
  }

  Future<int> updateContact(Contact contact) async {
    final db = await AppDatabase.instance.database;
    return db.update('Contacts', contact.toMap(), where: 'id = ?', whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    final db = await AppDatabase.instance.database;
    // Remove group relationships before deleting the contact
    await db.delete('ContactGroups', where: 'contact_id = ?', whereArgs: [id]);
    return db.delete('Contacts', where: 'id = ?', whereArgs: [id]);
  }

  // -----------------------------------------------------------
  // Methods to Handle Group Relationship (Many-to-Many)
  // -----------------------------------------------------------

  /// Link an existing group to a contact
  Future<void> addGroupToContact(int contactId, int groupId) async {
    final db = await AppDatabase.instance.database;
    await db.insert('ContactGroups', {
      'contact_id': contactId,
      'group_id': groupId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  /// Remove a group from a contact
  Future<void> removeGroupFromContact(int contactId, int groupId) async {
    final db = await AppDatabase.instance.database;
    await db.delete('ContactGroups',
        where: 'contact_id = ? AND group_id = ?', whereArgs: [contactId, groupId]);
  }

  /// Update all groups for a contact by removing old links and adding new ones
  Future<void> updateGroupsForContact(int contactId, List<int> groupIds) async {
    final db = await AppDatabase.instance.database;
    // Clear existing relationships
    await db.delete('ContactGroups', where: 'contact_id = ?', whereArgs: [contactId]);
    // Add new group links
    for (var id in groupIds) {
      await addGroupToContact(contactId, id);
    }
  }

  /// Fetch all contacts associated with a given group
  Future<List<Contact>> fetchContactsForGroup(int groupId) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.rawQuery('''
      SELECT Contacts.*
      FROM Contacts
      INNER JOIN ContactGroups 
      ON Contacts.id = ContactGroups.contact_id
      WHERE ContactGroups.group_id = ?
    ''', [groupId]);

    return maps.map((m) => Contact.fromMap(m)).toList();
  }
}