import 'package:flutter/material.dart';

class FamilyHubPage extends StatefulWidget {
  const FamilyHubPage({super.key});

  @override
  State<FamilyHubPage> createState() => _FamilyHubPageState();
}

class _FamilyHubPageState extends State<FamilyHubPage> {
  String _selectedMember = 'Family View';

  double _getPointerOffset() {
    switch (_selectedMember) {
      case 'Family View':
        return 42.0;
      case 'Sathi':
        return 135.0;
      case 'Somraj':
        return 219.0;
      default:
        return 42.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context),
            const SizedBox(height: 16),
            _buildYourFamilySection(),
            // Remove the 24 spacing here because we use translation/overlap for the pointer
            if (_selectedMember == 'Family View') ...[
              _buildLeaderboardSection(),
              const SizedBox(height: 40),
              _buildHealthOverviewSection(),
              const SizedBox(height: 48),
              _buildBodySystemSection(),
              const SizedBox(height: 40),
              _buildInsightsPromo(context),
              const SizedBox(height: 48),
              const Center(
                child: Text(
                  'Family: Always Together,\nForever',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ] else ...[
              _buildIndividualMemberContent(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIndividualMemberContent(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.5),
          color: const Color(0xFF45308A),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Health documents', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Everything your health history needs, organised', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: _buildDocCard('0', 'Lab reports')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDocCard('0', 'Prescriptions')),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Vaccines', style: TextStyle(color: Colors.white, fontSize: 16)),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(width: 24, height: 8, decoration: BoxDecoration(color: const Color(0xFF7CB342), borderRadius: BorderRadius.circular(2))),
                        Container(width: 8, height: 24, decoration: BoxDecoration(color: const Color(0xFF7CB342), borderRadius: BorderRadius.circular(2))),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Upload more documents', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Lab report, prescription', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        // The Downward White Triangular Tab
        Positioned(
          top: -1,
          left: _getPointerOffset(),
          child: ClipPath(
            clipper: _TriangleClipper(),
            child: Container(
              width: 24,
              height: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocCard(String count, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(count, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Background Gradient Area
        Container(
          width: double.infinity,
          height: size.height * 0.45,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8E9FE), Color(0xFFE0E1FC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Overlain Image (Substitute with a network image that closely resembles the vibe)
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0), // Above the purple bar
              child: Image.network(
                'https://cdn3d.iconscout.com/3d/premium/thumb/family-4993685-4161805.png', // Placeholder 3D family
                fit: BoxFit.contain,
                height: size.height * 0.28,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),
        ),
        // The Top Text
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Family', style: TextStyle(color: Color(0xFF45308A), fontSize: 36, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Text('hub', style: TextStyle(color: Color(0xFF45308A), fontSize: 36, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ),
        // The Dark Purple Bottom Bar Wave
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: _WaveClipper(),
            child: Container(
              height: 70,
              color: const Color(0xFF45308A),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0), // push slightly up to account for wave
                  child: Text(
                    "Track family's health data in one view",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildYourFamilySection() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('Your family', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.edit_outlined, size: 16),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to top
              children: [
                // Family View
                GestureDetector(
                  onTap: () => setState(() => _selectedMember = 'Family View'),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: _selectedMember == 'Family View' ? const Color(0xFFF3E5F5) : Colors.transparent,
                        child: Icon(Icons.people, color: _selectedMember == 'Family View' ? const Color(0xFF7B1FA2) : Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text('Family View', style: TextStyle(fontWeight: _selectedMember == 'Family View' ? FontWeight.bold : FontWeight.normal, fontSize: 13, color: _selectedMember == 'Family View' ? Colors.black : Colors.black54)),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                Container(height: 50, width: 1, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10)),
                GestureDetector(
                  onTap: () => setState(() => _selectedMember = 'Sathi'),
                  child: _buildFamilyMemberAvatar('Sathi', 'https://ui-avatars.com/api/?name=Sathi&background=random', _selectedMember == 'Sathi'),
                ),
                const SizedBox(width: 32),
                GestureDetector(
                  onTap: () => setState(() => _selectedMember = 'Somraj'),
                  child: _buildFamilyMemberAvatar('Somraj', 'https://ui-avatars.com/api/?name=Somraj&background=random', _selectedMember == 'Somraj'),
                ),
                const SizedBox(width: 32),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: const Icon(Icons.add, color: Colors.grey, size: 26),
                    ),
                    const SizedBox(height: 8),
                    const Text('Add\nmember', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFamilyMemberAvatar(String name, String url, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(url),
        ),
        const SizedBox(height: 8),
        Text(name, style: TextStyle(color: isSelected ? Colors.black : Colors.black54, fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildLeaderboardSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFF45308A),
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              const Text('LEADERBOARD', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: 3)),
              const SizedBox(height: 8),
              const Text('Your top 3 family members', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 48),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 2nd Place: Somraj
                  _buildPodiumStep(
                    name: 'Somraj',
                    avatarUrl: 'https://ui-avatars.com/api/?name=Somraj&background=random',
                    height: 100,
                    color: const Color(0xFFE8E4FD),
                    locked: true,
                  ),
                  // 1st Place: Sathi
                  _buildPodiumStep(
                    name: 'Sathi',
                    avatarUrl: 'https://ui-avatars.com/api/?name=Sathi&background=random',
                    height: 140,
                    color: const Color(0xFFD6CFFC),
                    locked: true,
                  ),
                  // 3rd Place: Add member
                  _buildPodiumStep(
                    name: 'Add member',
                    icon: Icons.person,
                    height: 80,
                    color: const Color(0xFFF3F1FE),
                    locked: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        // The Downward White Triangular Tab perfectly positioned under "Family View"
        Positioned(
          top: -1,
          left: _getPointerOffset(),
          child: ClipPath(
            clipper: _TriangleClipper(),
            child: Container(
              width: 24,
              height: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumStep({
    required String name,
    String? avatarUrl,
    IconData? icon,
    required double height,
    required Color color,
    required bool locked,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (avatarUrl != null)
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(avatarUrl),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey.shade300,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ),
        const SizedBox(height: 8),
        Row(
           mainAxisSize: MainAxisSize.min,
           children: [
             Text(name, style: const TextStyle(color: Colors.white, fontSize: 13)),
             const SizedBox(width: 4),
             const Icon(Icons.chevron_right, size: 14, color: Colors.white),
           ],
        ),
        const SizedBox(height: 16),
        Container(
          width: 90,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            boxShadow: const [
              BoxShadow(color: Colors.black12, offset: Offset(-1, 0), blurRadius: 2),
            ]
          ),
          child: Center(
            child: locked ? _buildLockIcon() : const SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildLockIcon() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF45308A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.lock, color: Colors.white, size: 12),
    );
  }

  Widget _buildSectionTitleWithLines(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
          ),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildHealthOverviewSection() {
    return Column(
      children: [
        _buildSectionTitleWithLines('HEALTH OVERVIEW'),
        const SizedBox(height: 8),
        const Text('View health status of all family members', style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildHealthOverviewCard('Sathi', 'https://ui-avatars.com/api/?name=Sathi&background=random'),
              const SizedBox(width: 16),
              _buildHealthOverviewCard('Somraj', 'https://ui-avatars.com/api/?name=Somraj&background=random'),
              const SizedBox(width: 16),
              _buildAddMemberCard(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildHealthOverviewCard(String name, String avatarUrl) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade50, blurRadius: 10, offset: const Offset(0, 4)),
        ]
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                 padding: const EdgeInsets.all(2),
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   border: Border.all(color: Colors.grey.shade300, width: 1),
                 ),
                 child: CircleAvatar(
                   radius: 30,
                   backgroundImage: NetworkImage(avatarUrl),
                 ),
              ),
              // Lock Badge
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B4EE6),
                     shape: BoxShape.circle,
                     border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.lock, size: 14, color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 16),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Percentile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 2),
          const Text('is not available', style: TextStyle(color: Colors.black45, fontSize: 12)),
          const SizedBox(height: 24),
          Container(
             width: double.infinity,
             padding: const EdgeInsets.symmetric(vertical: 12),
             decoration: const BoxDecoration(
               color: Color(0xFFF9FAFB),
               borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: const [
                 Text('Upload Report', style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.bold)),
                 SizedBox(width: 4),
                 Icon(Icons.chevron_right, size: 16, color: Colors.black54),
               ],
             ),
          )
        ],
      ),
    );
  }

  Widget _buildAddMemberCard() {
     return Container(
      width: 160,
      height: 255, // Exact match height footprint to side cards
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
         children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, color: Colors.grey, size: 40),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B4EE6),
                     shape: BoxShape.circle,
                     border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.lock, size: 14, color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Add member', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 16, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Create a new member in health insights', textAlign: TextAlign.center, style: TextStyle(color: Colors.black45, fontSize: 12)),
          ),
         ],
      ),
    );
  }

  Widget _buildBodySystemSection() {
    return Column(
      children: [
        _buildSectionTitleWithLines('BODY SYSTEM'),
        const SizedBox(height: 8),
        const Text("Track family's health across different body systems", style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 32),
        _buildBodySystemRow('Sathi', 'https://ui-avatars.com/api/?name=Sathi&background=random'),
        Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
           child: _buildDottedLine(),
        ),
        _buildBodySystemRow('Somraj', 'https://ui-avatars.com/api/?name=Somraj&background=random'),
      ],
    );
  }

