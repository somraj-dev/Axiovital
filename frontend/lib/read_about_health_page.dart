import 'package:flutter/material.dart';

class ReadAboutHealthPage extends StatelessWidget {
  const ReadAboutHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1D2939), // Dark slate/blue
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Read about health',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              Tab(text: 'Health Articles'),
              Tab(text: 'Health Q&A'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HealthArticlesView(),
            HealthQAView(),
          ],
        ),
      ),
    );
  }
}

class HealthArticlesView extends StatelessWidget {
  const HealthArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for any health topic ...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1570EF)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                ),
              ),
            ),
          ),

          // Personalize Feed Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEAECF0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personalize your feed',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF101828)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose health interests to get personalised article recommendations on your feed',
                    style: TextStyle(fontSize: 14, color: Color(0xFF475467)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('REMIND LATER', style: TextStyle(color: Color(0xFF1570EF), fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () {},
                        child: const Text('ADD INTERESTS', style: TextStyle(color: Color(0xFF1570EF), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: Text(
              'Recommended for you',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF475467)),
            ),
          ),

          // Article List
          _buildArticleCard(
            category: 'Yoga',
            title: 'The Yoga-Roga!',
            author: 'Dr.N Srinivas, Dentist',
            likes: 5,
            imageUrl: 'https://ui-avatars.com/api/?name=Yoga&background=E0F2FE&color=0369A1&size=200',
          ),
          _buildArticleCard(
            category: 'Dental care',
            title: 'Oral Detox: Oil Pulling Therapy',
            author: 'Dr.Shefali Jain Sood, Dentist',
            likes: 9,
            imageUrl: 'https://ui-avatars.com/api/?name=Dental&background=FEF3C7&color=92400E&size=200',
          ),
          _buildArticleCard(
            category: 'Sports',
            title: 'Did you know sunblock could help prevent skin rashes?',
            author: "Women's Health",
            likes: 12,
            imageUrl: 'https://ui-avatars.com/api/?name=Sports&background=D1FAE5&color=065F46&size=200',
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard({
    required String category,
    required String title,
    required String author,
    required int likes,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF101828), height: 1.3),
                ),
                const SizedBox(height: 4),
                Text(
                  author,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF475467)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.favorite_border, size: 18, color: Color(0xFF667085)),
                    const SizedBox(width: 6),
                    Text('$likes', style: const TextStyle(color: Color(0xFF667085), fontSize: 13)),
                    const SizedBox(width: 20),
                    const Icon(Icons.share_outlined, size: 18, color: Color(0xFF667085)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class HealthQAView extends StatelessWidget {
  const HealthQAView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by problem or symptom',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1570EF)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                ),
              ),
            ),
          ),

          // Filter Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: const [
                Text(
                  'Filter questions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF101828)),
                ),
                Spacer(),
                Icon(Icons.chevron_right, color: Color(0xFF667085)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEAECF0)),

          // Question List
          _buildQuestionItem(
            title: 'Report check',
            snippet: 'Hi..please help me with the report..currently taking thyronorm 50 but still tsh is 5.7 with no...',
            time: '1 minute ago',
            views: 35,
          ),
          _buildQuestionItem(
            title: 'Overdose vitamin d3',
            snippet: 'My ent suggest me vitamin D3 60k.IU alternative days for 15 days my vitamin d level...',
            time: '1 minute ago',
            views: 78,
          ),
          _buildQuestionItem(
            title: 'Vitamin B complex supplements',
            snippet: 'Which vitamin B complex supplements I should take and for how long, like any recom...',
            time: '2 minutes ago',
            views: 34,
          ),
          _buildQuestionItem(
            title: 'Rabies and die and can\'t focus on study',
            snippet: 'Dear Sir/Madam I Had taken 9/11/2025 Intermuscular ARV Vaccine ( please check th...',
            time: '2 minutes ago',
            views: 41,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionItem({
    required String title,
    required String snippet,
    required String time,
    required int views,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_pin, color: Color(0xFF1570EF), size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF101828)),
                ),
                const SizedBox(height: 6),
                Text(
                  snippet,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF667085), height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF98A2B3))),
                    const SizedBox(width: 12),
                    const Icon(Icons.circle, size: 4, color: Color(0xFF98A2B3)),
                    const SizedBox(width: 12),
                    Text('$views Views', style: const TextStyle(fontSize: 12, color: Color(0xFF98A2B3))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
