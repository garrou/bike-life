import 'package:bike_life/models/tip.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as iframe;

class TipDetailsPage extends StatelessWidget {
  final Tip tip;
  const TipDetailsPage({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxWidth) {
          return _narrowLayout(context);
        } else {
          return _wideLayout(context);
        }
      }));

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: thirdSize),
        children: <Widget>[
          if (!isWeb)
            AppTopLeftButton(title: 'Conseils', callback: () => _back(context)),
          buildText(tip.title, boldTextStyle, TextAlign.center),
          buildText(tip.content, thirdTextStyle, TextAlign.center),
          if (tip.videoUrl != null) VideoPlayer(video: tip.videoUrl!)
        ],
      );

  Padding buildText(String text, TextStyle style, TextAlign textAlign) =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: thirdSize),
          child: Text(text, textAlign: textAlign, style: style));

  void _back(BuildContext context) => Navigator.pop(context);
}

class VideoPlayer extends StatefulWidget {
  final String video;
  const VideoPlayer({Key? key, required this.video}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;
  late iframe.YoutubePlayerController _webController;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _webController = iframe.YoutubePlayerController(
        initialVideoId: widget.video,
        params: const iframe.YoutubePlayerParams(
          autoPlay: false,
          showFullscreenButton: true,
        ),
      );
    } else {
      _controller = YoutubePlayerController(
        initialVideoId: widget.video,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _buildWebPlayer() : _buildMobilePlayer();
  }

  Widget _buildMobilePlayer() => Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressColors: const ProgressBarColors(
              playedColor: primaryColor,
              handleColor: primaryColor,
            ),
            progressIndicatorColor: primaryColor,
            onReady: () {
              _controller.addListener(() {});
            },
          ),
          builder: (context, player) => player,
        ),
      );

  Widget _buildWebPlayer() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: iframe.YoutubePlayerControllerProvider(
          controller: _webController,
          child: const iframe.YoutubePlayerIFrame(),
        ),
      );
}
