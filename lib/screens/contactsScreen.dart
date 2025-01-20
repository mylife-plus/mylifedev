import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      builder: (context, e) {


        if (e.hasData){

        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
            Container(height: 80, width: double.infinity, child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 200,
                  height: 80,
                  child: TextField(),

                ),
                IconButton(onPressed: (){
                  Navigator.of(context).pushNamed("/newContact");
                }, icon: Icon(Icons.add, size: 38,))
              ],
            ),),
              Expanded(
                child: ListView(

                  children: [
                    ...e.data!.map((e) {

                      return Text(e.displayName);

                    })
                  ],
                ),
              ),
            ],
          ),
        );}
        else if (e.hasError){
          return Center(child: Text(e.error.toString()),);
        }
        return Center(child: CircularProgressIndicator(),);
      }, future: FlutterContacts.getContacts(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
