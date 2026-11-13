import 'package:flutter/material.dart';
import 'my_visits_page.dart';

class BalanceHistoryPage extends StatelessWidget {
  const BalanceHistoryPage({super.key});

  void _openVisits(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MyVisitsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E11),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // 1. Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Balance & History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Accounts Heading
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Accounts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Accounts Carousel
              _buildAccountsRow(context),

              const SizedBox(height: 30),

              // 3. Portfolio Heading
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Portfolio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Portfolio Cards Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildPortfolioRow(),
              ),

              const SizedBox(height: 30),

              // 4. Payment History Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildPaymentHistoryHeader(),
              ),
              const SizedBox(height: 14),

              // Payment History Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildPaymentHistoryCard(context),
              ),

              const SizedBox(height: 28),

              // 5. Brand Footer
              _buildBrandFooter(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. ACCOUNTS ROW
  // ─────────────────────────────────────────────────────────────
  Widget _buildAccountsRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // SBI Bank
          _buildAccountCard(
            context: context,
            title: 'SBI Bank',
            subtitle: 'Saving A/c: 4100',
            logo: _buildSbiCircleLogo(size: 32),
            onTap: () => _openVisits(context),
          ),
          const SizedBox(width: 14),

          // Airtel Payments Bank
          _buildAccountCard(
            context: context,
            title: 'Airtel Pay...',
            subtitle: 'Saving A/c: 7136',
            logo: _buildAirtelCircleLogo(size: 32),
            onTap: () => _openVisits(context),
          ),
          const SizedBox(width: 14),

          // Kotak Bank
          _buildAccountCard(
            context: context,
            title: 'Kotak Bank',
            subtitle: 'Saving A/c: 8829',
            logo: _buildKotakCircleLogo(size: 32),
            onTap: () => _openVisits(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget logo,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 166,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1E24),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF282C35), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                logo,
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF9097A3),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFF2C313C),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Check Balance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. PORTFOLIO ROW
  // ─────────────────────────────────────────────────────────────
  Widget _buildPortfolioRow() {
    return Row(
      children: [
        // Gold Balance
        Expanded(
          flex: 12,
          child: Container(
            height: 98,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1E24),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF282C35), width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Gold Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '₹7.04',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                // Circular graphic with 3D Gold Bars
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFF242831),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _buildRealisticGoldBars(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Gold Coins
        Expanded(
          flex: 7,
          child: Container(
            height: 98,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1E24),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF282C35), width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Gold Coins',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '363',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. PAYMENT HISTORY HEADER
  // ─────────────────────────────────────────────────────────────
  Widget _buildPaymentHistoryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Payment History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            const Icon(Icons.search_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 18),
            _buildCustomTuneIcon(),
            const SizedBox(width: 18),
            const Icon(Icons.file_download_outlined, color: Colors.white, size: 24),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomTuneIcon() {
    return SizedBox(
      width: 22,
      height: 22,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _sliderLine(circleLeft: 4),
          _sliderLine(circleLeft: 12),
          _sliderLine(circleLeft: 7),
        ],
      ),
    );
  }

  Widget _sliderLine({required double circleLeft}) {
    return SizedBox(
      height: 5,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 1.8,
            color: Colors.white,
          ),
          Positioned(
            left: circleLeft,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. PAYMENT HISTORY CONTAINER
  // ─────────────────────────────────────────────────────────────
  Widget _buildPaymentHistoryCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B1E24),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF282C35), width: 0.8),
      ),
      child: Column(
        children: [
          // Month banner inside container
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'November 2026',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'Total Spent',
                          style: TextStyle(
                            color: Color(0xFF8E95A2),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '₹17,509',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFF29303D),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF388BFD),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF262A33)),

          // Transactions exactly from the screenshot
          _buildTransactionRow(
            context: context,
            title: 'Pari juice centre',
            time: 'Yesterday, 04:58 PM',
            tag: 'Food',
            amount: '- ₹150',
            onTap: () => _openVisits(context),
          ),
          const Divider(height: 1, color: Color(0xFF262A33), indent: 72),

          _buildTransactionRow(
            context: context,
            title: 'Ashish Gurjar',
            time: 'Yesterday, 04:45 PM',
            tag: 'Food',
            amount: '- ₹400',
            onTap: () => _openVisits(context),
          ),
          const Divider(height: 1, color: Color(0xFF262A33), indent: 72),

          _buildTransactionRow(
            context: context,
            title: 'Gaurav Dhaba',
            time: 'Yesterday, 01:20 PM',
            tag: 'Food',
            amount: '- ₹360',
            onTap: () => _openVisits(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow({
    required BuildContext context,
    required String title,
    required String time,
    required String tag,
    required String amount,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left circular icon with drink + burger
            _buildFoodIconAvatar(),
            const SizedBox(width: 14),

            // Middle Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Color(0xFF8E95A2),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 7),
                  // Tag pill with small icon
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF262A33),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE08A27),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          tag,
                          style: const TextStyle(
                            color: Color(0xFFD0D5DD),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'From ',
                      style: TextStyle(
                        color: Color(0xFF8E95A2),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    _buildMiniSbiBadge(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5. BRAND FOOTER
  // ─────────────────────────────────────────────────────────────
  Widget _buildBrandFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Paytm wordmark
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                ),
                children: [
                  TextSpan(
                    text: 'pay',
                    style: TextStyle(color: Color(0xFF00B9F5)),
                  ),
                  TextSpan(
                    text: 'tm',
                    style: TextStyle(color: Color(0xFF002970)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              height: 12,
              width: 1,
              color: const Color(0xFF475467),
            ),
            const SizedBox(width: 6),
            const Text(
              'Powered by ',
              style: TextStyle(
                color: Color(0xFF8E95A2),
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
            // UPI badge
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'UPI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
                Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFF039855),
                  size: 14,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Bottom home bar indicator matching iPhone/Android
        Container(
          width: 134,
          height: 4.5,
          decoration: BoxDecoration(
            color: const Color(0xFF475467),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 6. EXACT GRAPHICS & ICONS
  // ─────────────────────────────────────────────────────────────

  // Soft Yellow circular food avatar matching screenshot
  Widget _buildFoodIconAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFFFEF6E4),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Drink Cup with straw
              Positioned(
                right: 1,
                top: 0,
                child: Icon(
                  Icons.local_cafe_outlined,
                  size: 17,
                  color: const Color(0xFF243B53),
                ),
              ),
              // Burger / sandwich at the bottom left
              Positioned(
                left: 0,
                bottom: 1,
                child: Icon(
                  Icons.lunch_dining_outlined,
                  size: 17,
                  color: const Color(0xFF243B53),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Realistic SBI circular blue logo
  Widget _buildSbiCircleLogo({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF0072BB),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Center(
        child: Container(
          width: size * 0.42,
          height: size * 0.42,
          decoration: const BoxDecoration(
            color: Color(0xFF1B1E24),
            shape: BoxShape.circle,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size * 0.12,
              height: size * 0.22,
              color: const Color(0xFF0072BB),
            ),
          ),
        ),
      ),
    );
  }

  // Mini SBI badge for "From" row
  Widget _buildMiniSbiBadge() {
    return Container(
      width: 17,
      height: 17,
      decoration: BoxDecoration(
        color: const Color(0xFF0072BB),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Center(
        child: Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: Color(0xFF1B1E24),
            shape: BoxShape.circle,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 2,
              height: 3.5,
              color: const Color(0xFF0072BB),
            ),
          ),
        ),
      ),
    );
  }

  // Airtel Payments Bank logo
  Widget _buildAirtelCircleLogo({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: size * 0.8,
          height: size * 0.8,
          decoration: const BoxDecoration(
            color: Color(0xFFE60000),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'airtel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 7.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Kotak Bank logo
  Widget _buildKotakCircleLogo({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFED1B24),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.all_inclusive_rounded,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  // 3D Realistic Gold Bars
  Widget _buildRealisticGoldBars() {
    return SizedBox(
      width: 32,
      height: 26,
      child: Stack(
        children: [
          // Bottom Left bar
          Positioned(
            left: 0,
            bottom: 0,
            child: _singleGoldBar(width: 19, height: 10),
          ),
          // Bottom Right bar
          Positioned(
            left: 12,
            bottom: 0,
            child: _singleGoldBar(width: 19, height: 10),
          ),
          // Top Bar
          Positioned(
            left: 6,
            top: 1,
            child: _singleGoldBar(width: 19, height: 10),
          ),
        ],
      ),
    );
  }

  Widget _singleGoldBar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF275),
            Color(0xFFFFD700),
            Color(0xFFFFB300),
            Color(0xFFB8860B),
          ],
        ),
        borderRadius: BorderRadius.circular(2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
