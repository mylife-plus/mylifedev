import 'package:flutter/material.dart';
import 'BottomIconBar.dart';
import 'Memory_item.dart';
import 'Memory_header.dart';
import 'Memory_content.dart';
import 'Memory_reactions.dart';
import 'SearchBarWidget.dart'; // Add import for SearchBarWidget
class MemoryFeedScreen extends StatefulWidget {
  const MemoryFeedScreen({Key? key}) : super(key: key);

  @override
  MemoryFeedScreenState createState() => MemoryFeedScreenState();
}

class MemoryFeedScreenState extends State<MemoryFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showBottomBar = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > _lastOffset && _showBottomBar) {
        setState(() {
          _showBottomBar = false;
        });
      } else if (_scrollController.offset < _lastOffset && !_showBottomBar) {
        setState(() {
          _showBottomBar = true;
        });
      }
      _lastOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            floating: true,
            snap: true,
            elevation: 2,
            flexibleSpace: const SearchBarWidget(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Column(
                  children: [
                    MemoryItem(),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          MemoryContent(
                            date: "24/12/2024, 15:30",
                            country: "Country Name",
                            reactions: 3,
                            content: "Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit ametLorem ipsum dolor sit amet Lorem ipsum dolor sit amet",
                          ),
                          const Divider(color: Colors.grey),
                          MemoryContent(
                            date: "24/12/2024, 15:30",
                            country: "Country Name",
                            reactions: 3,
                            content: "Lorem ipsum dolor sit amet...",
                            imageUrls: [
                              "https://cdn.builder.io/api/v1/image/assets/TEMP/7632e90dad2f4f0ca39a4830dbb1b01d72906e4c0ddc67d230681b967b7cc622?placeholderIfAbsent=true&apiKey=c43da3a161eb4f318c4f96480fdf0876",
                              "https://cdn.builder.io/api/v1/image/assets/TEMP/7632e90dad2f4f0ca39a4830dbb1b01d72906e4c0ddc67d230681b967b7cc622?placeholderIfAbsent=true&apiKey=c43da3a161eb4f318c4f96480fdf0876",
                            ],
                          ),
                          const Divider(color: Colors.grey),
                          MemoryContent(
                            date: "24/12/2024, 15:30",
                            country: "Country Name",
                            reactions: 3,
                            content: "Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit ametLorem ipsum dolor sit amet Lorem ipsum dolor sit amet",
                            imageUrls: [
                              "https://cdn.builder.io/api/v1/image/assets/TEMP/7632e90dad2f4f0ca39a4830dbb1b01d72906e4c0ddc67d230681b967b7cc622?placeholderIfAbsent=true&apiKey=c43da3a161eb4f318c4f96480fdf0876",
                              "https://cdn.builder.io/api/v1/image/assets/TEMP/7632e90dad2f4f0ca39a4830dbb1b01d72906e4c0ddc67d230681b967b7cc622?placeholderIfAbsent=true&apiKey=c43da3a161eb4f318c4f96480fdf0876",
                            ],
                          ),
                          const Divider(color: Colors.grey),
                          MemoryContent(
                            date: "24/12/2024, 15:30",
                            country: "Country Name",
                            reactions: 3,
                            content: "i am the test s dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit ametLorem ipsum dolor sit amet Lorem ipsum dolor sit amet",
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: _showBottomBar,
        child: const BottomIconBar(),
      ),
    );
  }
}
