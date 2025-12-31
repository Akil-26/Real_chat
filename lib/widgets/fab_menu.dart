import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class FabMenu extends StatefulWidget {
  final List<FabMenuItem> items;
  final Widget? child;
  final double? bottom;
  final double? right;

  const FabMenu({
    super.key,
    required this.items,
    this.child,
    this.bottom,
    this.right,
  });

  @override
  State<FabMenu> createState() => _FabMenuState();
}

class _FabMenuState extends State<FabMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
    setState(() {
      _isOpen = true;
    });
  }

  void _closeMenu() {
    _controller.reverse().then((_) {
      _removeOverlay();
    });
    setState(() {
      _isOpen = false;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeMenu,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    color: Colors.black.withValues(alpha: 0.3 * _animation.value),
                  );
                },
              ),
            ),
          ),
          
          // Menu items
          Positioned(
            bottom: MediaQuery.of(context).size.height - position.dy - size.height + 8,
            right: MediaQuery.of(context).size.width - position.dx - size.width,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  alignment: Alignment.bottomRight,
                  child: Opacity(
                    opacity: _animation.value,
                    child: child,
                  ),
                );
              },
              child: _buildMenu(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.large,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.items.map((item) {
          return InkWell(
            onTap: () {
              _closeMenu();
              item.onTap?.call();
            },
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.icon != null) ...[
                    Icon(
                      item.icon,
                      color: AppColors.iconDefault,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Text(
                    item.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleMenu,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: AppShadows.medium,
        ),
        child: AnimatedRotation(
          turns: _isOpen ? 0.125 : 0,
          duration: const Duration(milliseconds: 250),
          child: widget.child ??
              const Icon(
                Icons.add,
                color: AppColors.textOnPrimary,
                size: 28,
              ),
        ),
      ),
    );
  }
}

class FabMenuItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const FabMenuItem({
    required this.label,
    this.icon,
    this.onTap,
  });
}
