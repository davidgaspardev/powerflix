import 'package:flutter/material.dart';
import 'package:powerflix/shared/widgets/label.dart';
import 'package:powerflix/features/video/presentation/video_viewmodel.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  static const routeName = '/video';

  final VideoViewModel viewModel;

  const VideoWidget({super.key, required this.viewModel});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late final VideoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          body: Stack(
            children: [
              _buildVideo(context),
              _buildAppBar(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: VideoPlayer(_viewModel.player),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: statusBarHeight + 60,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black45, Colors.transparent],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Label(
                  'POWERFLIX',
                  color: Colors.white,
                  padding: const EdgeInsets.only(right: 56),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
