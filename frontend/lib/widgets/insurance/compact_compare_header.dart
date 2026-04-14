import 'package:flutter/material.dart';
import '../../insurance_policy_model.dart';

class CompactCompareHeader extends StatelessWidget {
  final InsurancePolicy? p1;
  final InsurancePolicy? p2;
  final double opacity;

  const CompactCompareHeader({
    super.key,
    this.p1,
    this.p2,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    if (opacity <= 0) return const SizedBox.shrink();
    
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (p1 != null) Expanded(child: _buildCompactItem(p1!)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('vs', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
            if (p2 != null) Expanded(child: _buildCompactItem(p2!)),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactItem(InsurancePolicy p) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.planName,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, overflow: TextOverflow.ellipsis),
        ),
        Row(
          children: [
            Text('₹10L • ', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
            Text('₹${p.monthlyPremium.toInt()}/mo', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          ],
        ),
      ],
    );
  }
}
