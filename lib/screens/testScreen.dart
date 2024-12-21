
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/models/memory.dart';
import 'package:mapbox_maps_example/repository/contactsRepo.dart';
import 'package:mapbox_maps_example/repository/memoryRepo.dart';

import '../models/contact.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {


  Memory mockMemory = Memory(
    id: 1, // Assuming 1 is the first ID
    createdAt: DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(DateTime.now()),
    updatedAt: DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(DateTime.now()),
    xCoordinate: 37.7749, // Example: San Francisco latitude
    yCoordinate: -122.4194, // Example: San Francisco longitude
    address: 'San Francisco, CA, USA',
    text: 'Visited the iconic Golden Gate Bridge today. The weather was perfect!',
  );

  Contact mockContact = Contact(
    id: 1, // Assuming 1 is the first ID
    firstName: 'Jane',
    lastName: 'Doe',
    imageUri: 'https://example.com/images/jane_doe.jpg',
    phone: '+1 (555) 123-4567',
    email: 'jane.doe@example.com',
    website: 'https://janedoe.com',
    instagram: '@janedoe',
    birthdate: DateFormat('yyyy-MM-dd').format(DateTime(1990, 5, 15)), // May 15, 1990
    homeAddress: '123 Maple Street, Springfield, IL, USA',
    profession: 'Software Engineer',
    businessAddress: '456 Oak Avenue, Tech Park, Springfield, IL, USA',
    faith: 'Agnostic',
  );

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: PageView(
        children: [

          Container(
            child: ListView(
              children: [
                Text("Memory"),
                ElevatedButton(onPressed: () async {


                  int result = await MemoryRepository.instance.insertMemory(mockMemory);

                  print(result);


                }, child:Text("Add Memory")),
                ElevatedButton(onPressed: () async {


                }, child:Text("Get memory by id")),
                ElevatedButton(onPressed: () async {

                  Memory? mem = await MemoryRepository.instance.fetchMemoryById(1);

                  print(mem??"");
                  

                }, child:Text("Get All Memories")),
                ElevatedButton(onPressed: () async {
                  List<Memory> list = await MemoryRepository.instance.fetchAllMemories();

                  print(list[0].toMap());

                }, child:Text("Add contact")),
                ElevatedButton(onPressed: () async {
                int result = await ContactRepository.instance.insertContact(mockContact);

                }, child:Text("Get all contacts"))
              ],
            ),
          ),

        ],
      ),
    );
  }
}
