import 'package:hive/hive.dart';
import 'package:powerflix/app/models/cardflix_data.dart';

void loadTypeAdapters() {
  _CardflixTypeAdapter.registerTypeAdatper();
}

class _CardflixTypeAdapter extends TypeAdapter<CardflixData> {
  static void registerTypeAdatper() {
    if (!Hive.isAdapterRegistered(0)) {
      final typeAdapter = _CardflixTypeAdapter();
      Hive.registerAdapter(typeAdapter);
    }
  }

  @override
  int get typeId => 0;

  @override
  CardflixData read(BinaryReader binaryReader) {
    return CardflixData.fromMap(
        Map<String, dynamic>.from(binaryReader.readMap()));
  }

  @override
  void write(BinaryWriter binaryWriter, CardflixData data) {
    binaryWriter.writeMap(data.toMap());
  }
}
