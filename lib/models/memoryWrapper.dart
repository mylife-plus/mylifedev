import 'memory.dart';

class MemoryWrapper {

  final Memory memory;
  final List<String> mediaPath;

  MemoryWrapper({required this.memory, required this.mediaPath});

  toMap(){
    return
        {
          'memory': memory.toMap(),
          'mediaPath' : mediaPath
        };
  }
}