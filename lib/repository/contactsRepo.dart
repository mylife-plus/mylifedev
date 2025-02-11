

import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mapbox_maps_example/repository/dbUtils.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contactModel.dart';

class ContactRepository {
  ContactRepository._privateConstructor();
  static final ContactRepository instance = ContactRepository._privateConstructor();
final AppDatabase  dbUtils = AppDatabase.instance;

  Future<List<Contact>> syncContactsFromDevice() async {

    final List<Contact> deviceContacts = await  FlutterContacts.getContacts(withAccounts: true,withGroups: true,withPhoto: true,withProperties: true,withThumbnail: true,deduplicateProperties: true,sorted: true);

    //Handle DB Sync

    for (var i in deviceContacts){
      if (await readContact(i.id) == null){
        await createContact(await ContactModel.create(id: i.id.toString()));
      }
      else {
        print("Contact already synced");
      }

    }
    return deviceContacts;
  }



  Future<ContactModel> createContact(ContactModel contact) async {
    final db = await instance.dbUtils.database;

    await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return contact;
  }

  /// Read/Query a single ContactModel by its id.
  Future<ContactModel?> readContact(String id) async {
    final db = await instance.dbUtils.database;

    final maps = await db.query(
      'contacts',
      columns: ['id', 'metadata'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ContactModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  /// Read/Query all contacts.
  Future<List<ContactModel>> readAllContacts() async {
    final db = await instance.dbUtils.database;

    final result = await db.query('contacts');

    return result.map((map) => ContactModel.fromMap(map)).toList();
  }

  /// Update an existing ContactModel record.
  Future<int> updateContact(ContactModel contact) async {
    final db = await instance.dbUtils.database;

    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  /// Delete a ContactModel record.
  Future<int> deleteContact(String id) async {
    final db = await instance.dbUtils.database;

    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


}