import 'package:flutter/material.dart';
import 'insurance_policy_model.dart';
import 'widgets/insurance/policy_highlight_card.dart';
import 'widgets/insurance/policy_support_card.dart';
import 'widgets/insurance/policy_document_tile.dart';

class InsuranceDetailsPage extends StatefulWidget {
  final InsurancePolicy policy;

  const InsuranceDetailsPage({super.key, required this.policy});

  @override
  State<InsuranceDetailsPage> createState() => _InsuranceDetailsPageState();
}

class _InsuranceDetailsPageState extends State<InsuranceDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  String _activeChip = 'Highlights';

  // Specific keys for anchor scrolling
  final GlobalKey _highlightsKey = GlobalKey();
  final GlobalKey _coverageKey = GlobalKey();
  final GlobalKey _valueAddedKey = GlobalKey();
  final GlobalKey _documentsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_syncActiveChip);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_syncActiveChip);
    _scrollController.dispose();
    super.dispose();
  }

  void _syncActiveChip() {
    // Basic positions for sync (can be dynamic, but fixed for performance)
    if (_scrollController.offset < 300) {
      if (_activeChip != 'Highlights') setState(() => _activeChip = 'Highlights');
    } else if (_scrollController.offset < 700) {
      if (_activeChip != 'Coverage') setState(() => _activeChip = 'Coverage');
    } else if (_scrollController.offset < 1000) {
      if (_activeChip != 'Value Added Services') setState(() => _activeChip = 'Value Added Services');
    } else {
      if (_activeChip != 'Documents') setState(() => _activeChip = 'Documents');
    }
  }

  void _scrollToSection(GlobalKey key, String chip) {
    setState(() => _activeChip = chip);
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutQuart,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.policy.planName,
              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const Text(
               'Comprehensive health plan',
               style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: Colors.black87), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildNavigationChips(),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _buildHighlightsSection(),
                  _buildDetailedCoverageSection(),
                  _buildValueAddedSection(),
                  _buildSupportBanner(),
                  _buildDocumentsSection(),
                  _buildAboutSection(),
                  const SizedBox(height: 140), // Margin for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildStickyFooter(),
    );
  }

  Widget _buildNavigationChips() {
    final chips = [
      {'label': 'Highlights', 'key': _highlightsKey},
      {'label': 'Coverage', 'key': _coverageKey},
      {'label': 'Value Added Services', 'key': _valueAddedKey},
      {'label': 'Documents', 'key': _documentsKey},
    ];

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chips.length,
        itemBuilder: (context, index) {
          final label = chips[index]['label'] as String;
          final key = chips[index]['key'] as GlobalKey;
          final isSelected = _activeChip == label;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) => _scrollToSection(key, label),
                selectedColor: const Color(0xFF1D2939),
                backgroundColor: const Color(0xFFF2F4F7),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF475467),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHighlightsSection() {
    return Column(
      key: _highlightsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Text('Highlights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: widget.policy.highlights.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => PolicyHighlightCard(highlight: widget.policy.highlights[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedCoverageSection() {
    final features = widget.policy.groupedFeatures['Coverage'] ?? [];
    return Column(
      key: _coverageKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 32, 20, 16),
          child: Text('Coverage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ),
        ...features.map((f) => _buildFeatureRow(f)),
      ],
    );
  }

  Widget _buildValueAddedSection() {
    final features = widget.policy.groupedFeatures['Value Added Services'] ?? [];
    return Column(
      key: _valueAddedKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 32, 20, 16),
          child: Text('Value Added Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ),
        ...features.map((f) => _buildFeatureRow(f)),
      ],
    );
  }

  Widget _buildFeatureRow(PolicyFeature feature) {
    Color iconBg;
    Color iconColor;
    IconData icon;

    if (feature.isOptional) {
      iconBg = const Color(0xFFFFFAEB);
      iconColor = const Color(0xFFB54708);
      icon = Icons.add_circle_outline;
    } else if (feature.isCovered) {
      iconBg = const Color(0xFFF0FDF4);
      iconColor = const Color(0xFF039855);
      icon = Icons.check_circle_outline;
    } else {
      iconBg = const Color(0xFFFEF3F2);
      iconColor = const Color(0xFFD92D20);
      icon = Icons.cancel_outlined;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(feature.value, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildSupportBanner() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Need Help?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('Chat with our health experts.', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D2939),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      key: _documentsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Text('Policy Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ),
        ...widget.policy.documents.map((doc) => PolicyDocumentTile(document: doc)),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About ${widget.policy.insurerName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          const Text(
            'Axio Shield is a leading insuretech provider offering seamless healthcare protection plans for the modern age with digital-first claim processing.',
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payable Yearly', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              Text(
                '₹${(widget.policy.monthlyPremium * 12).toInt()}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Add-ons', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052CC),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
