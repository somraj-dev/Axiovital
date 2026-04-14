import 'package:flutter/material.dart';
import '../../insurance_policy_model.dart';

class ComparisonHeaderCard extends StatelessWidget {
  final InsurancePolicy policy;
  final VoidCallback onRemove;
  final VoidCallback onCustomize;

  const ComparisonHeaderCard({
    super.key,
    required this.policy,
    required this.onRemove,
    required this.onCustomize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(policy.insurerLogo, fit: BoxFit.contain),
              ),
              Row(
                children: [
                  Icon(Icons.favorite_border, size: 18, color: theme.colorScheme.onSurface.withOpacity(0.3)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onRemove,
                    child: Icon(Icons.close, size: 20, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            policy.planName,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, height: 1.2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Cover: ₹10 Lakh ›', theme),
          const SizedBox(height: 4),
          _buildPriceRow(policy.monthlyPremium, theme),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: onCustomize,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052CC),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Customize plan ›', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String text, ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface.withOpacity(0.6),
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.dashed,
      ),
    );
  }

  Widget _buildPriceRow(double premium, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Premium: ', style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.4))),
            Text('₹${(premium * 12).toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', 
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        Text('₹${premium.toInt()}/month', style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.4))),
      ],
    );
  }
}
