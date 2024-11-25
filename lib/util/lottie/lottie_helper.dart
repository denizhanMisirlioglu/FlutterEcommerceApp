import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Lottie animasyon dosya yollarını tanımlayan enum
enum LottieAnimations {
  addFavorite('assets/lottie/1.json'), // Favorilere ekleme animasyonu
  removeFavorite('assets/lottie/2.json'), // Favorilerden çıkarma animasyonu
  addToCart('assets/lottie/3.json'), // Sepete ekleme animasyonu
  loading('assets/lottie/4.json'), // Yükleniyor animasyonu
  success('assets/lottie/5.json'), // Başarı animasyonu
  removeBasketItem('assets/lottie/6.json'), // Sepetten ürün kaldırma animasyonu
  loading2('assets/lottie/7.json'); // Alternatif yükleniyor animasyonu

  final String path; // Animasyon dosyasının yolu
  const LottieAnimations(this.path);
}

/// Lottie animasyonlarını boyut kontrolü ile göstermek için yardımcı sınıf
class LottieHelper {
  /// Lottie animasyonunu bir dialog içinde gösterir
  static void showAnimation({
    required BuildContext context,
    required LottieAnimations animation, // Gösterilecek animasyon (enum)
    double? width, // Animasyonun genişliği
    double? height, // Animasyonun yüksekliği
    Duration? duration, // Animasyon süresini özelleştirme
    double speed = 1.0, // Animasyon hızı
    bool isFullScreen = false, // Tam ekran modunda gösterme
    VoidCallback? onComplete, // Animasyon tamamlandığında çağrılacak fonksiyon
  }) {
    // Context geçerli değilse işlem yapma
    if (!context.mounted) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Dialog manuel olarak kapatılamaz
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

/// Hız ve boyut özelleştirmesi ile Lottie animasyonlarını gösteren stateful widget
class _LottieAnimationDialog extends StatefulWidget {
  final LottieAnimations animation; // Gösterilecek animasyon
  final double? width; // Animasyon genişliği
  final double? height; // Animasyon yüksekliği
  final Duration? duration; // Özelleştirilmiş animasyon süresi
  final double speed; // Animasyon hızı
  final bool isFullScreen; // Tam ekran modunda gösterme
  final VoidCallback? onComplete; // Animasyon tamamlandığında çağrılacak fonksiyon

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

/// Lottie animasyonlarının oynatılmasını yöneten state sınıfı
class _LottieAnimationDialogState extends State<_LottieAnimationDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller; // Animasyonu kontrol eden controller

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this); // Animasyon controller'ı başlatılır
  }

  @override
  void dispose() {
    _controller.dispose(); // Animasyon controller'ı serbest bırakılır
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        widget.animation.path, // Gösterilecek animasyonun yolu
        controller: _controller, // Animasyon controller'ı
        width: widget.width ?? (widget.isFullScreen ? MediaQuery.of(context).size.width : 150), // Dinamik genişlik
        height: widget.height ?? (widget.isFullScreen ? MediaQuery.of(context).size.height : 150), // Dinamik yükseklik
        onLoaded: (composition) {
          // Animasyon süresi hıza göre ayarlanır
          _controller.duration = Duration(
            milliseconds: (widget.duration?.inMilliseconds ?? composition.duration.inMilliseconds ~/ widget.speed).toInt(),
          );
          _controller.forward(); // Animasyon oynat
          _controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Navigator.of(context).pop(); // Animasyon tamamlandığında dialogu kapat
              if (widget.onComplete != null) widget.onComplete!(); // Tamamlama fonksiyonunu çağır
            }
          });
        },
      ),
    );
  }
}
