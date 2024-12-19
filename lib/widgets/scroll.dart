import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'Memory_content.dart';

class ScrollWidgeet extends StatefulWidget {
  const ScrollWidgeet({super.key});

  @override
  State<ScrollWidgeet> createState() => _ScrollWidgeetState();
}

class _ScrollWidgeetState extends State<ScrollWidgeet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.08,
      minChildSize: 0.08,
      maxChildSize: 1,

      builder: (context, scrollController) {
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
              controller: scrollController,
              physics: const BouncingScrollPhysics(),

              children: [
                Container(
                  height: 58,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                    ),
                  ),
                ),
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
      },
    );
  }
}
