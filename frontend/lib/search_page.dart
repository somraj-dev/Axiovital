import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'search_provider.dart';
import 'widgets/axio_card.dart';
import 'theme.dart';

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF903050), // Consistent medical maroon
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: provider.onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search doctors, medicines, labs...',
                      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      provider.clearSearch();
                    },
                  ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          if (provider.intent != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Searching for ${provider.intent}...',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
    return AxioCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getIconColor(result.type).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIcon(result.type), color: _getIconColor(result.type), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  result.subtitle,
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (result.price != null) ...[
                Text('₹${result.price!.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
              ],
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    result.rating.toString(),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (result.type == 'user')
                TextButton(
                  onPressed: () {},
                  child: const Text('Connect', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF903050))),
                ),
            ],
          ),
        ],
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