  Widget _buildDottedLine() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.black26)),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }

  Widget _buildBodySystemRow(String name, String avatarUrl) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                 backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     children: [
                       Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                       const SizedBox(width: 4),
                       const Icon(Icons.chevron_right, size: 16),
                     ],
                   ),
                   const Text('Upload a report', style: TextStyle(color: Colors.black45, fontSize: 12)),
                 ],
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildBodySystemCard('Heart health'),
               const SizedBox(width: 16),
              _buildBodySystemCard('Blood health'),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBodySystemCard(String title) {
    return Container(
       width: 160,
       padding: const EdgeInsets.symmetric(vertical: 20),
       decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
       ),
       child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            _buildLockIcon(),
          ],
       ),
    );
  }

  Widget _buildInsightsPromo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
             BoxShadow(color: Colors.grey.shade50, blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
             Expanded(
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Turn your lab report', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const Text('into AI insights', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'serif')),
                    const SizedBox(height: 24),
                    Container(
                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                       decoration: BoxDecoration(
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                       ),
                       child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                             Text('Upload Report', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13)),
                             SizedBox(width: 4),
                             Icon(Icons.chevron_right, color: Colors.red, size: 16),
                          ],
                       ),
                    )
                  ],
               ),
             ),
             // Promo graphic placeholder layout matching the screenshot closely
             Container(
                width: 110,
                height: 70,
                decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(8),
                   border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Cholesterol - LDL', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold)),
                              Text('Range: <100 mg/dL', style: TextStyle(fontSize: 5, color: Colors.black45)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Align(alignment: Alignment.centerLeft, child: Text('132 mg/dL', style: TextStyle(fontSize: 8, color: Colors.red, fontWeight: FontWeight.bold))),
                        ),
                        const SizedBox(height: 4),
                        Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                              Container(height: 4, width: 20, color: Colors.green),
                              Container(height: 4, width: 20, color: Colors.orange),
                              Container(height: 4, width: 20, color: Colors.red),
                           ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          color: const Color(0xFFF9FAFB),
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: const Text('  AI Clinician summary', style: TextStyle(fontSize: 6, color: Colors.blue, fontWeight: FontWeight.bold)),
                        )
                     ],
                  ),
                ),
             )
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for the wavy bottom on the hero section
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 10);

    // Create a series of small arcs matching the screenshot's cloud-like bottom
    double waveWidth = size.width / 15;
    for (int i = 0; i < 15; i++) {
       path.quadraticBezierTo(
         (i * waveWidth) + waveWidth / 2, size.height, 
         (i + 1) * waveWidth, size.height - 10
       );
    }

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom Clipper for the triangle tab downward
class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
