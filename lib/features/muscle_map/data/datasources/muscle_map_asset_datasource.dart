import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:powerflix/features/muscle_map/data/datasources/muscle_map_datasource.dart';
import 'package:powerflix/features/muscle_map/domain/models/muscle_path_data.dart';
import 'package:xml/xml.dart';

class MuscleMapAssetDatasource implements MuscleMapDatasource {
  static const _frontAsset = 'assets/image/svg/male_muscle_map_front.svg';
  static const _backAsset = 'assets/image/svg/male_muscle_map_back.svg';

  final AssetBundle _bundle;

  MuscleMapAssetDatasource({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  @override
  Future<List<MusclePathData>> fetchPaths({required bool isFront}) async {
    final raw = await _bundle.loadString(isFront ? _frontAsset : _backAsset);
    return _parse(raw);
  }

  List<MusclePathData> _parse(String svg) {
    final doc = XmlDocument.parse(svg);
    final result = <MusclePathData>[];

    for (final el in doc.findAllElements('path')) {
      final id = el.getAttribute('id');
      final d = el.getAttribute('d');
      if (id == null || !id.startsWith('muscle_') || d == null) continue;

      final path = parseSvgPathData(d);
      // SVG uses a flipped Y axis relative to Flutter's canvas; fillType
      // defaults to nonZero which matches SVG's fill-rule default.
      result.add(MusclePathData(id: id, path: path));
    }

    return result;
  }
}
