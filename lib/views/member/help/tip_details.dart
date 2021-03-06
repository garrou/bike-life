import 'package:bike_life/models/tip.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

Widget buildTipDetails(BuildContext context, Tip tip) => Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(vertical: thirdSize),
            child: Text(tip.title,
                textAlign: TextAlign.center, style: boldTextStyle)),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: thirdSize),
            child: Text(tip.content,
                textAlign: TextAlign.center, style: thirdTextStyle)),
        if (tip.videoUrl != null) VideoPlayer(video: tip.videoUrl!)
      ],
    );

class TipDetailsPage extends StatelessWidget {
  final Tip tip;
  const TipDetailsPage({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Conseils', style: secondTextStyle),
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > maxWidth) {
                return _narrowLayout(context);
              } else {
                return _wideLayout(context);
              }
            },
          ),
        ),
      );

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) => buildTipDetails(context, tip);
}

class VideoPlayer extends StatefulWidget {
  final String video;
  const VideoPlayer({Key? key, required this.video}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    if (TargetPlatform.windows != defaultTargetPlatform) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.video,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TargetPlatform.windows != defaultTargetPlatform
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: thirdSize),
            child: YoutubePlayerIFrame(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
          )
        : Container();
  }
}
