import 'package:flutter/material.dart';

class AxioAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final Color? backgroundColor;
  final IconData defaultIcon;

  const AxioAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 20,
    this.backgroundColor,
    this.defaultIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey.shade200,
        child: ClipOval(
          child: Image.network(
            imageUrl!,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  width: radius,
                  height: radius,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildFallback(context);
            },
          ),
        ),
      );
    } else {
      return _buildFallback(context);
    }
  }

  Widget _buildFallback(BuildContext context) {
    if (name != null && name!.isNotEmpty) {
      final initials = _getInitials(name!);
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.8),
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.8,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey.shade300,
      child: Icon(defaultIcon, size: radius, color: Colors.grey.shade600),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }
}
