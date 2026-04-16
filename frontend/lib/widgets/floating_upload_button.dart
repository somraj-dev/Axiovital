import 'package:flutter/material.dart';

class FloatingUploadButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingUploadButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(
              Icons.add_a_photo_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
