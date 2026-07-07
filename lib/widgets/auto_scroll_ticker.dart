import 'package:flutter/material.dart';

/// ============================================================
/// AUTO SCROLL TICKER — Infinite Seamless Loop Carousel
/// Widget reusable untuk menampilkan konten dalam carousel
/// otomatis dengan fitur:
///   • Seamless infinite loop (tanpa gap/jump)
///   • Configurable scroll speed
///   • Manual drag/swipe override (termasuk mouse drag di Web)
///   • Hold-to-Pause, Release-to-Resume
///   • Proper state cleanup on dispose
/// ============================================================
class AutoScrollTicker extends StatefulWidget {
  /// List of widget items to display in the ticker.
  final List<Widget> children;

  /// Auto-scroll speed in pixels per second. Default: 30.0
  final double scrollSpeed;

  /// Height of the ticker container.
  final double height;

  /// Padding between each item.
  final double itemSpacing;

  /// Whether to reverse the scroll direction (right-to-left = default).
  final bool reverse;

  const AutoScrollTicker({
    super.key,
    required this.children,
    this.scrollSpeed = 30.0,
    this.height = 160,
    this.itemSpacing = 12.0,
    this.reverse = false,
  });

  @override
  State<AutoScrollTicker> createState() => _AutoScrollTickerState();
}

class _AutoScrollTickerState extends State<AutoScrollTicker>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;

  bool _isPaused = false;
  bool _isUserScrolling = false;
  double _scrollOffset = 0.0;

  // We triple the items to create seamless loop illusion:
  // [items][items][items] — we keep the scroll in the middle set
  int get _itemCount => widget.children.length;
  int get _totalCount => _itemCount * 3;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Use AnimationController as a driver to tick every frame
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_tick);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        final maxExtent = _scrollController.position.maxScrollExtent;
        if (maxExtent > 0) {
          _scrollOffset = maxExtent / 3;
          _scrollController.jumpTo(_scrollOffset);
        }
        _animationController.repeat();
      }
    });
  }

  void _tick() {
    if (!mounted || _isPaused || _isUserScrolling) return;
    if (!_scrollController.hasClients) return;

    final maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent <= 0) return;

    final oneSetWidth = maxExtent / 3;

    // Initialize position to the middle set if not set yet
    if (_scrollOffset == 0.0) {
      _scrollOffset = oneSetWidth;
      _scrollController.jumpTo(_scrollOffset);
      return;
    }

    // speed * dt (we assume ~60fps, so dt = 1/60s)
    final delta = widget.scrollSpeed / 60.0;

    if (widget.reverse) {
      _scrollOffset -= delta;
    } else {
      _scrollOffset += delta;
    }

    // Wrap around smoothly to keep scroll offset within the middle set
    // which spans from [oneSetWidth] to [oneSetWidth * 2]
    if (_scrollOffset >= oneSetWidth * 2) {
      _scrollOffset -= oneSetWidth;
    } else if (_scrollOffset <= oneSetWidth) {
      _scrollOffset += oneSetWidth;
    }

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollOffset);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return SizedBox(height: widget.height);
    }

    return SizedBox(
      height: widget.height,
      child: Listener(
        // Hold-to-Pause
        onPointerDown: (_) {
          setState(() => _isPaused = true);
        },
        onPointerUp: (_) {
          setState(() => _isPaused = false);
        },
        onPointerCancel: (_) {
          setState(() => _isPaused = false);
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification &&
                notification.dragDetails != null) {
              _isUserScrolling = true;
            } else if (notification is ScrollEndNotification) {
              _isUserScrolling = false;
              // Sync our tracking offset with the user's manual scroll position
              if (_scrollController.hasClients) {
                _scrollOffset = _scrollController.offset;
              }
            }
            return false;
          },
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _totalCount,
            itemBuilder: (context, index) {
              final realIndex = index % _itemCount;
              return Padding(
                padding: EdgeInsets.only(right: widget.itemSpacing),
                child: widget.children[realIndex],
              );
            },
          ),
        ),
      ),
    );
  }
}
