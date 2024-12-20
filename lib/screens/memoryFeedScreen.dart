import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/point_annotations_example.dart';
import '../widgets/BottomIconBar.dart';
import '../widgets/Memory_item.dart';
import '../widgets/Memory_header.dart';
import '../widgets/Memory_content.dart';
import '../widgets/Memory_reactions.dart';
import '../widgets/SearchBarWidget.dart';

class MemoryFeedScreen extends StatefulWidget {
  const MemoryFeedScreen({Key? key}) : super(key: key);

  @override
  MemoryFeedScreenState createState() => MemoryFeedScreenState();
}

class MemoryFeedScreenState extends State<MemoryFeedScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),

        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                MemoryContent(
                  date: "24/12/2024, 15:30",
                  country: "Country Name",
                  reactions: 3,
                  content:
                  "Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit ametLorem ipsum dolor sit amet Lorem ipsum dolor sit amet",
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
                  content:
                  "Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit ametLorem ipsum dolor sit amet Lorem ipsum dolor sit amet",
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
                  content:
                  "i am the test dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit ametLorem ipsum dolor sit amet Lorem ipsum dolor sit amet",
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}
