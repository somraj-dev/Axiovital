import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../insurance_provider.dart';
import '../../insurance_policy_model.dart';
import '../../policy_comparison_page.dart';

class CompareTray extends StatelessWidget {
  const CompareTray({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InsuranceProvider>(context);
    final selected = provider.selectedForCompare;

    if (selected.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Compare plans',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1D2939)),
              ),
              IconButton(
                onPressed: () => provider.clearCompare(),
                icon: const Icon(Icons.close, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildSelectedPolicy(context, selected.elementAtOrNull(0), provider)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xFFF2F4F7),
                  child: Text('VS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
              ),
              Expanded(child: _buildSelectedPolicy(context, selected.elementAtOrNull(1), provider)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: selected.length == 2
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PolicyComparisonPage()),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052CC),
                disabledBackgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(
                selected.length < 2 ? 'Select 1 more plan' : 'Compare now',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPolicy(BuildContext context, InsurancePolicy? policy, InsuranceProvider provider) {
    if (policy == null) {
      return Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.grey),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(policy.insurerLogo, height: 24, width: 40, fit: BoxFit.contain),
              const SizedBox(height: 8),
              Text(
                policy.planName,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: GestureDetector(
            onTap: () => provider.removeSelectedCompare(policy.id),
            child: const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white,
              child: Icon(Icons.cancel, size: 18, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
