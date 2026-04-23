import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'search_provider.dart';
import 'widgets/axio_card.dart';
import 'theme.dart';
import 'other_user_profile_page.dart';
import 'food_analysis_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(context, searchProvider),
            Expanded(
              child: searchProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildSearchResults(context, searchProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context, SearchProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(Icons.search, size: 20, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: provider.onSearchChanged,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        provider.clearSearch();
                      },
                      child: Icon(Icons.cancel, size: 20, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send_rounded, color: theme.colorScheme.onSurface),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FoodAnalysisPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, SearchProvider provider) {
    if (provider.results.isEmpty && !provider.isLoading) {
      if (_searchController.text.isEmpty) {
        return _buildRecentSearches();
      }
      return _buildEmptyState();
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (provider.topResults.isNotEmpty) ...[
          _buildSectionHeader('🔝 Top Results', context),
          ...provider.topResults.map((r) => _buildResultItem(r, context)),
          const SizedBox(height: 16),
        ],
        if (provider.doctors.isNotEmpty) ...[
          _buildSectionHeader('👨‍⚕️ Doctors', context),
          ...provider.doctors.map((r) => _buildResultItem(r, context)),
          const SizedBox(height: 16),
        ],
        if (provider.medicines.isNotEmpty) ...[
          _buildSectionHeader('💊 Medicines', context),
          ...provider.medicines.map((r) => _buildResultItem(r, context)),
          const SizedBox(height: 16),
        ],
        if (provider.labs.isNotEmpty) ...[
          _buildSectionHeader('🧪 Labs', context),
          ...provider.labs.map((r) => _buildResultItem(r, context)),
          const SizedBox(height: 16),
        ],
        if (provider.users.isNotEmpty) ...[
          _buildSectionHeader('👤 People', context),
          ...provider.users.map((r) => _buildResultItem(r, context)),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildResultItem(SearchResult result, BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: result.type == 'user'
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtherUserProfilePage(
                    userId: result.id,
                    name: result.name,
                    subtitle: result.subtitle,
                    avatarUrl: result.avatarUrl,
                  ),
                ),
              );
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Avatar
            Container(
              padding: result.id.contains('mock') ? const EdgeInsets.all(2) : EdgeInsets.zero,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: result.id.contains('mock') 
                    ? const LinearGradient(
                        colors: [Color(0xFFF9CE34), Color(0xFFEE2A7B), Color(0xFF6228D7)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      )
                    : null,
              ),
              child: Container(
                padding: result.id.contains('mock') ? const EdgeInsets.all(2) : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    result.avatarUrl ?? 'https://ui-avatars.com/api/?name=${result.name}&background=903050&color=fff',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        result.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      if (result.rating > 4.5) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, color: Colors.blue, size: 14),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    result.subtitle,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Optional Rating/Connect for others
            if (result.type != 'user')
              Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3))
            else if (result.id.contains('mock'))
               IconButton(
                 icon: const Icon(Icons.close, size: 18),
                 color: theme.colorScheme.onSurface.withOpacity(0.4),
                 onPressed: () {},
               ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'doctor': return Icons.local_hospital_rounded;
      case 'medicine': return Icons.medication_rounded;
      case 'lab': return Icons.science_rounded;
      case 'user': return Icons.person_rounded;
      default: return Icons.search;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'doctor': return Colors.blue;
      case 'medicine': return Colors.green;
      case 'lab': return Colors.orange;
      case 'user': return Colors.purple;
      default: return Colors.grey;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('No results found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Try adjusting your search query', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text('Recent Searches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        _buildRecentItem('Dr. Julian Vance'),
        _buildRecentItem('Vitamin C Zinc'),
        _buildRecentItem('Blood test Bhopal'),
        _buildRecentItem('Paracetamol'),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text('Trending Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildTrendChip('Heart Specialist'),
              _buildTrendChip('CBC Test'),
              _buildTrendChip('Protein Powder'),
              _buildTrendChip('Health Insurance'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentItem(String text) {
    return ListTile(
      leading: const Icon(Icons.history, color: Colors.grey),
      title: Text(text),
      trailing: const Icon(Icons.arrow_outward, size: 18, color: Colors.grey),
      onTap: () {
        _searchController.text = text;
        Provider.of<SearchProvider>(context, listen: false).performSearch(text);
      },
    );
  }

  Widget _buildTrendChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text),
        onPressed: () {
          _searchController.text = text;
          Provider.of<SearchProvider>(context, listen: false).performSearch(text);
        },
      ),
    );
  }
}
