import 'package:flutter/material.dart';

class StickyFilterBar extends StatelessWidget {
  const StickyFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = [
      'Cover',
      'New launches',
      'Important Features',
      'Age',
      'Family size',
      'Cashless Hospitals',
    ];

    return Container(
      height: 60,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          bool isPurple = filter == 'Important Features';

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: isPurple ? const Color(0xFF6941C6) : Colors.grey.shade300,
                width: isPurple ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Row(
                children: [
                  if (filter == 'New launches')
                    const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Text('🌟', style: TextStyle(fontSize: 12)),
                    ),
                  Text(
                    filter,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isPurple ? const Color(0xFF6941C6) : const Color(0xFF344054),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
