import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';

class SpeedDialItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SpeedDialItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });
}

class ExpandableSpeedDialFab extends StatefulWidget {
  final List<SpeedDialItem> items;
  final IconData mainIcon;
  final IconData? closeIcon;
  final Color? backgroundColor; // Warna background tombol utama (+)
  final Color? foregroundColor; // Warna icon tombol utama (+)
  final Color? subItemBackgroundColor; // Warna background sub tombol opsi
  final Color? subItemForegroundColor; // Warna teks & icon sub tombol opsi
  final String? tooltip;
  final String heroTag;

  const ExpandableSpeedDialFab({
    super.key,
    required this.items,
    this.mainIcon = Icons.add_rounded,
    this.closeIcon = Icons.close_rounded,
    this.backgroundColor,
    this.foregroundColor,
    this.subItemBackgroundColor,
    this.subItemForegroundColor,
    this.tooltip,
    this.heroTag = 'expandable_speed_dial_fab',
  });

  @override
  State<ExpandableSpeedDialFab> createState() => _ExpandableSpeedDialFabState();
}

class _ExpandableSpeedDialFabState extends State<ExpandableSpeedDialFab>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _closeMenu() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
        _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainBgColor = widget.backgroundColor ?? AppColors.primary;
    final mainFgColor = widget.foregroundColor ?? Colors.white;
    final defaultSubBgColor =
        widget.subItemBackgroundColor ?? const Color.fromARGB(255, 133, 25, 25);
    final defaultSubFgColor = widget.subItemForegroundColor ?? Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // List Item Opsi
        ...widget.items.map((item) {
          final itemBgColor = item.backgroundColor ?? defaultSubBgColor;
          final itemFgColor = item.foregroundColor ?? defaultSubFgColor;

          return ScaleTransition(
            scale: _expandAnimation,
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: itemBgColor,
                elevation: 4,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    _closeMenu();
                    item.onTap();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item.icon, color: itemFgColor, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: itemFgColor,
                            fontSize: AppFontSizes.md,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),

        // Tombol Utama (FloatingActionButton)
        FloatingActionButton(
          heroTag: widget.heroTag,
          tooltip: widget.tooltip,
          onPressed: _toggleMenu,
          backgroundColor: mainBgColor,
          elevation: 6,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: Icon(
              _isExpanded
                  ? (widget.closeIcon ?? Icons.close_rounded)
                  : widget.mainIcon,
              key: ValueKey<bool>(_isExpanded),
              color: mainFgColor,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
