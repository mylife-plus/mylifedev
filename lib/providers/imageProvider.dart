


import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod()
Future<Uint8List> getMarkerImage() async {
 final bytes =  await rootBundle.load('assets/book.png');
 return bytes.buffer.asUint8List();
}