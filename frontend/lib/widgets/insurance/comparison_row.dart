import 'package:flutter/material.dart';

class ComparisonRow extends StatefulWidget {
  final String label;
  final String description;
  final String value1;
  final String value2;
  final String? badge1;
  final String? badge2;
  final bool highlightBetter;
  final bool is1Better;

  const ComparisonRow({
    super.key,
    required this.label,
    required this.description,
    required this.value1,
    required this.value2,
    this.badge1,
    this.badge2,
    this.highlightBetter = false,
    this.is1Better = false,
  });

  @override
  State<ComparisonRow> createState() => _ComparisonRowState();
}

class _ComparisonRowState extends State<ComparisonRow> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.05))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.info_outline, size: 14, color: theme.colorScheme.onSurface.withOpacity(0.3)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildValueColumn(
                    widget.value1,
                    widget.badge1,
                    widget.highlightBetter && widget.is1Better,
                    theme,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildValueColumn(
                    widget.value2,
                    widget.badge2,
                    widget.highlightBetter && !widget.is1Better,
                    theme,
                  ),
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValueColumn(String value, String? badge, bool isBetter, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isBetter || badge != null)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              border: Border.all(color: const Color(0xFFD1FADF)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 10, color: Color(0xFF12B76A)),
                const SizedBox(width: 4),
                Text(
                  badge ?? 'Best in this comparison',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF027A48),
                  ),
                ),
              ],
            ),
          ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isBetter ? const Color(0xFF12B76A) : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
