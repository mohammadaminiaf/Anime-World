import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ScreenImageView extends StatelessWidget {
  const ScreenImageView({
    super.key,
    required this.url,
  });

  final String url;

  static const routeName = '/network-image-view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image View'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              progressIndicatorBuilder: (context, url, progress) {
                if (progress.totalSize != null) {
                  final percentage =
                      (progress.downloaded / progress.totalSize!) * 100;
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          value: progress.downloaded / progress.totalSize!,
                        ),
                        const SizedBox(height: 8),
                        Text('${percentage.toStringAsFixed(0)}%'),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
              errorWidget: (context, url, error) {
                return const Center(
                  child: Text('Error loading image'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
