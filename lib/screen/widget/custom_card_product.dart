import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

customContainer({
  required String title,
  required String thumbnail,
  required String price,
  required String view,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          blurRadius: 5,
          offset: const Offset(0, 2),
          spreadRadius: 2,
          color: const Color(0xff929292).withOpacity(0.2),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: thumbnail,
          progressIndicatorBuilder: (context, url, progress) {
            return SizedBox(
              width: double.infinity,
              height: 300,
              child: Shimmer.fromColors(
                baseColor: const Color(0xff5D44AD).withOpacity(0.1),
                highlightColor: const Color(0xff5D44AD).withOpacity(0.2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            );
          },
          errorWidget: (context, url, error) {
            return Image.asset("assets/no-image.png");
          },
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'ROBOTO-REGULAR',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Price : ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'ROBOTO-REGULAR',
                        ),
                      ),
                      Text(
                        '\$$price',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontFamily: 'ROBOTO-MEDIUM',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "View : ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'ROBOTO-REGULAR',
                        ),
                      ),
                      Text(
                        view,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'ROBOTO-MEDIUM',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        )
      ],
    ),
  );
}
