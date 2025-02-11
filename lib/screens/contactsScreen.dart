import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mapbox_maps_example/models/contactModel.dart';
import 'package:mapbox_maps_example/repository/contactsRepo.dart';
import 'package:mapbox_maps_example/repository/services/contactsService.dart';
import 'package:mapbox_maps_example/widgets/contactTile.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> with AutomaticKeepAliveClientMixin {

  FocusNode focusNode=FocusNode();
  final ContactRepository contactsRepo =ContactRepository.instance;


  TextEditingController searchController = TextEditingController(text: "Search");

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
            Material(
              elevation: 1,
              child: Container(decoration:BoxDecoration(color:Colors.white,boxShadow: [BoxShadow(offset: Offset(1, -2),spreadRadius: 2,blurRadius: 3)]) ,padding:EdgeInsets.symmetric(horizontal: 12),height: 64, width: double.infinity, child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(

                      height: 64,
                      child: TextField(controller: searchController,focusNode: focusNode,onTapOutside:(T)=> focusNode.unfocus(),),

                    ),
                  ),
                  SizedBox(width: 36,),
                  IconButton(onPressed: () async {
                    print( await FlutterContacts.getContact("4"));
                  }, icon: Icon(Iconsax.filter , size: 38,)),
                  IconButton(onPressed: (){

                    showAdaptiveDialog(context: context, builder: (BuildContext context)=>Dialog(backgroundColor: Colors.white, child: Column(mainAxisSize: MainAxisSize.min,children: [
                      TextButton(onPressed: () async {
                      await contactsRepo.syncContactsFromDevice();
                      Navigator.of(context).pop();
                      }, child: Text("Sync From Device")),
                      TextButton(onPressed: () async {
                        Contact? contact = await  FlutterContacts.openExternalInsert();
                      }, child: Text("Add New Contact")),
                    ],),));

                  }, icon: Icon(Iconsax.add_square, size: 38,))
                ],
              ),),
            ),
              Expanded(
                child: ListView(

                  children: [
                    ...e.data!.map((e) {
                      print(e);

                      return InkWell(
                      onTap: () async {
                        Navigator.of(context).pushNamed('/singleContact', arguments: e);
                      }
                      ,child: ContactTile(contact: e));

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
      }, future: ContactService.getAllContacts(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
