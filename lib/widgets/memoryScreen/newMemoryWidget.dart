import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mapbox_maps_example/models/hashtag.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../models/contact.dart';
class NewMemoryWidget extends StatefulWidget {

  final VoidCallback cancelCallback;
  const NewMemoryWidget({super.key, required this.cancelCallback});
  @override
  State<NewMemoryWidget> createState() => _NewMemoryWidgetState();
}
class _NewMemoryWidgetState extends State<NewMemoryWidget> {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final List<String> mockContacts = [
    "Alice Johnson",
    "Alice Smith",
    "Alice Brown",
    "Bob Smith",
    "Charlie Brown",
    "Diana Prince",
    "Eve Torres"
  ];
  final List<String> selectedHashtags = ["Alice Johnson",
    "Alice Smith"];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4).copyWith(top: 8),
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height ,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1, 1),
                                  color: Colors.grey,
                                  blurRadius: 3,
                                  spreadRadius: 1)
                            ],
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1)),
                        height: 48,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12, right: 12),
                              child: Icon(
                                Icons.calendar_month,
                              ),
                            ),
                            Text(
                              '24/07/2024',
                              style: TextStyle(fontSize: 22),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Flexible(
                    child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1, 1),
                                  color: Colors.grey,
                                  blurRadius: 3,
                                  spreadRadius: 1)
                            ],
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1)),
                        height: 48,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12, right: 12),
                              child: Icon(
                                Icons.access_time_outlined,
                              ),
                            ),
                            Text(
                              '20:20',
                              style: TextStyle(fontSize: 22),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4,
            ),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(1, 1),
                            color: Colors.grey,
                            blurRadius: 3,
                            spreadRadius: 1)
                      ],
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 1)),
                  height: 48,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Icon(
                          Icons.location_on_outlined,
                        ),
                      ),
                      Text(
                        '20.025544,  35.636684',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              color: Colors.green.withOpacity(0.1),
              height: 92,
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    height: 92,
                    width: 92,
                    child: Icon(Icons.camera_alt_outlined, size: 32, color: Colors.green,),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(1, 1),
                              color: Colors.grey,
                              blurRadius: 3,
                              spreadRadius: 1)
                        ],
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              color: Colors.blue.withOpacity(0.1),
              height: 92,
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    height: 92,
                    width: 92,
                    child: Icon(Icons.mic, size: 32, color: Colors.blue),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(1, 1),
                              color: Colors.grey,
                              blurRadius: 3,
                              spreadRadius: 1)
                        ],
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 4,
            ),
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6,horizontal: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1)),
                child: TextField(
                  decoration:
                  new InputDecoration.collapsed(hintText: 'My memory...'),
                  maxLines: 50,
                  minLines: 5,
                  controller: textEditingController,
                  focusNode: focusNode,
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            SizedBox(height: 4,),
            Container(padding: EdgeInsets.only(top: 12),height:60, color: Colors.amber.withOpacity(0.1), width: double.infinity,child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(Icons.person),
                ),
                Expanded(
                  child: Container(height: 48, padding: EdgeInsets.only(right: 10),
                    child: TypeAheadField<String>(
                      direction: VerticalDirection.up,
                      emptyBuilder: (BuildContext context)=>Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: (){},icon:Icon(Icons.add, size: 24,)),
                        ],
                      ),
                      suggestionsCallback: (search)  {return mockContacts.where((test)=> test.contains(search)).toList();},
                      builder: (context, controller, focusNode) {
                        return Container(color:Colors.white,height: 48,width: 240,
                          child: TextField(
                              controller: controller,
                              focusNode: focusNode,
                              autofocus: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                                focusedBorder: OutlineInputBorder(borderSide:BorderSide(color: Colors.amber) ),
                                labelText: 'Contacts',
                              )
                          ),
                        );
                      },
                      itemBuilder: (context, contact) {
                        return ListTile(tileColor: Colors.white,
                          title: Text(contact),

                        );
                      },
                      onSelected: (contact) {

                      },
                    ),
                  ),
                )],
            ), ),

            Container(padding: EdgeInsets.only(top: 12, bottom: 12),height:66, color: Colors.amber.withOpacity(0.1),width: double.infinity,child: Row(
              children: [
                ...selectedHashtags.map((e)=>Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Chip(label: Text(e, style: TextStyle(fontSize: 16),),backgroundColor: Colors.amber.withOpacity(0.5),shadowColor: Colors.amber,),
                ))
              ],
            ),),
            Container(padding: EdgeInsets.only(top: 12),height:60, color: Colors.red.withOpacity(0.1), width: double.infinity,child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text('#',style: TextStyle(fontSize: 32),),
                ),
                Expanded(
                  child: SizedBox(height: 48,
                    child: TypeAheadField<String>(
                      direction: VerticalDirection.up,
                      emptyBuilder: (BuildContext context)=>Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: (){},icon:Icon(Icons.add, size: 24,)),
                        ],
                      ),
                      suggestionsCallback: (search)  {return mockContacts.where((test)=> test.contains(search)).toList();},
                      builder: (context, controller, focusNode) {
                        focusNode.unfocus();
                        return Container(color:Colors.white,height: 48,width: 240,
                          child: TextField(
                            controller: controller,
                            focusNode: focusNode,
                            autofocus: false,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              border: OutlineInputBorder(),
                              labelText: 'Hashtags',

                            ),style: TextStyle(fontSize: 24),
                          ),
                        );
                      },
                      itemBuilder: (context, contact) {
                        return ListTile( tileColor: Colors.white,
                          title: Text(contact),

                        );
                      },
                      onSelected: (contact) {

                      },
                    ),
                  ),
                )],
            ), ),

            Container(padding: EdgeInsets.only(top: 12,bottom: 12),height:66, color: Colors.red.withOpacity(0.1),width: double.infinity,child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                children: [
                  ...selectedHashtags.map((e)=>Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Chip(
                      label: Text(e,style: TextStyle(fontSize: 16),),backgroundColor: Colors.red.withOpacity(0.5),shadowColor: Colors.red, ),
                  ))
                ],
              ),
            ),),

            SizedBox(height: 8,),
            Container( margin: EdgeInsets.symmetric(horizontal: 12).copyWith(top: 20) , height: 92, child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(child: Center(child:IconButton(onPressed: widget.cancelCallback, icon: Icon(Icons.close, color: Colors.red), iconSize: 46,),
                ),decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 3,spreadRadius: 1,offset: Offset(1, 1))]),),
                SizedBox(width:80,),

                Container(child: Center(child:IconButton(onPressed: (){}, icon: Icon(Icons.check, color: Colors.green), iconSize: 46,),
                ),decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 3,spreadRadius: 1,offset: Offset(1, 1))]),),
              ],
            ),)


          ],
        ),
      ),
    );
  }
}