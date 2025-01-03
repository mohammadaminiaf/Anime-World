import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ScreenFullImagesView extends StatefulWidget {
  final List<String> imageUrls;

  const ScreenFullImagesView({
    super.key,
    required this.imageUrls,
  });

  static const routeName = '/full-images-view';

  @override
  State<ScreenFullImagesView> createState() => _ScreenFullImagesViewState();
}

class _ScreenFullImagesViewState extends State<ScreenFullImagesView> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.imageUrls.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return MediaPage(imageUrl: widget.imageUrls[index]);
          },
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: DotIndicator(
              currentIndex: _currentPage,
              itemCount: widget.imageUrls.length,
            ),
          ),
        ),
      ],
    );
  }
}

class MediaPage extends StatelessWidget {
  final String imageUrl;

  const MediaPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Center(
        child: ErrorPlaceholder(),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;

  const DotIndicator({
    Key? key,
    required this.currentIndex,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          itemCount,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: currentIndex == index ? 12 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: currentIndex == index ? Colors.white : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, size: 50, color: Colors.red),
        SizedBox(height: 8),
        Text(
          'Failed to load image',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      ],
    );
  }
}
