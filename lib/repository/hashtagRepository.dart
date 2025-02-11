

import 'package:mapbox_maps_example/models/hashtag.dart';

import 'dbUtils.dart';

class HashtagRepository{
  HashtagRepository._privateConstructor();
 static final HashtagRepository instance =   HashtagRepository._privateConstructor();

  Future<int> insertHashtag(String unicode) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('Hashtag', {'unicode': unicode});
  }

  Future<List<Hashtag>> getHashtags() async {
    final db = await AppDatabase.instance.database;
    var hashtags = await db.query('Hashtag');
    print(hashtags);
    return hashtags.map((e)=>Hashtag.fromMap(e)).toList();
  }

  Future<int> updateHashtag(int id, String unicode) async {
    final db = await AppDatabase.instance.database;
    return await db.update(
      'Hashtag',
      {'unicode': unicode},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteHashtag(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete(
      'Hashtag',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
