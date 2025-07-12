import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;
  const ImageSlider({super.key, required this.images});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (_pageController.hasClients) {
        int nextPage = _currentIndex + 1;
        if (nextPage >= widget.images.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentIndex = nextPage;
        });
        _startAutoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            return CNImageWidget(
              // height: 300.h,
              radius: 0,
              img: Ac.baseUrl + widget.images[index],
            );
          },
        ),
        Positioned(
          bottom: 30,
          left: 40,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black54,
            ),
            child: TextDef(
              '${_currentIndex + 1}/${widget.images.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class AdsImageSlider extends StatefulWidget {
  final List<String> images;
  const AdsImageSlider({super.key, required this.images});

  @override
  _AdsImageSliderState createState() => _AdsImageSliderState();
}

class _AdsImageSliderState extends State<AdsImageSlider> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (_pageController.hasClients) {
        int nextPage = _currentIndex + 1;
        if (nextPage >= widget.images.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentIndex = nextPage;
        });
        _startAutoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarsProvider>(builder: (context, cp, _) {
      List<String> imgs = cp.cars!.map((product) {
        return product.images!.isNotEmpty
            ? product.images![0]
            : ''; // Return the first image or an empty string if no images
      }).toList();
      return Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: imgs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: CNImageWidget(img: Ac.baseUrl + imgs[index]),
              );
            },
          ),
          Positioned(
            bottom: 30,
            left: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black54,
              ),
              child: TextDef(
                '${_currentIndex + 1}/${imgs.length}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class CNImageWidget extends StatelessWidget {
  final String img;
  final double? height;
  final double? radius;
  const CNImageWidget({
    super.key,
    required this.img,
    this.height,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: img,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 10),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
      ),
      placeholder: (context, url) => CustomContainer(
        height: height,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
