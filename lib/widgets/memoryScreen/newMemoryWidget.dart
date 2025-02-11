import 'dart:io';
import 'dart:typed_data';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapbox_maps_example/models/hashtag.dart';
import 'package:mapbox_maps_example/providers/hashtagsProvider.dart';
import 'package:mapbox_maps_example/providers/locationProvider.dart';
import 'package:mapbox_maps_example/repository/hashtagRepository.dart';
import 'package:mapbox_maps_example/repository/memoryRepo.dart';
import 'package:mapbox_maps_example/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/memory.dart';

class NewMemoryWidget extends ConsumerStatefulWidget {
  final VoidCallback cancelCallback;
  final VoidCallback locationCallback;
  final List<double> location;
  const NewMemoryWidget(
      {super.key,
      required this.cancelCallback,
      required this.locationCallback,
      required this.location});
  @override
  ConsumerState<NewMemoryWidget> createState() => _NewMemoryWidgetState();
}

class _NewMemoryWidgetState extends ConsumerState<NewMemoryWidget> {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  TextEditingController contactsController = TextEditingController();
  Map<XFile, Uint8List> pickedMedia = {};
  final RecorderController recorderController = RecorderController();
  String? recordedFilePath;
  late List<Contact> mockContacts;
  late List<Hashtag> hashtags;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List listOfImages = [];
  bool isRecording = false;
  int? playedRecordingIndex;
  final List<String> listOfRecordings = [];
  PlayerController playerController = PlayerController();
  final List<Contact> selectedContacts = [];
  final List<Hashtag> selectedHashtags = [];
  final FocusNode hashtagsFocusNode = FocusNode();
  final MemoryRepository memoryRepository = MemoryRepository.instance;
  final HashtagRepository hashtagRepository = HashtagRepository.instance;

