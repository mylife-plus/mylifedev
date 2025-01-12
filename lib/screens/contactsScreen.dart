import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Map<String, List<Contact>> mockContacts = Contact.contactsListToMap();
    return Container(
      child: ListView(

        children: [
          ...mockContacts.keys.map((e) {
            return ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                ...mockContacts[e]!.map((element)=>Text(element.homeAddress))
            ],
            );
          })
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
