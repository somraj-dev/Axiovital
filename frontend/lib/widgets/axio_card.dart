import 'package:flutter/material.dart';

class AxioCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final Color? color;
  final double? borderRadius;
  final bool showShadow;
  final BorderSide? borderSide;

  const AxioCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.color,
    this.borderRadius,
    this.showShadow = true,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget card = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        border: Border.fromBorderSide(
          borderSide ?? (theme.cardTheme.shape as RoundedRectangleBorder?)?.side ?? BorderSide(color: theme.dividerColor),
        ),
        boxShadow: showShadow 
            ? [
                BoxShadow(
                  color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    
    return card;
  }
}
