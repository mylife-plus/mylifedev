
import 'dart:convert';

import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactModel {
  final String id;

  late Contact? details;

  Map<String,String> metadata;

  ContactModel._create(
  {
    required this.id,

    required this.metadata
})  {}

  static Future<ContactModel> create({required String id, Map<String,String> metadata = const {}}) async {
    print("create() (public factory)");

    // Call the private constructor
    var component = ContactModel._create(id: id, metadata: metadata);

   component.details  = await FlutterContacts.getContact(id, withAccounts: true,withGroups: true,withPhoto: true,withProperties: true,withThumbnail: true,deduplicateProperties: true,);

    return component;

  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      'metadata': jsonEncode(metadata),
    };
  }
  factory ContactModel.fromMap(Map<String, dynamic> map) {

    final metadataDecoded = Map<String, String>.from(jsonDecode(map['metadata'] ?? '{}'));

    return ContactModel._create(id: map['id'].toString(), metadata: metadataDecoded);

  }

}
