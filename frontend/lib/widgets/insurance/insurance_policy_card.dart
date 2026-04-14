import 'package:flutter/material.dart';
import '../../insurance_policy_model.dart';
import '../axio_card.dart';

class InsurancePolicyCard extends StatefulWidget {
  final InsurancePolicy policy;
  final bool isSelectedForCompare;
  final VoidCallback onCompareTap;
  final VoidCallback onTap;
  final VoidCallback onCustomizeTap;

  const InsurancePolicyCard({
    super.key,
    required this.policy,
    required this.isSelectedForCompare,
    required this.onCompareTap,
    required this.onTap,
    required this.onCustomizeTap,
  });

  @override
  State<InsurancePolicyCard> createState() => _InsurancePolicyCardState();
}

class _InsurancePolicyCardState extends State<InsurancePolicyCard> {
  double selectedCover = 1000000;

  @override
  void initState() {
    super.initState();
    selectedCover = widget.policy.coverAmountOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Insurer ID + Tag
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                    widget.policy.insurerLogo,
                    fit: BoxFit.contain,
                    errorBuilder: (context, _, __) => const Icon(Icons.business, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.policy.insurerName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      Text(
                        'Know more about ${widget.policy.insurerName} ›',
                        style: TextStyle(fontSize: 11, color: theme.primaryColor, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                if (widget.policy.tagBadges.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0E7FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.policy.tagBadges.first,
                      style: const TextStyle(color: Color(0xFF6941C6), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Plan Name
            Row(
              children: [
                Text(
                  widget.policy.planName,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(width: 8),
                Icon(Icons.favorite_border, size: 20, color: theme.colorScheme.onSurface.withOpacity(0.4)),
              ],
            ),
            const SizedBox(height: 12),

            // Summary Bullets
            _buildBulletItem(Icons.local_hospital_outlined, '${widget.policy.cashlessHospitalsCount} Cashless hospitals. View list ›'),
            _buildBulletItem(Icons.bed_outlined, widget.policy.roomRentPolicy),
            _buildBulletItem(Icons.workspace_premium_outlined, '₹${(widget.policy.noClaimBonus / 100000).toStringAsFixed(1)} lakh No Claim Bonus'),
            _buildBulletItem(Icons.history_outlined, widget.policy.restorationBenefit),

            TextButton(
              onPressed: widget.onTap,
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 30)),
              child: Text('View all features ›', style: TextStyle(color: theme.primaryColor, fontSize: 13, fontWeight: FontWeight.w600)),
            ),

            const Divider(height: 24, thickness: 1),

            // Cover and Premium Selectors
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cover amount', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.5))),
                      _buildCoverDropdown(theme),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Premium (1 year)', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.5))),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            widget.policy.formattedPremium,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                          const Text('/month', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      if (widget.policy.oldPremium != null)
                        Text(
                          '₹${widget.policy.oldPremium!.toInt()} Incl. GST',
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Discount Badge
            if (widget.policy.discountPercent != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.percent, color: Color(0xFF12B76A), size: 14),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Inclusive of 5% online discount*',
                        style: TextStyle(color: Color(0xFF12B76A), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            // CTA Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCompareTap,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: widget.isSelectedForCompare ? theme.primaryColor : Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.isSelectedForCompare)
                          Icon(Icons.check, size: 16, color: theme.primaryColor),
                        if (widget.isSelectedForCompare)
                          const SizedBox(width: 4),
                        Text(
                          widget.isSelectedForCompare ? 'Added to compare' : '+ Add to compare',
                          style: TextStyle(
                            color: widget.isSelectedForCompare ? theme.primaryColor : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onCustomizeTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0052CC), // Blueish like standard insurance apps
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Customize plan ›', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF12B76A)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildCoverDropdown(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '₹${(selectedCover / 100000).toInt()} Lakh',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }
}
