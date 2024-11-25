import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed, // Sabit yapı
      showSelectedLabels: false, // Label'lar gizleniyor
      showUnselectedLabels: false, // Label'lar gizleniyor
      backgroundColor: const Color(0xFFF8F8F8),
      items: [
        _buildNavigationBarItem(
          icon: Icons.home,
          index: 0,
        ),
        _buildNavigationBarItem(
          icon: Icons.favorite_outline,
          index: 1,
        ),
        _buildNavigationBarItem(
          icon: Icons.shopping_cart_outlined,
          index: 2,
        ),
        _buildNavigationBarItem(
          icon: Icons.account_box_outlined,
          index: 3,
        ),
      ],
    );
  }

  /// Özel bir NavigationBarItem oluşturur
  BottomNavigationBarItem _buildNavigationBarItem({
    required IconData icon,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected)
                Container(
                  width: 40,
                  height: 3,
                  color: const Color(0xFFA0E4FF), // Pastel mavi çizgi
                ),
              const SizedBox(height: 4), // Çizgi ile ikon arası boşluk
              Icon(
                icon,
                size: isSelected ? 32 : 28, // Seçili ikon daha büyük
                color: isSelected ? const Color(0xFFA0E4FF) : const Color(0xFFB0BEC5), // Seçili ve seçilmemiş renkler
              ),
            ],
          ),
        ],
      ),
      label: '', // Label tamamen boş
    );
  }
}
