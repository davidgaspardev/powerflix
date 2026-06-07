import 'package:powerflix/features/video/data/datasources/video_datasource.dart';

class VideoNetworkDatasource implements VideoDatasource {
  @override
  Future<Uri> resolveUri(String url) async => Uri.parse(url);
}
