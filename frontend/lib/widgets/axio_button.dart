import 'package:flutter/material.dart';

class AxioButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;
  final IconData? icon;
  final double? borderRadius;
  final double? fontSize;
  final double? height;
  final Color? color;
  final Color? textColor;

  const AxioButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.icon,
    this.borderRadius,
    this.fontSize,
    this.height,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary 
              ? theme.colorScheme.surface 
              : (color ?? theme.primaryColor),
          foregroundColor: isSecondary 
              ? theme.colorScheme.onSurface 
              : (textColor ?? Colors.white),
          elevation: isSecondary ? 0 : 2,
          shadowColor: isSecondary 
              ? Colors.transparent 
              : theme.primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            side: isSecondary 
                ? BorderSide(color: theme.colorScheme.outline) 
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: isSecondary ? theme.colorScheme.onSurface : Colors.white),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize ?? 16,
                fontWeight: FontWeight.w600,
                color: isSecondary ? theme.colorScheme.onSurface : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
