import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'insurance_provider.dart';
import 'consolidated_policy_details.dart';
import 'policy_customization_page.dart';
import 'widgets/insurance/insurance_policy_card.dart';
import 'widgets/insurance/sticky_filter_bar.dart';
import 'widgets/insurance/compare_tray.dart';
import 'insurance_details_page.dart';
import 'search_page.dart';

class InsuranceFeedPage extends StatefulWidget {
  const InsuranceFeedPage({super.key});

  @override
  State<InsuranceFeedPage> createState() => _InsuranceFeedPageState();
}

class _InsuranceFeedPageState extends State<InsuranceFeedPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<InsuranceProvider>().fetchPolicies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<InsuranceProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Insurance Policy'),
            Text('Browse and compare health insurance plans', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.normal)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
          }, icon: const Icon(Icons.search)),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const StickyFilterBar(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.fetchPolicies(refresh: true),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 150),
                    itemCount: provider.policies.length + (provider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < provider.policies.length) {
                        final policy = provider.policies[index];
                        return InsurancePolicyCard(
                          policy: policy,
                          isSelectedForCompare: provider.isSelectedForCompare(policy.id),
                          onCompareTap: () => provider.toggleCompare(policy),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ConsolidatedPolicyDetailsPage(policy: policy)),
                            );
                          },
                          onCustomizeTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PolicyCustomizationPage(policy: policy)),
                            );
                          },
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          
          // Sticky Sort/Filter Bottom Bar
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D2939),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildBottomAction(Icons.sort, 'Sort by'),
                    Container(width: 1, height: 20, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 16)),
                    _buildBottomAction(Icons.tune, 'Filters'),
                  ],
                ),
              ),
            ),
          ),

          // Compare Tray (slides up when selection exists)
          const Align(
            alignment: Alignment.bottomCenter,
            child: CompareTray(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
