import 'package:powerflix/features/muscle_map/domain/models/body_sex.dart';
import 'package:powerflix/features/muscle_map/domain/models/body_side.dart';
import 'package:xml/xml.dart';

class BodyMapAssetDatasource {
  static const Map<BodySide,Map<BodySex, String>> _bodyAssets = {
    BodySide.front: {
      BodySex.male: "assets/image/svg/male_muscle_map_front.svg",
      BodySex.female: "assets/image/svg/female_muscle_map_front.svg"
    },
    BodySide.back: {
      BodySex.male: "assets/image/svg/male_muscle_map_back.svg",
      BodySex.female: "assets/image/svg/female_muscle_map_back.svg"
    }
  };

  void _parse(String svg) {
    final doc = XmlDocument.parse(svg);

    for (final element in doc.findAllElements('path')) {
      element.getAttribute('id');
    }
  }
}