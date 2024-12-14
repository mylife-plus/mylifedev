import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/point_annotations_example.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/ec_key_generator.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/api.dart';
import 'main.dart'; // Import MapsDemo
import 'memoryFeedScreen.dart';
class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState(); // Make the state class public
}

class LoginPageState extends State<LoginPage> {
  String _generatedKey = '';
  bool _showKey = false;
  final _privateKeyController = TextEditingController();

  
  void _generatePrivateKey() {
    final keyParams = ECKeyGeneratorParameters(ECCurve_secp256k1());
    final secureRandom = FortunaRandom();

    final seed = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seed)));

    final generator = ECKeyGenerator()
      ..init(ParametersWithRandom(keyParams, secureRandom));
    final keyPair = generator.generateKeyPair();
    final privateKey = (keyPair.privateKey as ECPrivateKey).d;

    setState(() {
      _generatedKey = privateKey!.toRadixString(16);
      _privateKeyController.text = _showKey ? _generatedKey : '•' * 20;
      print("Generated Private Key: $_generatedKey");
    });
  }


  void _toggleShowKey() {
    setState(() {
      _showKey = !_showKey;
      _updateKeyVisibility();
    });
  }
 void _updateKeyVisibility() {
    _privateKeyController.text =
        _showKey ? _generatedKey : '•' * _generatedKey.length;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/globe_johane.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    controller: _privateKeyController,
                    obscureText: !_showKey,
                    decoration: InputDecoration(
                      labelText: 'Private Key',
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.vpn_key),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showKey ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: _toggleShowKey,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>MemoryFeedScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _generatePrivateKey,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            side: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          child: const Text(
                            'Generate Key',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
