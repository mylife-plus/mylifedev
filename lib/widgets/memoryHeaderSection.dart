import 'package:flutter/material.dart';

const double baseWidth = 375.0;

class ResponsiveSize {
  final BuildContext context;
  ResponsiveSize(this.context);

  double get scaleFactor => MediaQuery.of(context).size.width / baseWidth;

  double scale(double value) => value * scaleFactor;

  // Font Sizes
  double get titleFontSize => scale(22.0);

  // Icon Sizes
  double get iconSizeLarge => scale(28.0);
  double get iconSizeMedium => scale(30.0);

  // Common Sizes
  double get paddingHorizontal => scale(5.0);
  double get paddingVertical => scale(5.0);
}

const Color kTitleColor = Colors.black;

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: rs.paddingHorizontal,
        vertical: rs.scale(10.0), // Adjusted padding
      ),
      margin: EdgeInsets.zero,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF2C5), // Ensure consistent yellow background
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Icon
          Icon(Icons.close, size: rs.iconSizeMedium, color: Colors.black), // Changed to black
          const Spacer(),

          // Center Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/book.png',
                width: rs.iconSizeLarge,
                height: rs.iconSizeLarge,
                fit: BoxFit.fill,
              ),
              SizedBox(width: rs.scale(8.0)),
              Text(
                'New Memory',
                style: TextStyle(
                  fontSize: rs.titleFontSize,
                  fontFamily: 'Kumbh Sans',
                  color: kTitleColor,
                ),
              ),
            ],
          ),
          const Spacer(),

          // Right Icon
          Icon(Icons.check, size: rs.iconSizeMedium, color: Colors.green),
        ],
      ),
    );

  }
}
