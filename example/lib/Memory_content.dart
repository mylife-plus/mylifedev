import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // For pagination dots
import 'Memory_header.dart';
import 'Memory_reactions.dart';

class MemoryContent extends StatelessWidget {
  final String date;
  final String country;
  final int reactions;
  final String? content;
  final List<String>? imageUrls;

  const MemoryContent({
    Key? key,
    required this.date,
    required this.country,
    required this.reactions,
    this.content,
    this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PageController to control the PageView
    final PageController pageController = PageController();

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          MemoryHeader(
            date: date,
            country: country,
            reactions: reactions,
          ),
          const SizedBox(height: 10),

          if (imageUrls != null && imageUrls!.isNotEmpty)
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5, // Half the screen height
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: imageUrls!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigate to fullscreen view
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FullScreenImageView(imageUrl: imageUrls![index]),
                            ),
                          );
                        },
                        child: Image.network(
                          imageUrls![index],
                          fit: BoxFit.cover, // Makes the image fill the width and height
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Center(child: Icon(Icons.error)),
                        ),
                      );
                    },
                  ),
                ),

                // Pagination Dots (SmoothPageIndicator)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: imageUrls!.length,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 4,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

          // Content Section
          if (content != null && content!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                content!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 20,
                  fontFamily: 'Kumbh Sans',
                  color: Colors.black,
                ),
                textScaleFactor: 1.0,
              ),
            ),

          // Spacer
          const SizedBox(height: 14),

          // Memory Reactions Section
          const MemoryReactions(),
        ],
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: InteractiveViewer( // Allows zooming and panning
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain, // Show the real size of the image
              errorBuilder: (context, error, stackTrace) =>
                  Center(child: Icon(Icons.error)),
            ),
          ),
        ),
      ),
    );
  }
}
