import 'package:moveflix/features/video/data/datasources/video_datasource.dart';
import 'package:moveflix/features/video/domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoDatasource _datasource;

  VideoRepositoryImpl(this._datasource);

  @override
  Future<Uri> resolveUri(String url) => _datasource.resolveUri(url);
}
