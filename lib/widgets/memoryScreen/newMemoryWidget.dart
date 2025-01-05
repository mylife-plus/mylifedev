


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mapbox_maps_example/providers/newMemoryWidgetProvider.dart';

import '../../utils.dart';

class NewMemoryWidget extends ConsumerStatefulWidget {
  const NewMemoryWidget({super.key});

  @override
  ConsumerState createState() => _NewMemoryWidgetState();
}

class _NewMemoryWidgetState extends ConsumerState<NewMemoryWidget> {

  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();
  final List<String> mockContacts = [
    "Alice Johnson",
    "Alice Smith",
    "Alice Brown",
    "Bob Smith",
    "Charlie Brown",
    "Diana Prince",
    "Eve Torres"
  ];
  @override
  Widget build(BuildContext context) {

    AsyncValue<Map<String,dynamic>> myData = ref.watch(newmemorywidgetproviderProvider);


    return myData.when(data: (data){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * 0.9,
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
                      child: InkWell(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: data["selectedDate"],
                            firstDate: DateTime(1900),
                            lastDate: DateTime(DateTime.now().year+1),
                          );

                          if (pickedDate !=null){
                            ref.read(newmemorywidgetproviderProvider.notifier).changeDate(pickedDate);
                          }

                        },
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
                                border:
                                Border.all(color: Colors.grey, width: 1)),
                            height: 48,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Icon(
                                    Icons.calendar_month,
                                  ),
                                ),
                                Text(
                                  formatDate(data["selectedDate"]),
                                  style: TextStyle(fontSize: 22),
                                ),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

                          if (pickedTime!=null){
                            ref.read(newmemorywidgetproviderProvider.notifier).changeTime(pickedTime);
                          }
                        },
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
                                border:
                                Border.all(color: Colors.grey, width: 1)),
                            height: 48,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Icon(
                                    Icons.access_time_outlined,
                                  ),
                                ),
                                Text(formatTime(data["selectedTime"]),
                                  style: TextStyle(fontSize: 22),
                                ),
                              ],
                            )),
                      ),
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
                        Text(formatPosition(data["selectedCoordinates"]),
                                  style: TextStyle(fontSize: 22),)
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
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 32,
                        color: Colors.green,
                      ),
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
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: TextField(
                    decoration: new InputDecoration.collapsed(
                        hintText: 'My memory...'),
                    maxLines: 50,
                    minLines: 5,
                    controller: textEditingController,
                    focusNode: focusNode,
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                padding: EdgeInsets.only(top: 12),
                height: 60,
                color: Colors.amber.withOpacity(0.1),
                width: double.infinity,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(Icons.person),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TypeAheadField<String>(
                          direction: VerticalDirection.up,
                          emptyBuilder: (BuildContext context) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.add,
                                    size: 24,
                                  )),
                            ],
                          ),
                          suggestionsCallback: (search) {
                            return mockContacts
                                .where((test) => test.contains(search))
                                .toList();
                          },
                          builder: (context, controller, focusNode) {
                            return Container(
                              color: Colors.white,
                              height: 48,
                              width: 240,
                              child: TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.amber)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.amber)),
                                    labelText: 'Contacts',
                                  )),
                            );
                          },
                          itemBuilder: (context, contact) {
                            return ListTile(
                              tileColor: Colors.white,
                              title: Text(contact),
                            );
                          },
                          onSelected: (contact) {},
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                height: 66,
                color: Colors.amber.withOpacity(0.1),
                width: double.infinity,
                child: Row(
                  children: [
                    ...mockContacts.map((e) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Chip(
                        label: Text(
                          e,
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.amber.withOpacity(0.5),
                        shadowColor: Colors.amber,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 12),
                height: 60,
                color: Colors.red.withOpacity(0.1),
                width: double.infinity,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        '#',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TypeAheadField<String>(
                          direction: VerticalDirection.up,
                          emptyBuilder: (BuildContext context) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.add,
                                    size: 24,
                                  )),
                            ],
                          ),
                          suggestionsCallback: (search) {
                            return mockContacts
                                .where((test) => test.contains(search))
                                .toList();
                          },
                          builder: (context, controller, focusNode) {
                            focusNode.unfocus();
                            return Container(
                              color: Colors.white,
                              height: 48,
                              width: 240,
                              child: TextField(
                                controller: controller,
                                focusNode: focusNode,
                                autofocus: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                  border: OutlineInputBorder(),
                                  labelText: 'Hashtags',
                                ),
                                style: TextStyle(fontSize: 24),
                              ),
                            );
                          },
                          itemBuilder: (context, contact) {
                            return ListTile(
                              tileColor: Colors.white,
                              title: Text(contact),
                            );
                          },
                          onSelected: (contact) {},
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                height: 66,
                color: Colors.red.withOpacity(0.1),
                width: double.infinity,
                child: Row(
                  children: [
                    ...data["selectedHashtags"].map((e) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Chip(
                        label: Text(
                          e,
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.red.withOpacity(0.5),
                        shadowColor: Colors.red,
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.close, color: Colors.red),
                          iconSize: 38,
                        ),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3,
                                spreadRadius: 1,
                                offset: Offset(1, 1))
                          ]),
                    ),
                    Container(
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.check, color: Colors.green),
                          iconSize: 38,
                        ),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3,
                                spreadRadius: 1,
                                offset: Offset(1, 1))
                          ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }, error: (error, stacktrace){return Text(error.toString());}, loading:()=> CircularProgressIndicator());




  }


}
