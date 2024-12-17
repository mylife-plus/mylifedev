import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Base width for scaling (change to match your design specs)
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
  DateTime _selectedDate = DateTime.now();
  final List<File> _selectedImages = [];
  final List<String> mockContacts = [
    "Alice Johnson",
    "Alice Smith",
    "Alice Brown",
    "Alice Brown",
    "Alice Brown",
    "Alice Brown",
    "Alice Brown",
    "Alice Brown",
    "Alice Brown",
    "Alice Brown",
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

  bool _isRecording = false;
  final List<String> _audioMessages = [];

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

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
      String newAudioName = 'audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
      _audioMessages.add(newAudioName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizes = ResponsiveSize(context);

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10 * sizes.scaleFactor),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateTimeField(sizes),
            _buildLocationField(sizes),
            _buildContactField(sizes),
            _buildTagField(sizes),
            _buildLibraryField(sizes),
            _buildTextField(sizes),
          ],
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
          // Title Row with SVG
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

                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: sizes.subtitleFontSize,
                ),
              ),
            ],
          ),
          SizedBox(height: 8 * sizes.scaleFactor),

          // TextField and the hold-to-record button
          Row(
            children: [
              // Expandable TextField
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
                onTapDown: (_) => _startRecording(),
                onTapUp: (_) => _stopRecording(),
                child: Container(
                  width: 50 * sizes.scaleFactor,
                  height: 50 * sizes.scaleFactor,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1 * sizes.scaleFactor),
                    borderRadius: BorderRadius.circular(8 * sizes.scaleFactor),
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
              ),
            ],
          ),

          SizedBox(height: 8 * sizes.scaleFactor),

          // Recording State Indicator
          if (_isRecording)
            Center(
              child: Text(
                'Recording...',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: sizes.subtitleFontSize,
                ),
              ),
            ),

          SizedBox(height: 8 * sizes.scaleFactor),

          // List of Recorded Audio Messages
          if (_audioMessages.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recorded Audios:',
                  style: TextStyle(
                    fontSize: sizes.subtitleFontSize,
                    fontWeight: FontWeight.w500,
                    color: kSubtitleColor,
                  ),
                ),
                SizedBox(height: 4 * sizes.scaleFactor),
                Column(
                  children: _audioMessages.map((audio) {
                    return Dismissible(
                      key: Key(audio),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20 * sizes.scaleFactor),
                        color: Colors.red,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: sizes.iconSizeMedium,
                        ),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          _audioMessages.remove(audio);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$audio deleted')),
                        );
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
                              child: Text(
                                audio,
                                style: TextStyle(
                                  fontSize: sizes.bodyFontSize,
                                  color: kSubtitleColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.play_arrow, color: Colors.green, size: sizes.iconSizeMedium),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Playing $audio')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Updated buildSection to accept SVGs for icons
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
          // Header Row
          Row(
            children: [
              leadingIcon,
              SizedBox(width: 8 * sizes.scaleFactor),
              Text(
                title,
                style: TextStyle(
                  color: kTitleColor,
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
                        label: Text(item, style: TextStyle(color: Colors.black, fontSize: sizes.bodyFontSize)),
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