  @override
  void initState() {
    super.initState();
    recorderController.checkPermission();
    Future.microtask(() async {
      mockContacts = await FlutterContacts.getContacts();
    });
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var location = ref.read(locationGetterProvider).value;
    hashtags = ref.read(hashtagNotifierProvider).value!;

    print(hashtags);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4).copyWith(top: 8),
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height,
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
                    child: GestureDetector(
                      onTap: () async {
                        HashtagRepository repo = HashtagRepository.instance;
                        print(await repo.getHashtags());
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(DateTime.now().year + 1),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
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
                              border: Border.all(color: Colors.grey, width: 1)),
                          height: 48,
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                child: Icon(
                                  Icons.calendar_month,
                                ),
                              ),
                              Text(
                                formatDate(selectedDate),
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
                        TimeOfDay? pickedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                          });
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
                              border: Border.all(color: Colors.grey, width: 1)),
                          height: 48,
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                child: Icon(
                                  Icons.access_time_outlined,
                                ),
                              ),
                              Text(
                                formatTime(selectedTime),
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
                  child: InkWell(
                    onTap: widget.locationCallback,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Icon(
                            Icons.location_on_outlined,
                          ),
                        ),
                        Text(
                          '${location?[0].toStringAsFixed(6)},  ${location?[1].toStringAsFixed(6)}',
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  )),
            ),

            // So to be hoents I can't thiunk orf som"thning else in this world you little mitoherfuekr I can't think of something else in this world you little mth

            SizedBox(
              height: 4,
            ),
            Container(
              color: Colors.green.withOpacity(0.1),
              height: 92,
              width: double.infinity,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          height: 92,
                          width: 92,
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
                        ),
                        ...pickedMedia.keys.map(
                          (e) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            height: 92,
                            width: 92,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(1, 1),
                                      color: Colors.grey,
                                      blurRadius: 3,
                                      spreadRadius: 1)
                                ],
                                borderRadius: BorderRadius.circular(0),
                                color: Colors.black,
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Image.memory(pickedMedia[e]!),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          checkAndRequestPermissions();
                          await _pickMedia();
                        },
                        child: Container(
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
                        ),
                      )
                    ],
                  ),
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
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          height: 92,
                          width: 92,
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
                        ),
                        ...listOfRecordings.map((e) => GestureDetector(
                              onTap: () async {
                                await playerController.preparePlayer(
                                    path: e,
                                    shouldExtractWaveform: false,
                                    volume: 1);
                                playerController.startPlayer();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                height: 92,
                                width: 92,
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
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: Column(
                                  children: [
                                    Container(
                                      child: (playedRecordingIndex ==
                                                  listOfRecordings.indexOf(e) &&
                                              playerController.playerState ==
                                                  PlayerState.playing)
                                          ? Icon(
                                              Icons.pause,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.play_arrow,
                                              color: Colors.green,
                                            ),
                                    ),
                                    Text(playerController.maxDuration
                                        .toString()),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 92,
                        width: 92,
                        child: IconButton(
                          icon: Icon(Icons.mic,
                              size: 32,
                              color: isRecording ? Colors.red : Colors.blue),
                          onPressed: () async {
                            if (!recorderController.hasPermission) {
                              await recorderController.checkPermission();
                              await Permission.microphone.request();
                              await Permission.audio.request();
                            }
                            if (recorderController.hasPermission &&
                                !isRecording) {
                              recorderController.record();
                              setState(() {
                                isRecording = true;
                              });
                            } else if (recorderController.hasPermission &&
                                isRecording) {
                              String? path = await recorderController.stop();
                              print(path);
                              if (path != null) {
                                setState(() {
                                  listOfRecordings.add(path);
                                });
                              } else {
                                print("something went wrong!");
                              }

                              setState(() {
                                isRecording = false;
                              });
                            }
                          },
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
                      ),
                    ],
                  ),
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
                  onTapOutside: (e) {
                    focusNode.unfocus();
                  },
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
                    child: Container(
                      height: 48,
                      padding: EdgeInsets.only(right: 10),
                      child: TypeAheadField<Contact>(
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
                              .where(
                                  (test) => test.displayName.contains(search))
                              .toList();
                        },
                        builder: (context, controller, focusNode) {
                          return Container(
                            color: Colors.white,
                            height: 48,
                            width: 240,
                            child: TextField(
                                controller: contactsController,
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
                            title: Text(contact.displayName),
                          );
                        },
                        onSelected: (contact) {
                          if (!selectedContacts.contains(contact)) {
                            setState(() {
                              selectedContacts.add(contact);
                            });
                          }
                          FocusManager.instance.primaryFocus?.unfocus();
                          focusNode.unfocus();
                        },
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
                  ...selectedContacts.map((e) => Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedContacts.remove(e);
                              });
                            },
                            child: Chip(
                              label: Text(
                                e.displayName,
                                style: TextStyle(fontSize: 16),
                              ),
                              backgroundColor: Colors.amber.withOpacity(0.5),
                              shadowColor: Colors.amber,
                            )),
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
                      child: TypeAheadField<Hashtag>(
                        itemBuilder: (BuildContext context, Hashtag value) {
                          return ListTile(title: Text(value.unicode));
                        },
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
                        builder: (BuildContext context, controller, node) {
                          return Container(
                            color: Colors.white,
                            height: 48,
                            width: 300,
                            child: TextField(
                                controller: controller,
                                focusNode: node,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  border: OutlineInputBorder(),
                                  labelText: 'Hashtags',
                                ),
                                style: TextStyle(fontSize: 24)),
                          );
                        },
                        onSelected: (Hashtag value) {
                          if (!selectedHashtags.contains(value)){
                            setState(() {
                              selectedHashtags.add(value);
                            });
                          }

                        },
                        suggestionsCallback: (String search) {
                          return hashtags;
                        },
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...selectedHashtags.map((e) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: GestureDetector(
                            onTap: () {

                              setState(() {
                                selectedHashtags.remove(e);
                              });
                            },
                            child: Chip(
                              label: Text(
                                e.unicode,
                                style: TextStyle(fontSize: 16),
                              ),
                              backgroundColor: Colors.red.withOpacity(0.5),
                              shadowColor: Colors.red,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              height: 92,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                      child: IconButton(
                        onPressed: widget.cancelCallback,
                        icon: Icon(Icons.close, color: Colors.red),
                        iconSize: 46,
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
                  SizedBox(
                    width: 80,
                  ),
                  Container(
                    child: Center(
                      child: IconButton(
                        onPressed: () async {
                          final Directory appDocumentsDir =
                              await getApplicationDocumentsDirectory();

                          List<String> mediaPath = [];
                          pickedMedia.forEach((file, e) {
                            String dateNow = DateTime.now().toString();
                            file.saveTo(
                                appDocumentsDir.path + dateNow + file.name);
                            mediaPath.add(
                                appDocumentsDir.path + dateNow + file.name);
                          });
                          print(mediaPath.join(", "));

                          memoryRepository.insertMemoryWithHashtagContactsMedia(
                              Memory(
                                  id: 0,
                                  createdAt: DateTime.now().toString(),
                                  updatedAt: DateTime.now().toString(),
                                  xCoordinate: location![0],
                                  yCoordinate: location![1],
                                  address: '',
                                  text: textEditingController.text),
                              selectedHashtags,
                              selectedContacts,
                              mediaPath);
                        },
                        icon: Icon(Icons.check, color: Colors.green),
                        iconSize: 46,
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
  }

  Future<void> _pickMedia() async {
    final ImagePicker picker = ImagePicker();

    showDialog(
        context: context,
        builder: (BuildContext context) => Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                width: 200,
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Data Source"),
                    ElevatedButton(
                        onPressed: () async {
                          final XFile? file = await picker.pickImage(
                              source: ImageSource.camera);

                          if (file != null) {
                            final byteList = await file.readAsBytes();
                            setState(() {
                              pickedMedia.putIfAbsent(file, () => byteList);
                            });
                          }
                        },
                        child: Text("Camera")),
                    ElevatedButton(
                        onPressed: () async {
                          final List<XFile> files =
                              await picker.pickMultipleMedia();
                          if (files.isNotEmpty) {
                            files.forEach((e) async {
                              final bytes = await e.readAsBytes();

                              setState(() {
                                pickedMedia.putIfAbsent(e, () => bytes);
                              });
                            });
                          }
                        },
                        child: Text("Gallery"))
                  ],
                ),
              ),
            ));
  }
}
