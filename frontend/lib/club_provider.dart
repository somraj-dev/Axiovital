import 'package:flutter/foundation.dart';

class ClubProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _clubs = [
    {
      'title': 'Cycling Club',
      'members': 24,
      'image': 'https://images.unsplash.com/photo-1541625602330-2277a1cd1f59?q=80&w=2070&auto=format&fit=crop',
      'description': 'Join cycling club for engaging and bonding with new friends with same hobby.',
      'categories': ['Benefits', 'Health', 'Sports'],
      'about': 'A vibrant and inclusive group of cycling enthusiasts passionate about promoting a healthy lifestyle, environmental awareness, and club bonding through cycling.'
    },
    {
      'title': 'Podcast Club',
      'members': 10,
      'image': 'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?q=80&w=1974&auto=format&fit=crop',
      'description': 'Tips and tricks for podcasting. Join us to learn how to grow your audience.',
      'categories': ['Education', 'Media'],
      'about': 'A home for audio creators and listeners. We share equipment tips, editing hacks, and hosting strategies.'
    },
    {
      'title': 'Yoga Retreat',
      'members': 156,
      'image': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=2020&auto=format&fit=crop',
      'description': 'Daily yoga sessions for mental clarity and physical strength.',
      'categories': ['Health', 'Wellness'],
      'about': 'Find your inner peace with our global yoga club. We offer live sessions, guided meditation, and wellness retreats.'
    },
  ];

  List<Map<String, dynamic>> get clubs => List.unmodifiable(_clubs);

  void addClub(Map<String, dynamic> club) {
    _clubs.insert(0, club);
    notifyListeners();
  }
}
