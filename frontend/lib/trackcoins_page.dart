import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'trackcoins_provider.dart';

class TrackcoinsPage extends StatefulWidget {
  const TrackcoinsPage({super.key});

  @override
  State<TrackcoinsPage> createState() => _TrackcoinsPageState();
}

class _TrackcoinsPageState extends State<TrackcoinsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _txFilters = ['All', 'Earned', 'Spent', 'Refund', 'Bonus', 'Expired'];
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _txFilters.length, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedFilter = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackcoinsProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D2939)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Trackcoins', style: TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Color(0xFF667085)),
            onPressed: () => _showInfoSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── HERO WALLET CARD ──────────────────────────
            _buildHeroWalletCard(provider),

            const SizedBox(height: 20),

            // ─── QUICK ACTIONS ─────────────────────────────
            _buildQuickActions(context, provider),

            const SizedBox(height: 24),

            // ─── EXPIRY WARNING ────────────────────────────
            if (provider.expiringBalance > 0)
              _buildExpiryWarning(provider),

            // ─── OFFERS CAROUSEL ───────────────────────────
            _buildSectionTitle('Offers & Rewards'),
            _buildOffersCarousel(provider),

            const SizedBox(height: 24),

            // ─── HOW TO EARN ───────────────────────────────
            _buildSectionTitle('How to Earn Trackcoins'),
            _buildEarningSection(provider),

            const SizedBox(height: 24),

            // ─── REDEMPTION OPTIONS ────────────────────────
            _buildSectionTitle('Redeem Trackcoins'),
            _buildRedemptionSection(provider),

            const SizedBox(height: 24),

            // ─── TRANSACTION HISTORY ───────────────────────
            _buildSectionTitle('Transaction History'),
            _buildTransactionFilters(),
            _buildTransactionList(provider),

            const SizedBox(height: 32),

            // ─── WHAT ARE TRACKCOINS ───────────────────────
            _buildInfoModule(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  HERO WALLET CARD
  // ════════════════════════════════════════════════════════════════
  Widget _buildHeroWalletCard(TrackcoinsProvider provider) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B1F3B), Color(0xFF2D3282)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF2D3282).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.toll_rounded, color: Color(0xFFFBBF24), size: 28),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Balance', style: TextStyle(color: Color(0xFFD0D5DD), fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: 0, end: provider.availableBalance),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Text(
                            '$value',
                            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -1),
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 6, left: 6),
                        child: Text('TC', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '≈ ₹${provider.coinValue.toStringAsFixed(0)}',
                  style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Your healthcare currency for bookings, services, and rewards',
            style: TextStyle(color: Color(0xFFD0D5DD), fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _walletStat('Earned', provider.earnedTotal, const Color(0xFF12B76A)),
                Container(width: 1, height: 36, color: Colors.white.withOpacity(0.15)),
                _walletStat('Spent', provider.spentTotal, const Color(0xFFF97066)),
                Container(width: 1, height: 36, color: Colors.white.withOpacity(0.15)),
                _walletStat('Locked', provider.lockedBalance, const Color(0xFFFBBF24)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletStat(String label, int value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.toll_rounded, color: color, size: 14),
            const SizedBox(width: 4),
            Text('$value', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  QUICK ACTIONS
  // ════════════════════════════════════════════════════════════════
  Widget _buildQuickActions(BuildContext context, TrackcoinsProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _quickActionButton(
            'Buy Coins',
            Icons.add_circle_outline_rounded,
            const Color(0xFF2E90FA),
            () => _showSnack(context, 'Buy Trackcoins coming soon!'),
          ),
          const SizedBox(width: 10),
          _quickActionButton(
            'Redeem',
            Icons.redeem_rounded,
            const Color(0xFF12B76A),
            () => _showSnack(context, 'Scroll down to see redemption options'),
          ),
          const SizedBox(width: 10),
          _quickActionButton(
            'History',
            Icons.history_rounded,
            const Color(0xFF7C3AED),
            () => _showSnack(context, 'Scroll down for full transaction history'),
          ),
        ],
      ),
    );
  }

  Widget _quickActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEAECF0)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(label, style: TextStyle(color: const Color(0xFF344054), fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  EXPIRY WARNING
  // ════════════════════════════════════════════════════════════════
  Widget _buildExpiryWarning(TrackcoinsProvider provider) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFEC84B).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFFEC84B).withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.timer_outlined, color: Color(0xFFDC6803), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${provider.expiringBalance} Trackcoins expiring!',
                  style: const TextStyle(color: Color(0xFF93370D), fontWeight: FontWeight.w700, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  'Use before ${provider.expiringDate}',
                  style: const TextStyle(color: Color(0xFFB54708), fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFDC6803),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Use Now', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  OFFERS CAROUSEL
  // ════════════════════════════════════════════════════════════════
  Widget _buildOffersCarousel(TrackcoinsProvider provider) {
    final gradients = [
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFF11998E), const Color(0xFF38EF7D)],
      [const Color(0xFFFC5C7D), const Color(0xFF6A82FB)],
      [const Color(0xFFf857a6), const Color(0xFFff5858)],
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: provider.offers.length,
        itemBuilder: (context, index) {
          final offer = provider.offers[index];
          final grad = gradients[index % gradients.length];
          return Container(
            width: 260,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: grad, begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.toll_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    Text('+${offer.coinsReward} TC', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(offer.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(offer.description, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(offer.validity ?? '', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w500)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(8)),
                      child: const Text('Claim', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  EARNING SECTION
  // ════════════════════════════════════════════════════════════════
  Widget _buildEarningSection(TrackcoinsProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: provider.earningRules.map((rule) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (rule['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(rule['icon'] as IconData, color: rule['color'] as Color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rule['activity'] as String, style: const TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 4),
                      if (rule['status'] == 'in_progress')
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: rule['progress'] as double,
                            backgroundColor: const Color(0xFFEAECF0),
                            valueColor: AlwaysStoppedAnimation<Color>(rule['color'] as Color),
                            minHeight: 4,
                          ),
                        )
                      else
                        Text(
                          rule['status'] == 'locked' ? 'Complete prerequisites to unlock' : 'Earn on each completion',
                          style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 11),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.toll_rounded, color: Color(0xFF12B76A), size: 14),
                      const SizedBox(width: 4),
                      Text('+${rule['coins']}', style: const TextStyle(color: Color(0xFF12B76A), fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  REDEMPTION SECTION
  // ════════════════════════════════════════════════════════════════
  Widget _buildRedemptionSection(TrackcoinsProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: provider.redemptionOptions.map((item) {
          final canRedeem = provider.availableBalance >= (item['coins'] as int);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'] as String, style: const TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 3),
                      Text(item['description'] as String, style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: canRedeem ? () {
                    provider.spendCoins(item['coins'] as int);
                    _showSnack(context, '🎉 Redeemed ${item['title']}!');
                  } : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: canRedeem ? const Color(0xFFE11D48) : const Color(0xFFEAECF0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.toll_rounded, color: canRedeem ? Colors.white : const Color(0xFF98A2B3), size: 12),
                            const SizedBox(width: 3),
                            Text('${item['coins']}', style: TextStyle(color: canRedeem ? Colors.white : const Color(0xFF98A2B3), fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        Text('Redeem', style: TextStyle(color: canRedeem ? Colors.white : const Color(0xFF98A2B3), fontSize: 9, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  TRANSACTION FILTERS + LIST
  // ════════════════════════════════════════════════════════════════
  Widget _buildTransactionFilters() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _txFilters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilter == index;
          return GestureDetector(
            onTap: () => setState(() {
              _selectedFilter = index;
              _tabController.animateTo(index);
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1D2939) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? const Color(0xFF1D2939) : const Color(0xFFEAECF0)),
              ),
              alignment: Alignment.center,
              child: Text(
                _txFilters[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF667085),
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionList(TrackcoinsProvider provider) {
    final filtered = provider.getFilteredTransactions(_txFilters[_selectedFilter]);

    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.receipt_long_outlined, color: const Color(0xFFD0D5DD), size: 48),
              const SizedBox(height: 12),
              const Text('No transactions found', style: TextStyle(color: Color(0xFF98A2B3), fontSize: 14)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: filtered.map((tx) {
          final isPositive = tx.type == 'earned' || tx.type == 'bonus' || tx.type == 'refund';
          final now = DateTime.now();
          final diff = now.difference(tx.createdAt);
          String timeAgo;
          if (diff.inHours < 1) {
            timeAgo = '${diff.inMinutes}m ago';
          } else if (diff.inHours < 24) {
            timeAgo = '${diff.inHours}h ago';
          } else {
            timeAgo = '${diff.inDays}d ago';
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF2F4F7)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tx.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(tx.icon, color: tx.color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tx.title, style: const TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(timeAgo, style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 11)),
                          if (tx.referenceId != null) ...[
                            const Text(' · ', style: TextStyle(color: Color(0xFFD0D5DD))),
                            Text(tx.referenceId!, style: const TextStyle(color: Color(0xFF2E90FA), fontSize: 11, fontWeight: FontWeight.w500)),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '${isPositive ? '+' : '-'}${tx.amount} TC',
                  style: TextStyle(
                    color: isPositive ? const Color(0xFF12B76A) : const Color(0xFFE11D48),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  INFO MODULE — WHAT ARE TRACKCOINS
  // ════════════════════════════════════════════════════════════════
  Widget _buildInfoModule() {
    final items = [
      {'icon': Icons.calendar_month_rounded, 'text': 'Book appointments faster'},
      {'icon': Icons.medication_rounded, 'text': 'Save on medicines'},
      {'icon': Icons.lock_open_rounded, 'text': 'Unlock health programs'},
      {'icon': Icons.discount_rounded, 'text': 'Get discounts on consultations'},
      {'icon': Icons.card_giftcard_rounded, 'text': 'Redeem exclusive rewards'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2DDFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF2E90FA).withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.toll_rounded, color: Color(0xFF2E90FA), size: 22),
              ),
              const SizedBox(width: 12),
              const Text('What are Trackcoins?', style: TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Trackcoins are your virtual healthcare currency inside AxioVital. Earn them by staying healthy, and use them across the ecosystem.',
            style: TextStyle(color: Color(0xFF475467), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 16),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(item['icon'] as IconData, color: const Color(0xFF2E90FA), size: 18),
                  const SizedBox(width: 10),
                  Text(item['text'] as String, style: const TextStyle(color: Color(0xFF344054), fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  HELPERS
  // ════════════════════════════════════════════════════════════════
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Text(title, style: const TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.w700, fontSize: 17)),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1D2939),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('About Trackcoins', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 16),
              _infoRow('1 Trackcoin', '= ₹0.50 value'),
              _infoRow('Earn', 'By completing health activities'),
              _infoRow('Spend', 'On bookings, medicines & services'),
              _infoRow('Expiry', 'Unused coins may expire after 90 days'),
              _infoRow('Refund', 'Coins refunded on cancellations'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D2939), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Got it', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600, fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(color: Color(0xFF344054), fontSize: 13))),
        ],
      ),
    );
  }
}
