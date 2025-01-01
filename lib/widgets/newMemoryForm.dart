import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../repository/dbUtils.dart';


const double baseWidth = 375.0;

class ResponsiveSize {
  final BuildContext context;
  ResponsiveSize(this.context);

  double get scaleFactor => MediaQuery.of(context).size.width / baseWidth;

  // Font Sizes
  double get titleFontSize => 18.0 * scaleFactor;
  double get subtitleFontSize => 18.0 * scaleFactor;
  double get bodyFontSize => 18.0 * scaleFactor;

  // Icon Sizes
  double get iconSizeLarge => 32.0 * scaleFactor;
  double get iconSizeMedium => 22.0 * scaleFactor;
  double get iconSizeSmall => 16.0 * scaleFactor;

  // Common Sizes (use these for paddings, margins, etc.)
  double get paddingSmall => 8.0 * scaleFactor;
  double get paddingMedium => 16.0 * scaleFactor;
  double get paddingLarge => 24.0 * scaleFactor;

  double get borderRadius => 8.0 * scaleFactor;

  // Box Shadow Scaling
  double get blurRadius => 5.0 * scaleFactor;
  double get spreadRadius => 2.0 * scaleFactor;

  // Other Sizes
  double scale(double value) => value * scaleFactor;
}
const Color kPrimaryIconColor = Color(0xFFCACACA);
const Color kTitleColor = Colors.black;
const Color kSubtitleColor = Colors.black87;
const Color kHintTextColor = Color(0xFFCACACA);
const Color kBorderColor = Color(0xFFF1F1F1);

class MemoryForm extends StatefulWidget {
  const MemoryForm({Key? key}) : super(key: key);

  @override
  MemoryFormState createState() => MemoryFormState();
}

class MemoryFormState extends State<MemoryForm> {

  late AppDatabase appDatabase;


  DateTime _selectedDate = DateTime.now();
  final List<File> _selectedImages = [];
  final List<String> mockContacts = [
    "Alice Johnson",
    "Alice Smith",
    "Alice Brown",
    "Bob Smith",
    "Charlie Brown",
    "Diana Prince",
    "Eve Torres"
  ];

  final List<String> mockHashtags = [
    "#Flutter",
    "#Dart",
    "#UI",
    "#Code",
    "#Development",
    "#OpenSource",
    "#Mobile",
    "#AppDevelopment"
  ];

  final List<String> selectedHashtags = [];
  final List<String> selectedContacts = [];
  final List<bool> _isEditing = [];

  bool _isRecording = false;
  final List<Map<String, dynamic>> _audioMessages = [];

  void addHashtag(String hashtag) {
    if (!selectedHashtags.contains(hashtag)) {
      setState(() {
        selectedHashtags.add(hashtag);
      });
    }
  }

  void removeHashtag(String hashtag) {
    setState(() {
      selectedHashtags.remove(hashtag);
    });
  }

  void addContact(String contact) {
    if (!selectedContacts.contains(contact)) {
      setState(() {
        selectedContacts.add(contact);
      });
    }
  }

