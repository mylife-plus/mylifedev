
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mapbox_maps_example/repository/contactsRepo.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/contactModel.dart';

class ContactService {

  ContactRepository repository = ContactRepository.instance;


  static Future<List<Contact>> getAllContacts() async {

    if (await Permission.contacts.isDenied){


        await Permission.contacts.request();
        return await FlutterContacts.getContacts(withAccounts: true,withGroups: true,withPhoto: true,withProperties: true,withThumbnail: true, deduplicateProperties: true);


  }

    else {

        var contacts =  await FlutterContacts.getContacts(withAccounts: true,withPhoto: true,withGroups: true,withProperties: true,withThumbnail: true, deduplicateProperties: true);



        print(await FlutterContacts.getGroups());

        return contacts;
    }
}


  Future<List<Contact>> syncContactsFromDevice() async {

    final List<Contact> deviceContacts = await  getAllContacts();

    //Handle DB Sync

    for (var i in deviceContacts){
      if (await repository.readContact(i.id) == null){
        await repository.createContact(await ContactModel.create(id: i.id.toString()));
      }
      else {
        print("Contact already synced");
      }

    }
    return deviceContacts;
  }

  Future<Contact> updateContact(Contact contact) async {

   return await FlutterContacts.updateContact(contact);
  }
  Future<void> deleteContact(Contact contact) async {

     await FlutterContacts.deleteContact(contact);
     await repository.deleteContact(contact.id);
     return null;
  }

  Future<Contact> insertContact(Contact contact) async {

   Contact insertedContact =  await FlutterContacts.insertContact(contact);

   repository.createContact(await ContactModel.create(id:insertedContact.id));
   return insertedContact;
  }

}