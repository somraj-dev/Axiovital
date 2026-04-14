import 'package:flutter/material.dart';
import 'insurance_policy_model.dart';
import 'proposal_details_page.dart';

class PolicyCustomizationPage extends StatefulWidget {
  final InsurancePolicy policy;

  const PolicyCustomizationPage({super.key, required this.policy});

  @override
  State<PolicyCustomizationPage> createState() => _PolicyCustomizationPageState();
}

class _PolicyCustomizationPageState extends State<PolicyCustomizationPage> {
  double _selectedCover = 1000000;
  int _selectedYears = 1;
  final Set<String> _selectedRiderIds = {};
  final Set<String> _selectedAddOnIds = {};
  double _aggregateDeductible = 10000;

  @override
  void initState() {
    super.initState();
    _selectedCover = widget.policy.coverAmountOptions.first;
    // Add "Must Have" riders by default
    for (var rider in widget.policy.availableRiders) {
      if (rider.isMustHave) {
        _selectedRiderIds.add(rider.id);
      }
    }
  }

  double get _totalPremium {
    double base = widget.policy.monthlyPremium;
    
    // Simple period multi-year discount simulation
    if (_selectedYears == 2) base *= 1.9; // 5% discount approx
    if (_selectedYears == 3) base *= 2.7; // 10% discount approx

    double ridersTotal = 0;
    for (var riderId in _selectedRiderIds) {
      final rider = widget.policy.availableRiders.firstWhere((r) => r.id == riderId);
      ridersTotal += rider.premium / 12; // Monthly
    }

    double addonsTotal = 0;
    for (var addonId in _selectedAddOnIds) {
      final addon = widget.policy.recommendedAddOns.firstWhere((a) => a.id == addonId);
      addonsTotal += addon.premium / 12; // Monthly
    }

    return base + ridersTotal + addonsTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Customize this plan',
          style: TextStyle(color: Color(0xFF1D2939), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.headset_mic_outlined, size: 20),
            label: const Text('Talk to us'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF175CD3),
              backgroundColor: const Color(0xFFEFF8FF),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlanSummary(),
                _buildCoverAndPeriod(),
                _buildRidersSection(),
                _buildAddOnsSection(),
                _buildMembersAndHelp(),
              ],
            ),
          ),
          _buildStickyFooter(),
        ],
      ),
    );
  }

  Widget _buildPlanSummary() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 60,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(widget.policy.insurerLogo, fit: BoxFit.contain),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.policy.planName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1D2939)),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.favorite_border, color: Colors.grey.shade400, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'View all features ›',
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.policy.cashlessHospitalsCount} Cashless hospitals ›',
                  style: const TextStyle(color: Color(0xFF175CD3), fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const Text(
                  '(+Cashless anywhere support)',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverAndPeriod() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cover Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 12),
          const Text('Is this cover amount sufficient?  Let\'s find out ›', style: TextStyle(color: Color(0xFF175CD3), fontSize: 13)),
          const SizedBox(height: 16),
          _buildDropdownSelector(
            currentValue: '₹${(_selectedCover / 100000).toInt()} Lakh',
            items: widget.policy.coverAmountOptions.map((v) => '₹${(v / 100000).toInt()} Lakh').toList(),
            onChanged: (val) {
               setState(() {
                 _selectedCover = double.parse(val!.replaceAll('₹', '').replaceAll(' Lakh', '')) * 100000;
               });
            },
          ),
          const SizedBox(height: 32),
          const Text('Policy Period', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 8),
          const Text(
            'Choosing a multi-year plan saves your money and the trouble of remembering yearly renewals.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          _buildPeriodOption(1, '₹${widget.policy.monthlyPremium.toInt() * 12}'),
          _buildPeriodOption(2, '₹${(widget.policy.monthlyPremium * 22.8).toInt()}', discount: 'Save ₹909'),
          _buildPeriodOption(3, '₹${(widget.policy.monthlyPremium * 32.4).toInt()}', discount: 'Save ₹1,225', isMostPopular: true),
        ],
      ),
    );
  }

  Widget _buildRidersSection() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Riders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 4),
          const Text('You should get these additional benefits to enhance your current plan', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          ...widget.policy.availableRiders.map((rider) => _buildRiderCard(rider)),
        ],
      ),
    );
  }

  Widget _buildAddOnsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           _buildDeductibleCard(),
           const SizedBox(height: 32),
           const Text('Recommended Add-Ons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
           const SizedBox(height: 4),
           const Text('Add-ons are a smart way to enhance your cover at a fraction of the cost.', style: TextStyle(color: Colors.grey, fontSize: 13)),
           const SizedBox(height: 16),
           SingleChildScrollView(
             scrollDirection: Axis.horizontal,
             child: Row(
               children: [
                 _buildFilterChip('Recommended', true),
                 _buildFilterChip('Super Top-Up', false),
                 _buildFilterChip('Critical Illness', false),
               ],
             ),
           ),
           const SizedBox(height: 16),
           ...widget.policy.recommendedAddOns.map((addon) => _buildAddOnCard(addon)),
        ],
      ),
    );
  }

  Widget _buildMembersAndHelp() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Members Covered', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Somraj Lodhi(19)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Need Help?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('We\'re just one tap away', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('CALL NOW'),
                    ),
                  ],
                ),
              ),
              Image.network(
                'https://cdn3d.iconscout.com/3d/premium/thumb/female-customer-service-5842008-4852924.png',
                height: 80,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStickyFooter() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Premium', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Row(
                    children: [
                      Text(
                        '₹${_totalPremium.toInt()}/-',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.expand_less, size: 20, color: Colors.grey),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProposalDetailsPage(
                          policy: widget.policy,
                          premium: _totalPremium,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0052CC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Proceed to proposal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildPeriodOption(int years, String price, {String? discount, bool isMostPopular = false}) {
    bool isSelected = _selectedYears == years;
    return GestureDetector(
      onTap: () => setState(() => _selectedYears = years),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? const Color(0xFF175CD3) : Colors.grey.shade300, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? const Color(0xFFEFF8FF) : Colors.white,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? const Color(0xFF175CD3) : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text('$years Year${years > 1 ? 's' : ''} @ ', style: const TextStyle(fontSize: 15)),
                Text(price, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (discount != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFF0FDF9), borderRadius: BorderRadius.circular(4)),
                    child: Text(discount, style: const TextStyle(color: Color(0xFF12B76A), fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            if (isMostPopular)
              Positioned(
                right: 0,
                top: -12,
                child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                   decoration: const BoxDecoration(color: Color(0xFFE9D7FE), borderRadius: BorderRadius.vertical(bottom: Radius.circular(4))),
                   child: const Text('Most popular', style: TextStyle(color: Color(0xFF6941C6), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiderCard(PolicyRider rider) {
    bool isSelected = _selectedRiderIds.contains(rider.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(rider.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (rider.isMustHave)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFF4EBFF), borderRadius: BorderRadius.circular(4)),
                  child: const Text('★ Must Have', style: TextStyle(color: Color(0xFF7F56D9), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(rider.description, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Premium', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  Text('₹${rider.premium.toInt()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              OutlinedButton(
                onPressed: () => setState(() => isSelected ? _selectedRiderIds.remove(rider.id) : _selectedRiderIds.add(rider.id)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: isSelected ? Colors.red : const Color(0xFF175CD3)),
                  foregroundColor: isSelected ? Colors.red : const Color(0xFF175CD3),
                ),
                child: Text(isSelected ? 'Remove' : '+ Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddOnCard(PolicyAddOn addon) {
    bool isSelected = _selectedAddOnIds.contains(addon.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(addon.insurerLogo, height: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(addon.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('Member(s) : All', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...addon.bulletPoints.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 6, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(p, style: const TextStyle(fontSize: 12, color: Colors.black87))),
              ],
            ),
          )),
          const SizedBox(height: 16),
          _buildAddonPricingBar(addon, isSelected),
        ],
      ),
    );
  }

  Widget _buildAddonPricingBar(PolicyAddOn addon, bool isSelected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cover', style: TextStyle(color: Colors.grey, fontSize: 11)),
            Text('₹${(addon.cover / 100000).toInt()}L ⌵', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Premium (1 Year)', style: TextStyle(color: Colors.grey, fontSize: 11)),
            Text('₹${addon.premium.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        OutlinedButton(
          onPressed: () => setState(() => isSelected ? _selectedAddOnIds.remove(addon.id) : _selectedAddOnIds.add(addon.id)),
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? Colors.transparent : const Color(0xFFEFF8FF),
            side: BorderSide(color: isSelected ? Colors.red : const Color(0xFF175CD3)),
          ),
          child: Text(isSelected ? 'Remove' : '+ Add'),
        ),
      ],
    );
  }

  Widget _buildDeductibleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FAFF),
        border: Border.all(color: const Color(0xFFB2DDFF)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Aggregate Deductible', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Get a discount on your insurance premium when you agree to pay a certain aggregate deductible amount', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const Divider(height: 24),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Deductible amount', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  Text('10,000 ⌵', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('You Save', style: TextStyle(color: Color(0xFF12B76A), fontSize: 11)),
                  Text('₹540', style: TextStyle(color: Color(0xFF12B76A), fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 16),
              OutlinedButton(onPressed: () {}, child: const Text('Apply')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSelector({required String currentValue, required List<String> items, required Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEFF8FF) : Colors.white,
        border: Border.all(color: isSelected ? const Color(0xFF175CD3) : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? const Color(0xFF175CD3) : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
