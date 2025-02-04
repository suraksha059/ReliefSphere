import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomImageViewer extends StatelessWidget {
  final List<String> images;
  const CustomImageViewer({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: double.infinity,
        autoPlay: false,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
      ),
      itemCount: images.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.network(
          images[itemIndex],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.error)),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
