import '../models/group.dart';
import 'dbUtils.dart';

class GroupRepository {
  GroupRepository._privateConstructor();
  static final GroupRepository instance = GroupRepository._privateConstructor();

  Future<int> insertGroup(Group group) async {
    final db = await AppDatabase.instance.database;
    return db.insert('Groups', group.toMap());
  }

  Future<List<Group>> fetchAllGroups() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('Groups');
    return maps.map((m) => Group.fromMap(m)).toList();
  }

  Future<Group?> fetchGroupById(int id) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('Groups', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Group.fromMap(maps.first);
  }

  Future<int> updateGroup(Group group) async {
    final db = await AppDatabase.instance.database;
    return db.update('Groups', group.toMap(), where: 'id = ?', whereArgs: [group.id]);
  }

  Future<int> deleteGroup(int id) async {
    final db = await AppDatabase.instance.database;
    return db.delete('Groups', where: 'id = ?', whereArgs: [id]);
  }
}
