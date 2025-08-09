import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdImageCarousel2 extends StatefulWidget {
  final VoidCallback onClose; // The callback function for closing

  const AdImageCarousel2({super.key, required this.onClose});

  @override
  _AdImageCarousel2State createState() => _AdImageCarousel2State();
}

class _AdImageCarousel2State extends State<AdImageCarousel2> {
  final PageController _pageController = PageController(viewportFraction: 1);
  final List<String> imageUrls = List.generate(
    10,
    (index) => 'https://picsum.photos/784/250?random=${index + 1}',
  );

  int currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_pageController.hasClients) {
        currentPage = (currentPage + 1) % imageUrls.length;
        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Stack(
        children: [
          SizedBox(
            height: 132.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          // Positioned(
          //   top: 2,
          //   right: 2,
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.close,
          //       color: Theme.of(context).colorScheme.onSurface,
          //     ),
          //     onPressed: widget.onClose,
          //   ),
          // ),
        ],
      ),
    );
  }
}
