import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

class ConfirmationButtons extends StatelessWidget {
  final AppinioSwiperController controller;

  const ConfirmationButtons({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => controller.swipeLeft(),
          child: Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => controller.swipeRight(),
          child: Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
