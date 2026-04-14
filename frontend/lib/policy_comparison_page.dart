import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'insurance_provider.dart';
import 'insurance_policy_model.dart';
import 'widgets/insurance/comparison_header_card.dart';
import 'widgets/insurance/compact_compare_header.dart';
import 'widgets/insurance/comparison_row.dart';
import 'widgets/insurance/comparison_accordion.dart';

class PolicyComparisonPage extends StatefulWidget {
  const PolicyComparisonPage({super.key});

  @override
  State<PolicyComparisonPage> createState() => _PolicyComparisonPageState();
}

class _PolicyComparisonPageState extends State<PolicyComparisonPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  double _stickyHeaderOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show sticky header after scrolling past the top cards (~280px)
    double offset = _scrollController.offset;
    double newOpacity = (offset / 150).clamp(0.0, 1.0);
    if (newOpacity != _stickyHeaderOpacity) {
      setState(() {
        _stickyHeaderOpacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InsuranceProvider>(context);
    final selected = provider.selectedForCompare;

    if (selected.length < 2) {
      return Scaffold(
        appBar: AppBar(title: const Text('Comparison')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Select 2 plans to compare'),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Go back')),
            ],
          ),
        ),
      );
    }

    final p1 = selected[0];
    final p2 = selected[1];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              _buildTabs(),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 120),
                  children: [
                    _buildTopPolicyComparison(p1, p2, provider),
                    _buildSummarySection(p1, p2),
                    _buildDetailedSection(p1, p2),
                    _buildDisclaimer(),
                  ],
                ),
              ),
            ],
          ),
          
          // Sticky Compact Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CompactCompareHeader(p1: p1, p2: p2, opacity: _stickyHeaderOpacity),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomCTA(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
      title: const Text('Compare plans', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD1E0FF)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.headset_mic_outlined, size: 16, color: Color(0xFF0052CC)),
                  SizedBox(width: 6),
                  Text('Talk to us', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0052CC))),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF0052CC),
        labelColor: const Color(0xFF1D2939),
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
        tabs: const [
          Tab(text: 'Comparison summary'),
          Tab(text: 'Detailed comparison'),
        ],
      ),
    );
  }

  Widget _buildTopPolicyComparison(InsurancePolicy p1, InsurancePolicy p2, InsuranceProvider provider) {
    return Container(
      color: const Color(0xFFEFF4FF).withOpacity(0.3),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ComparisonHeaderCard(
              policy: p1,
              onRemove: () {
                provider.removeSelectedCompare(p1.id);
                Navigator.pop(context);
              },
              onCustomize: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ComparisonHeaderCard(
              policy: p2,
              onRemove: () {
                provider.removeSelectedCompare(p2.id);
                Navigator.pop(context);
              },
              onCustomize: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(InsurancePolicy p1, InsurancePolicy p2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            'Comparison summary (4 key differences)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1D2939)),
          ),
        ),
        ComparisonRow(
          label: 'Room rent limit', 
          description: 'Room rent limit is the maximum allowed room category and cost of room per day.', 
          value1: p1.roomRentPolicy, value2: p2.roomRentPolicy,
          highlightBetter: true, is1Better: p1.roomRentPolicy.contains('No'),
        ),
        ComparisonRow(
          label: 'Restoration of cover', 
          description: 'Sum insured is restored back to actual amount if it gets exhausted during the policy year.', 
          value1: p1.restorationBenefit, value2: p2.restorationBenefit,
          badge2: 'Unlimited times',
        ),
        ComparisonRow(
          label: 'Renewal Bonus', 
          description: 'Bonus sum insured added for every claim-free year.', 
          value1: '₹3.33 lakh per year', value2: '₹2.5 lakh per year',
          highlightBetter: true, is1Better: true,
        ),
        ComparisonRow(
          label: 'Free health checkup', 
          description: 'A complimentary comprehensive health test provided annually.', 
          value1: 'Covered upto ₹3000', value2: 'Available as optional',
          highlightBetter: true, is1Better: true,
        ),
      ],
    );
  }

  Widget _buildDetailedSection(InsurancePolicy p1, InsurancePolicy p2) {
    return Column(
      children: [
        const SizedBox(height: 12),
        ComparisonAccordion(
          title: 'Coverage',
          subtitle: '9 key differences',
          initiallyExpanded: true,
          children: [
            ComparisonRow(
              label: 'Pre-hospitalization coverage', 
              description: 'Covers expenses incurred before admission to the hospital.', 
              value1: p1.preHospitalization ?? 'Covered upto 60 days', 
              value2: p2.preHospitalization ?? 'Covered upto 60 days',
            ),
            ComparisonRow(
              label: 'Post-hospitalization coverage', 
              description: 'Covers expenses incurred after discharge from the hospital.', 
              value1: p1.postHospitalization ?? 'Covered upto 180 days', 
              value2: p2.postHospitalization ?? 'Covered upto 90 days',
              highlightBetter: true, is1Better: true,
            ),
            ComparisonRow(
              label: 'Ambulance charges', 
              description: 'Covers the cost of emergency transportation to the hospital.', 
              value1: p1.ambulanceCharges ?? '₹10,000', 
              value2: p2.ambulanceCharges ?? '₹10,000',
            ),
          ],
        ),
        ComparisonAccordion(
          title: 'Hospitalization Benefits',
          children: [
            ComparisonRow(
              label: 'ICU charges', 
              description: 'Covers intensive care unit stay expenses.', 
              value1: p1.icuCharges ?? 'No limit', 
              value2: p2.icuCharges ?? 'No limit',
            ),
            ComparisonRow(
              label: 'Organ donor cover', 
              description: 'Covers medical expenses for the organ donor during transplant.', 
              value1: p1.organDonorCover ?? 'Covered', 
              value2: p2.organDonorCover ?? 'Covered',
            ),
          ],
        ),
        ComparisonAccordion(
          title: 'Maternity Benefit(s)',
          subtitle: 'No key difference',
          children: [
             ComparisonRow(
              label: 'Maternity cover', 
              description: 'Expenses related to pregnancy and delivery.', 
              value1: p1.maternityBenefit ?? 'Not Covered', 
              value2: p2.maternityBenefit ?? 'Not Covered',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 16),
          _buildDisclaimerText('†Policy information is based on insurer provided data and may change.'),
          _buildDisclaimerText('*Final coverage depends on underwriting, eligibility, age, city, and selected add-ons.'),
          _buildDisclaimerText('^Users should review full policy wording before purchase.'),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDisclaimerText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, color: Colors.grey, height: 1.4),
      ),
    );
  }

  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEFF4FF),
                foregroundColor: const Color(0xFF0052CC),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Customize Plan A', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052CC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Customize Plan B', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