  void removeContact(String contact) {
    setState(() {
      selectedContacts.remove(contact);
    });
  }
  String formatContact(String contact) {
    List<String> parts = contact.split(' ');
    if (parts.isNotEmpty) {
      return parts.length > 1
          ? '${parts.first} ${parts.last[0]}.'
          : parts.first;
    }
    return contact;
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _pickMedia() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _selectedImages.add(File(file.path));
      });
    }
  }

  void _removeImage(File file) {
    setState(() {
      _selectedImages.remove(file);
    });
  }




  bool _isRecorderInitialized = false;
  final ValueNotifier<int> _currentDuration = ValueNotifier<int>(0);
  Timer? _recordingTimer;

  Future<void> checkAndRequestPermissions() async {
    // Request notification permission
    if (await Permission.notification.request().isDenied) {
      print("Notification permission denied");
    }

    // Request media permissions
    if (await Permission.audio.request().isDenied) {
      print("Audio permission denied");
    }
    if (await Permission.mediaLibrary.request().isDenied) {
      print("Media library permission denied");
    }
  }


  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey<AnimatedListState>();
  final GlobalKey _addTextFieldKey = GlobalKey();

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _currentRecordingPath;

  @override
  void initState() {
    super.initState();
    checkAndRequestPermissions();
    _player.openPlayer();

    _initializeRecorder();
  }
  Future<void> _initializeRecorder() async {
    try {
      final status = await Permission.microphone.status;

      if (status.isGranted) {
        await _recorder.openRecorder();
        setState(() {
          _isRecorderInitialized = true;
        });
      } else {
        final result = await Permission.microphone.request();
        if (result.isGranted) {
          await _recorder.openRecorder();
          setState(() {
            _isRecorderInitialized = true;
          });
        } else {
          debugPrint("Microphone permission denied");
        }
      }
    } catch (e) {
      debugPrint("Error initializing recorder: $e");
    }
  }

  final ScrollController _scrollController = ScrollController();


  @override
  void dispose() {
    _currentDuration.dispose();
    _recordingTimer?.cancel();
    _playbackTimer?.cancel();
    _scrollController.dispose();


    if (_player.isPlaying) _player.stopPlayer();
    if (_recorder.isRecording) _recorder.stopRecorder();
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }
  int _recordingDuration = 0;

  Future<void> _startRealRecording() async {
    if (_isRecorderInitialized && !_isRecording) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/Recording_${DateTime.now().millisecondsSinceEpoch}.aac';

        await _recorder.startRecorder(toFile: filePath);

        setState(() {
          _isRecording = true;
          _currentRecordingPath = filePath;
          _currentDuration.value = 0;
        });

        // Start the duration timer
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _currentDuration.value++;
        });
      } catch (e) {
        debugPrint("Error starting recorder: $e");
      }
    }
  }
  Future<void> _stopRealRecording() async {
    if (_isRecording) {
      try {
        final path = await _recorder.stopRecorder();
        _recordingTimer?.cancel();

        if (path != null) {
          setState(() {
            _audioMessages.add({
              'path': path,
              'duration': _currentDuration.value,
              'name': 'Recording ${_audioMessages.length + 1}',
              'isEditing': false,
              'isPlaying': false,
              'currentPosition': 0,
            });
            _isRecording = false;
          });

          _animatedListKey.currentState?.insertItem(_audioMessages.length - 1);

          // Delay the scroll action to make sure the item has been added
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Future.delayed(Duration(milliseconds: 100), () {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
          });
        }
      } catch (e) {
        debugPrint("Error stopping recorder: $e");
      }
    }
  }

  Timer? _playbackTimer;

  Future<void> _playAudio(int index) async {
    try {
      for (var i = 0; i < _audioMessages.length; i++) {
        if (_audioMessages[i]['isPlaying'] && i != index) {
          await _player.stopPlayer();
          _playbackTimer?.cancel();
          setState(() {
            _audioMessages[i]['isPlaying'] = false;
            _audioMessages[i]['currentPosition'] = 0;
          });
        }
      }

      if (_audioMessages[index]['isPlaying']) {
        await _player.stopPlayer();
        _playbackTimer?.cancel();
        setState(() {
          _audioMessages[index]['isPlaying'] = false;
          _audioMessages[index]['currentPosition'] = 0;
        });
      } else {
        await _player.startPlayer(
          fromURI: _audioMessages[index]['path'],
          codec: Codec.aacADTS,
          whenFinished: () {
            print("Playback Finished for Recording ${_audioMessages[index]['name']}");

            _playbackTimer?.cancel();
            setState(() {
              _audioMessages[index]['isPlaying'] = false;
              _audioMessages[index]['currentPosition'] = 0;
            });
          },
        );

        print("Started Playing Recording ${_audioMessages[index]['name']}");

        setState(() {
          _audioMessages[index]['isPlaying'] = true;
        });

        _playbackTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          final currentPosition = _audioMessages[index]['currentPosition'];
          if (currentPosition < _audioMessages[index]['duration']) {
            setState(() {
              _audioMessages[index]['currentPosition']++;
            });
            print("Timer Update - Current Position: ${_audioMessages[index]['currentPosition']} seconds");
          } else {
            timer.cancel();
          }
        });
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizes = ResponsiveSize(context);

    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4 * sizes.scaleFactor,
          ),
        ],
      ),
      child: Column(

        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateTimeField(sizes),
                  _buildLocationField(sizes),
                  _buildContactField(sizes),
                  _buildTagField(sizes),
                  _buildLibraryField(sizes),
                  _buildTextField(sizes),
                ].map((child) {
                  // Reduce space between each section
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0 * sizes.scaleFactor),
                    child: child,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(ResponsiveSize sizes) {
    final double horizontalPadding = 16 * sizes.scaleFactor;
    final double verticalPadding = 8 * sizes.scaleFactor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1 * sizes.scaleFactor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/message-text.svg',
                width: sizes.iconSizeLarge,
                height: sizes.iconSizeLarge,
                color: kPrimaryIconColor,
              ),
              SizedBox(width: 6 * sizes.scaleFactor),

              Text(
                'Text & Audio',
                style: TextStyle(
                  color: kHintTextColor,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: sizes.subtitleFontSize,
                ),
              ),
            ],
          ),
          if (_audioMessages.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8 * sizes.scaleFactor),
              child: AnimatedList(
                key: _animatedListKey,
                controller: _scrollController,  // Attach the scroll controller here
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                initialItemCount: _audioMessages.length,
                itemBuilder: (context, index, animation) {
                  final audio = _audioMessages[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: 1.0,
                    child: _buildAudioListItem(audio, sizes, index),
                  );
                },
              ),
            ),
          SizedBox(height: 8 * sizes.scaleFactor),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1 * sizes.scaleFactor),
                    borderRadius: BorderRadius.circular(8 * sizes.scaleFactor),
                  ),
                  child: TextField(
                    maxLines: null,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Add Text',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10 * sizes.scaleFactor,
                        horizontal: 12 * sizes.scaleFactor,
                      ),
                      hintStyle: TextStyle(color: kHintTextColor, fontSize: sizes.bodyFontSize),
                    ),
                    style: TextStyle(fontSize: sizes.bodyFontSize),
                  ),
                ),
              ),
              SizedBox(width: 8 * sizes.scaleFactor),
              GestureDetector(
                key: _addTextFieldKey,
                onTapDown: (_) async {
                  _currentDuration.value = 0;
                  await _startRealRecording();
                },
                onTapUp: (_) async => await _stopRealRecording(),
                child: Column(
                  children: [
                    Container(
                      width: 50 * sizes.scaleFactor,
                      height: 50 * sizes.scaleFactor,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8 * sizes.scaleFactor),
                        boxShadow: [
                          if (_isRecording)
                            BoxShadow(
                              color: Colors.red.withOpacity(0.6),
                              blurRadius: 10 * sizes.scaleFactor,
                              spreadRadius: 2 * sizes.scaleFactor,
                            ),
                        ],
                        border: Border.all(color: Colors.grey.shade300, width: 1 * sizes.scaleFactor),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/microphone-2.svg',
                          width: sizes.iconSizeMedium,
                          height: sizes.iconSizeMedium,
                          color: _isRecording ? Colors.red : kPrimaryIconColor,
                        ),
                      ),
                    ),
                    if (_isRecording)
                      ValueListenableBuilder<int>(
                        valueListenable: _currentDuration,
                        builder: (context, duration, _) {
                          return Text(
                            _formatDuration(duration),
                            style: TextStyle(fontSize: sizes.bodyFontSize, color: Colors.red),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildAudioListItem(Map<String, dynamic> audio, ResponsiveSize sizes, int index) {
    final TextEditingController editController = TextEditingController(text: audio['name']);
    final bool isEditing = audio['isEditing'];
    final bool isPlaying = audio['isPlaying'];

    return Dismissible(
      key: Key(audio['path']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.only(right: 16 * sizes.scaleFactor),
          child: Icon(Icons.delete, color: Colors.white, size: sizes.iconSizeMedium),
        ),
      ),
      onDismissed: (direction) {
        final removedAudio = _audioMessages[index];
        final removedIndex = index;
        _audioMessages.removeAt(index);

        setState(() {
          _animatedListKey.currentState?.removeItem(
            removedIndex,
                (context, animation) => Container(),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${removedAudio['name']} deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _audioMessages.insert(removedIndex, removedAudio);
                  _animatedListKey.currentState?.insertItem(removedIndex);
                });
              },
            ),
          ),
        );
      },
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            _audioMessages[index]['isEditing'] = true;
          });
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 8 * sizes.scaleFactor),
          padding: EdgeInsets.all(12 * sizes.scaleFactor),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8 * sizes.scaleFactor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: isEditing
                    ? TextField(
                  controller: editController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter audio name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: sizes.bodyFontSize,
                    ),
                  ),
                  style: TextStyle(fontSize: sizes.bodyFontSize, color: Colors.black),
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      audio['name'],
                      style: TextStyle(fontSize: sizes.bodyFontSize, color: Colors.black),
                    ),
                    Text(
                      '${_formatDuration(audio['currentPosition'])} / ${_formatDuration(audio['duration'])}',
                      style: TextStyle(fontSize: sizes.bodyFontSize, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(

                icon: isEditing
                    ? Icon(Icons.check, color: Colors.green, size: sizes.iconSizeMedium)
                    : isPlaying
                    ? Icon(Icons.pause, color: Colors.green, size: sizes.iconSizeMedium)
                    : Icon(Icons.play_arrow, color: Colors.green, size: sizes.iconSizeMedium),

                onPressed: isEditing
                    ? () {
                  setState(() {
                    _audioMessages[index]['name'] = editController.text.trim().isEmpty
                        ? audio['name']
                        : editController.text.trim();
                    _audioMessages[index]['isEditing'] = false;
                  });
                }
                    : () => _playAudio(index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField(ResponsiveSize sizes) {
    return GestureDetector(
      onTap: _pickDateTime,
      child: _buildSection(
        sizes: sizes,
        iconSvg: 'assets/icons/calendar.svg',
        title: 'Date & Time',
        content:
        '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year} '
            '${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}',
        trailingSvg: 'assets/icons/edit-2.svg',
      ),
    );
  }

  Widget _buildLocationField(ResponsiveSize sizes) {
    return  _buildSection(
      sizes: sizes,
      iconSvg: 'assets/icons/location.svg',
      title: 'Location',
      content:'Germany 46.23, 34.214',
      trailingSvg: 'assets/icons/edit-2.svg',
    );
  }

  Widget _buildContactField(ResponsiveSize sizes) {
    return _buildInputFieldSearch(
      sizes: sizes,
      iconSvg: 'assets/icons/user.svg',
      title: "Add Contacts",
      mockItems: mockContacts,
      selectedItems: selectedContacts,
      onAddItem: addContact,
      onRemoveItem: removeContact,
      emptyMessage: "No Contact Found",
    );
  }

  Widget _buildTagField(ResponsiveSize sizes) {
    return _buildInputFieldSearch(
      sizes: sizes,
      icon: Icons.tag,
      title: "Search Hashtags",
      mockItems: mockHashtags,
      selectedItems: selectedHashtags,
      onAddItem: addHashtag,
      onRemoveItem: removeHashtag,
      emptyMessage: "No Hashtag Found",
    );
  }

  Widget _buildLibraryField(ResponsiveSize sizes) {
    return _buildInputField1(
      sizes: sizes,
      iconSvg: 'assets/icons/gallery.svg',
      title: 'Photos & Videos',
      mediaFiles: _selectedImages,
      onAddPressed: _pickMedia,
    );
  }


  Widget _buildSection({
    required ResponsiveSize sizes,
    required String iconSvg,
    required String title,
    required String content,
    String? trailingSvg,
  }) {
    final double horizontalPadding = 16 * sizes.scaleFactor;
    final double verticalPadding = 12 * sizes.scaleFactor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor, width: 1 * sizes.scaleFactor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconSvg,
                width: sizes.iconSizeLarge,
                height: sizes.iconSizeLarge,
                color: Colors.grey,
              ),
              SizedBox(width: 8 * sizes.scaleFactor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5 * sizes.scaleFactor),
                  Text(
                    content,
                    style: TextStyle(
                      color: kTitleColor,
                      fontSize: sizes.titleFontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (trailingSvg != null)
            Container(
              width: sizes.iconSizeLarge*1.5,
              height: sizes.iconSizeLarge *1.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6 * sizes.scaleFactor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2 * sizes.scaleFactor,
                    blurRadius: 2 * sizes.scaleFactor,
                    offset: Offset(0, 1 * sizes.scaleFactor),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  trailingSvg,
                  width: sizes.iconSizeLarge,
                  height: sizes.iconSizeMedium,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionWithIconData({
    required ResponsiveSize sizes,
    required IconData icon,
    required String title,
    required String content,
    IconData? trailing,
    String? trailingSvg,
  }) {
    final double horizontalPadding = 16 * sizes.scaleFactor;
    final double verticalPadding = 12 * sizes.scaleFactor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor, width: 1 * sizes.scaleFactor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: sizes.iconSizeLarge, color: Colors.grey),
              SizedBox(width: 8 * sizes.scaleFactor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5 * sizes.scaleFactor),
                  Text(
                    content,
                    style: TextStyle(
                      color: kTitleColor,
                      fontSize: sizes.titleFontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (trailingSvg != null)
            Container(
              width: sizes.iconSizeLarge,
              height: sizes.iconSizeLarge,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6 * sizes.scaleFactor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2 * sizes.scaleFactor,
                    blurRadius: 5 * sizes.scaleFactor,
                    offset: Offset(0, 3 * sizes.scaleFactor),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  trailingSvg,
                  width: sizes.iconSizeSmall,
                  height: sizes.iconSizeSmall,
                  color: Colors.grey,
                ),
              ),
            )
          else if (trailing != null)
            Container(
              width: sizes.iconSizeLarge,
              height: sizes.iconSizeLarge,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6 * sizes.scaleFactor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2 * sizes.scaleFactor,
                    blurRadius: 5 * sizes.scaleFactor,
                    offset: Offset(0, 3 * sizes.scaleFactor),
                  ),
                ],
              ),
              child: Center(
                child: Icon(trailing, size: sizes.iconSizeSmall, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField1({
    required ResponsiveSize sizes,
    String? iconSvg,
    IconData? icon,
    required String title,
    required List<File> mediaFiles,
    VoidCallback? onAddPressed,
  }) {
    final double paddingValue = 16 * sizes.scaleFactor;
    final double itemSize = 80.0 * sizes.scaleFactor;

    final Widget leadingIcon = iconSvg != null
        ? SvgPicture.asset(iconSvg, width: sizes.iconSizeLarge, height: sizes.iconSizeLarge, color: Colors.grey)
        : Icon(icon, size: sizes.iconSizeLarge, color: Colors.grey);

    return Container(
      padding: EdgeInsets.all(paddingValue),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor, width: 1 * sizes.scaleFactor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              leadingIcon,
              SizedBox(width: 8 * sizes.scaleFactor),
              Text(
                title,
                style: TextStyle(
                  color: kHintTextColor,
                  fontSize: sizes.subtitleFontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 8 * sizes.scaleFactor),

          Wrap(
            spacing: 4.0 * sizes.scaleFactor,
            runSpacing: 4.0 * sizes.scaleFactor,
            children: [
              ...mediaFiles.map((file) => _buildMediaItem(
                sizes: sizes,
                imageFile: file,
                onDelete: () => _removeImage(file),
                size: itemSize,
              )),
              GestureDetector(
                onTap: onAddPressed,
                child: Container(
                  width: itemSize,
                  height: itemSize,
                  color: Colors.black,
                  child: Icon(Icons.add, color: Colors.white, size: sizes.iconSizeMedium),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaItem({
    required ResponsiveSize sizes,
    required File imageFile,
    required VoidCallback onDelete,
    required double size,
  }) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4 * sizes.scaleFactor),
          child: Image.file(
            imageFile,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4 * sizes.scaleFactor,
          right: 4 * sizes.scaleFactor,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(4 * sizes.scaleFactor),
              child: Icon(Icons.close, color: Colors.white, size: sizes.iconSizeSmall),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputFieldSearch({
    required ResponsiveSize sizes,
    String? iconSvg,
    IconData? icon,
    required String title,
    required List<String> mockItems,
    required List<String> selectedItems,
    required Function(String) onAddItem,
    required Function(String) onRemoveItem,
    required String emptyMessage,
  }) {
    final TextEditingController searchController = TextEditingController();
    final FocusNode searchFocusNode = FocusNode();
    final LayerLink layerLink = LayerLink();
    OverlayEntry? overlayEntry;
    List<String> filteredItems = List.from(mockItems);

    void hideOverlay() {
      overlayEntry?.remove();
      overlayEntry = null;
    }

    void showOverlay(BuildContext context) {
      hideOverlay();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;

        overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            left: position.dx - 48,
            top: position.dy + size.height + 15 * sizes.scaleFactor,
            width: (size.width + 60) * sizes.scaleFactor,
            child: Material(
              elevation: 4 * sizes.scaleFactor,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8 * sizes.scaleFactor),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8 * sizes.scaleFactor),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1 * sizes.scaleFactor,
                  ),
                ),
                constraints: BoxConstraints(maxHeight: 200 * sizes.scaleFactor),
                child: filteredItems.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ListTile(
                      title: Text(
                        item,
                        style: TextStyle(color: Colors.black, fontSize: sizes.bodyFontSize),
                      ),
                      onTap: () {
                        onAddItem(item);
                        searchController.clear();
                        hideOverlay();
                      },
                    );
                  },
                )
                    : SizedBox(
                  height: 50 * sizes.scaleFactor,
                  child: Center(
                    child: Text(
                      emptyMessage,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: sizes.bodyFontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        Overlay.of(context).insert(overlayEntry!);
      });
    }

    void filterItems(String query) {
      if (query.trim().isEmpty) {
        hideOverlay();
        return;
      }
      filteredItems = mockItems
          .where((item) =>
      item.toLowerCase().contains(query.toLowerCase()) &&
          !selectedItems.contains(item))
          .toList();

      if (searchFocusNode.hasFocus) {
        showOverlay(searchFocusNode.context!);
      }
    }

    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus) hideOverlay();
    });

    final double horizontalPadding = 16 * sizes.scaleFactor;
    final double verticalPadding = 8 * sizes.scaleFactor;

    final Widget leadingIcon = iconSvg != null
        ? SvgPicture.asset(iconSvg, width: sizes.iconSizeLarge, height: sizes.iconSizeLarge, color: Colors.grey)
        : Icon(icon, size: sizes.iconSizeLarge, color: Colors.grey);

    return CompositedTransformTarget(
      link: layerLink,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: kBorderColor, width: 1 * sizes.scaleFactor)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 32 * sizes.scaleFactor, height: sizes.iconSizeLarge, child: leadingIcon),
                SizedBox(width: 8 * sizes.scaleFactor),
                Expanded(
                  child: Wrap(
                    spacing: 8 * sizes.scaleFactor,
                    runSpacing: 8 * sizes.scaleFactor,
                    children: selectedItems.map((item) {
                      return Chip(
                        backgroundColor: Colors.white,
                        label: Text(formatContact(item), style: TextStyle(color: Colors.black, fontSize: sizes.bodyFontSize)),
                        deleteIcon: Icon(Icons.close, color: Colors.red, size: sizes.iconSizeSmall),
                        onDeleted: () {
                          onRemoveItem(item);
                          filterItems(searchController.text);
                        },
                      );
                    }).toList(),

                  ),
                ),
              ],
            ),
            SizedBox(height: 8 * sizes.scaleFactor),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48 * sizes.scaleFactor,
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      onChanged: filterItems,
                      onTap: () => filterItems(searchController.text),
                      decoration: InputDecoration(
                        hintText: title,
                        prefixIcon: Icon(Icons.search, color: Colors.grey, size: sizes.iconSizeMedium),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8 * sizes.scaleFactor),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10 * sizes.scaleFactor,
                          horizontal: 12 * sizes.scaleFactor,
                        ),
                        hintStyle: TextStyle(fontSize: sizes.bodyFontSize, color: kHintTextColor),
                      ),
                      style: TextStyle(fontSize: sizes.bodyFontSize),
                    ),
                  ),
                ),
                SizedBox(width: 8 * sizes.scaleFactor),
                Container(
                  width: sizes.iconSizeLarge *1.6,
                  height: sizes.iconSizeLarge*1.4 ,
                  padding: EdgeInsets.all(8 * sizes.scaleFactor),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6 * sizes.scaleFactor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2 * sizes.scaleFactor,
                        blurRadius: 2 * sizes.scaleFactor,
                        offset: Offset(0, 1 * sizes.scaleFactor),
                      ),
                    ],
                  ),
                  child: Icon(Icons.add, color: Colors.black, size: sizes.iconSizeMedium),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}