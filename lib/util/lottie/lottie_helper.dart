import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Lottie animasyon dosya yollarını tanımlayan enum
enum LottieAnimations {
  addFavorite('assets/lottie/1.json'),       // Favorilere ekleme animasyonu
  removeFavorite('assets/lottie/2.json'),    // Favorilerden çıkarma animasyonu
  addToCart('assets/lottie/3.json'),         // Sepete ekleme animasyonu
  loading('assets/lottie/4.json'),            // Yükleniyor animasyonu
  success('assets/lottie/5.json'),            // Başarı animasyonu
  removeBasketItem('assets/lottie/6.json'),  // Sepetten ürün kaldırma animasyonu
  loading2('assets/lottie/7.json');           // Alternatif yükleniyor animasyonu

  final String path;
  const LottieAnimations(this.path);
}

/// Lottie animasyonlarını boyut kontrolü ile göstermek için yardımcı sınıf
class LottieHelper {
  /// Lottie animasyonunu bir dialog içinde gösterir
  static void showAnimation({
    required BuildContext context,
    required LottieAnimations animation,
    double? width,
    double? height,
    Duration? duration,
    double speed = 1.0,
    bool isFullScreen = false,
    VoidCallback? onComplete,
  }) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _LottieAnimationDialog(
          animation: animation,
          width: width,
          height: height,
          duration: duration,
          speed: speed,
          isFullScreen: isFullScreen,
          onComplete: onComplete,
        );
      },
    );
  }
}

class _LottieAnimationDialog extends StatefulWidget {
  final LottieAnimations animation;
  final double? width;
  final double? height;
  final Duration? duration;
  final double speed;
  final bool isFullScreen;
  final VoidCallback? onComplete;

  const _LottieAnimationDialog({
    Key? key,
    required this.animation,
    this.width,
    this.height,
    this.duration,
    this.speed = 1.0,
    this.isFullScreen = false,
    this.onComplete,
  }) : super(key: key);

  @override
  State<_LottieAnimationDialog> createState() => _LottieAnimationDialogState();
}

class _LottieAnimationDialogState extends State<_LottieAnimationDialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        widget.animation.path,
        controller: _controller,
        width: widget.width ??
            (widget.isFullScreen
                ? MediaQuery.of(context).size.width
                : 150),
        height: widget.height ??
            (widget.isFullScreen
                ? MediaQuery.of(context).size.height
                : 150),

        // Tüm text layer'larını boşaltarak animasyondaki yazıyı kaldırıyoruz
        delegates: LottieDelegates(
          text: (initialText) => '',
        ),

        onLoaded: (composition) {
          _controller.duration = Duration(
            milliseconds: (widget.duration?.inMilliseconds ??
                (composition.duration.inMilliseconds ~/ widget.speed))
                .toInt(),
          );
          _controller.forward();
          _controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Navigator.of(context).pop();
              widget.onComplete?.call();
            }
          });
        },
      ),
    );
  }
}
