


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_example/models/hashtag.dart';
import 'package:mapbox_maps_example/repository/hashtagRepository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtagsProvider.g.dart';
@riverpod
class HashtagNotifier extends _$HashtagNotifier{

  HashtagRepository repository = HashtagRepository.instance;
  @override
  FutureOr<List<Hashtag>> build() async {

    return repository.getHashtags();

  }
}