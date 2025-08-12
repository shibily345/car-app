import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CachedImageWithShimmer extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final bool isCircle;
  const CachedImageWithShimmer({
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 200,
    super.key,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        if (isCircle) {
          return CircleAvatar(backgroundImage: imageProvider, radius: height);
        } else {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          );
        }
      },
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isCircle ? BorderRadius.circular(100) : null,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
          width: 200,
          height: 120.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
          ),
          child: const Icon(
            Icons.error_outline_rounded,
            size: 30,
          )),
    );
  }
}
