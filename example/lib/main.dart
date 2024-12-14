import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/LoginPage.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'example.dart';
import 'point_annotations_example.dart';


final List<Example> _allPages = <Example>[


  PointAnnotationExample(),

];

class MapsDemo extends StatelessWidget {
  // FIXME: You need to pass in your access token via the command line argument
  // --dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE
  // It is also possible to pass it in while running the app via an IDE by
  // passing the same args there.
  //
  // Alternatively you can replace `String.fromEnvironment("ACCESS_TOKEN")`
  // in the following line with your access token directly.
  static const String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");

  void _pushPage(BuildContext context, Example page) async {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MapboxMaps examples')),
      body: ACCESS_TOKEN.isEmpty || ACCESS_TOKEN.contains("YOUR_TOKEN")
          ? buildAccessTokenWarning()
          : ListView.separated(
              itemCount: _allPages.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, int index) {
                final example = _allPages[index];
                return ListTile(
                  leading: example.leading,
                  title: Text(example.title),
                  subtitle: (example.subtitle?.isNotEmpty == true)
                      ? Text(
                          example.subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  onTap: () => _pushPage(context, _allPages[index]),
                );
              },
            ),
    );
  }

  Widget buildAccessTokenWarning() {
    return Container(
      color: Colors.red[900],
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Please pass in your access token with",
            "--dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE",
            "passed into flutter run or add it to args in vscode's launch.json",
          ]
              .map((text) => Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(MapsDemo.ACCESS_TOKEN);
  runApp(
      MaterialApp(
          home: LoginPage(),

          theme: ThemeData( // Optional: Global theme settings
            appBarTheme: AppBarTheme(
              elevation: 0,
            ),

          ),
        ),
     );
}
