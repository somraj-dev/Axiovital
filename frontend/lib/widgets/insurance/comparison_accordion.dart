import 'package:flutter/material.dart';

class ComparisonAccordion extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool initiallyExpanded;

  const ComparisonAccordion({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  State<ComparisonAccordion> createState() => _ComparisonAccordionState();
}

class _ComparisonAccordionState extends State<ComparisonAccordion> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: Color(0xFF1D2939),
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.remove : Icons.add,
                    color: const Color(0xFF1D2939),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Column(
              children: widget.children,
            ),
        ],
      ),
    );
  }
}
