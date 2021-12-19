import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powerflix/app/databases/hive_adapter.dart';

class HiveDatabase {
  HiveDatabase._internal();
  static final _instance = HiveDatabase._internal();

  factory HiveDatabase() => HiveDatabase._instance;

  bool _initilized = false;

  Future<void> initilize() async {
    final directory = await getApplicationDocumentsDirectory();

    Hive.init(directory.path);
    loadTypeAdapters();

    _initilized = true;
  }

  Future<int> writeData<T>(String name, T data) async {
    if (!_initilized) await initilize();

    final box = await Hive.openBox<T>(name);
    var primaryKey = await box.add(data);

    await box.close();
    return primaryKey;
  }

  Future<List<T>> readData<T>(String name) async {
    if (!_initilized) await initilize();

    final box = await Hive.openBox<T>(name);
    List<T> data = box.values.toList();

    await box.close();
    return data;
  }
}
