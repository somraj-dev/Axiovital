import 'package:flutter/material.dart';
import 'cart_provider.dart';
import 'confirm_location_page.dart';

class SearchLocalityPage extends StatefulWidget {
  final Address? editAddress;
  const SearchLocalityPage({super.key, this.editAddress});

  @override
  State<SearchLocalityPage> createState() => _SearchLocalityPageState();
}

class _SearchLocalityPageState extends State<SearchLocalityPage> {
  final TextEditingController _searchController = TextEditingController();

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
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search for your locality, area, street...',
            hintStyle: TextStyle(color: Color(0xFF98A2B3), fontSize: 15),
            border: InputBorder.none,
          ),
          onSubmitted: (val) {
            if (val.isNotEmpty) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmLocationPage(query: val, editAddress: widget.editAddress)));
            }
          },
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          // Info Banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF3), // Light green
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF027A48), size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Color(0xFF027A48), fontSize: 13, height: 1.4),
                      children: [
                        TextSpan(text: 'Your delivery area can be a '),
                        TextSpan(text: 'building name, locality, landmark, street name', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ', etc'),
                      ],
                    ),
                  ),
                ),
                const Icon(Icons.close, color: Color(0xFF027A48), size: 18),
              ],
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.my_location, color: Color(0xFFFF5247)),
            title: const Text('Use my current location', style: TextStyle(color: Color(0xFFFF5247), fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFFFF5247)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmLocationPage(useCurrentLocation: true, editAddress: widget.editAddress)));
            },
          ),
        ],
      ),
    );
  }
}
