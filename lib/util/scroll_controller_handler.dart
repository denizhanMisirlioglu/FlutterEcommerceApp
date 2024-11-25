import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollControllerHandler {
  final ScrollController _controller = ScrollController();
  final ValueChanged<bool> onVisibilityChanged;

  ScrollControllerHandler({required this.onVisibilityChanged}) {
    _controller.addListener(_handleScroll);
  }

  ScrollController get controller => _controller;

  void _handleScroll() {
    if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      onVisibilityChanged(true);
    } else if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      onVisibilityChanged(false);
    }
  }

  void dispose() {
    _controller.dispose();
  }
}
