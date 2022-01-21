import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String image;
  final Color progressColor;
  const AppNetworkImage(
      {Key? key, required this.image, required this.progressColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.height / 3,
      imageUrl: image,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(
              value: downloadProgress.progress, color: progressColor),
      errorWidget: (context, url, error) => const Icon(
            Icons.error,
            color: Colors.red,
          ));
}
