import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum PostType { poster, plain }
enum PostCategory { virusAlert, fitness, immunity, mentalHealth, whoUpdate, govAdvisory, doctorInsight, nutrition }

class Publisher {
  final String id;
  final String name;
  final String avatarUrl;
  final String role; // 'AxioVital Admin', 'Verified Doctor', 'WHO', 'Health Ministry'
  final bool isVerified;

  Publisher({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.role,
    this.isVerified = true,
  });
}

class PostComment {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String text;
  final DateTime timestamp;
  final List<PostComment> replies;

  PostComment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.text,
    required this.timestamp,
    this.replies = const [],
  });
}

class HealthPost {
  final String id;
  final PostType type;
  final String title;
  final String description;
  final String? mediaUrl;
  final PostCategory category;
  final Publisher publisher;
  final DateTime createdAt;
  int likesCount;
  int commentsCount;
  int sharesCount;
  int viewsCount;
  bool isLiked;
  bool isSaved;
  List<PostComment> comments;

  HealthPost({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.mediaUrl,
    required this.category,
    required this.publisher,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.viewsCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.comments = const [],
  });
}

class HealthFeedProvider extends ChangeNotifier {
  List<HealthPost> _posts = [];
  List<HealthPost> get posts => _filteredPosts;
  List<HealthPost> get allPosts => _posts;
  List<HealthPost> get savedPosts => _posts.where((p) => p.isSaved).toList();

  PostCategory? _activeFilter;
  PostCategory? get activeFilter => _activeFilter;

  bool _showSavedOnly = false;
  bool get showSavedOnly => _showSavedOnly;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<HealthPost> get _filteredPosts {
    var result = _posts;
    if (_showSavedOnly) {
      result = result.where((p) => p.isSaved).toList();
    }
    if (_activeFilter != null) {
      result = result.where((p) => p.category == _activeFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((p) => 
        p.title.toLowerCase().contains(q) || 
        p.description.toLowerCase().contains(q) ||
        p.publisher.name.toLowerCase().contains(q)
      ).toList();
    }
    return result;
  }

  // Publishers
  final _axioVital = Publisher(id: 'pub_axio', name: 'AxioVital', avatarUrl: 'https://cdn-icons-png.flaticon.com/512/2966/2966327.png', role: 'AxioVital Admin');
  final _who = Publisher(id: 'pub_who', name: 'WHO', avatarUrl: 'https://cdn-icons-png.flaticon.com/512/5968/5968817.png', role: 'World Health Org');
  final _drSaad = Publisher(id: 'pub_dr1', name: 'Dr. Saad Shaikh', avatarUrl: 'https://cdn-icons-png.flaticon.com/512/3774/3774299.png', role: 'Verified Doctor');
  final _ministry = Publisher(id: 'pub_moh', name: 'Health Ministry', avatarUrl: 'https://cdn-icons-png.flaticon.com/512/3176/3176382.png', role: 'Government Advisory');

  HealthFeedProvider() {
    _initMockFeed();
  }

  void _initMockFeed() {
    _posts = [
      HealthPost(
        id: 'hp_1',
        type: PostType.poster,
        title: '⚠️ New Virus Alert: H5N1 Bird Flu Strain Detected',
        description: 'A new highly pathogenic avian influenza strain has been detected in 3 states. Health authorities urge caution when handling poultry products. Symptoms include high fever, respiratory distress, and muscle pain.\n\nPreventive measures:\n• Avoid contact with wild birds\n• Cook poultry thoroughly to 165°F\n• Wash hands frequently\n• Report unusual bird deaths to local authorities\n\nThe WHO has classified this as a Level 3 concern. AxioVital will provide real-time updates as the situation develops.',
        mediaUrl: 'https://cdn-icons-png.flaticon.com/512/2913/2913520.png',
        category: PostCategory.virusAlert,
        publisher: _axioVital,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 1247,
        commentsCount: 89,
        sharesCount: 432,
        viewsCount: 15600,
        comments: [
          PostComment(id: 'c1', userId: 'u1', userName: 'Priya K.', userAvatar: 'https://cdn-icons-png.flaticon.com/512/3135/3135768.png', text: 'Thank you for the early warning! Shared with my family.', timestamp: DateTime.now().subtract(const Duration(hours: 1))),
          PostComment(id: 'c2', userId: 'u2', userName: 'Rahul M.', userAvatar: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png', text: 'Is there a vaccine available for this strain?', timestamp: DateTime.now().subtract(const Duration(minutes: 45))),
        ],
      ),
      HealthPost(
        id: 'hp_2',
        type: PostType.plain,
        title: '5 Morning Habits That Boost Your Immunity Naturally',
        description: 'Your immune system is your body\'s first line of defense. Here are 5 scientifically proven morning habits:\n\n1. Drink warm lemon water on an empty stomach\n2. Practice 10 minutes of deep breathing\n3. Get 15 minutes of morning sunlight for Vitamin D\n4. Eat a protein-rich breakfast\n5. Take a cold shower (even 30 seconds helps!)\n\nConsistency is key — try these for 21 days and notice the difference.',
        category: PostCategory.immunity,
        publisher: _drSaad,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        likesCount: 834,
        commentsCount: 56,
        sharesCount: 210,
        viewsCount: 8900,
        comments: [
          PostComment(id: 'c3', userId: 'u3', userName: 'Anita S.', userAvatar: 'https://cdn-icons-png.flaticon.com/512/3135/3135768.png', text: 'The lemon water tip actually works! Been doing it for a month.', timestamp: DateTime.now().subtract(const Duration(hours: 4))),
        ],
      ),
      HealthPost(
        id: 'hp_3',
        type: PostType.poster,
        title: '🏥 WHO: Global Measles Cases Rise 79% in 2026',
        description: 'The World Health Organization has reported a dramatic 79% increase in global measles cases compared to last year. Regions with low vaccination coverage are most affected.\n\nKey findings:\n• 10.3 million children missed their first measles vaccine dose\n• Africa and South-East Asia most impacted\n• Two doses of MMR vaccine are 97% effective\n\nAction required: Check your vaccination status on AxioVital Health Passport and schedule your booster if needed.',
        mediaUrl: 'https://cdn-icons-png.flaticon.com/512/2966/2966334.png',
        category: PostCategory.whoUpdate,
        publisher: _who,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        likesCount: 2100,
        commentsCount: 134,
        sharesCount: 876,
        viewsCount: 32400,
      ),
      HealthPost(
        id: 'hp_4',
        type: PostType.plain,
        title: 'Managing Anxiety: A Doctor\'s Guide to Daily Calm',
        description: 'Anxiety is the most common mental health condition worldwide. As a practicing psychiatrist, here are my top recommendations:\n\n• Box Breathing: Inhale 4 sec → Hold 4 sec → Exhale 4 sec → Hold 4 sec\n• Limit screen time 1 hour before bed\n• Journal 3 things you\'re grateful for each night\n• Move your body for at least 20 minutes daily\n• Talk to someone — professional help is a sign of strength, not weakness\n\nRemember: Your mental health matters as much as your physical health.',
        category: PostCategory.mentalHealth,
        publisher: _drSaad,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likesCount: 1456,
        commentsCount: 98,
        sharesCount: 345,
        viewsCount: 12800,
      ),
      HealthPost(
        id: 'hp_5',
        type: PostType.poster,
        title: '🇮🇳 Government Advisory: Heatwave Precautions for April',
        description: 'The Ministry of Health has issued a heatwave advisory for northern and central India for April 2026.\n\nDo\'s:\n• Drink 3-4 liters of water daily\n• Wear loose, light-colored cotton clothing\n• Use ORS if experiencing dehydration\n• Stay indoors between 12 PM and 4 PM\n\nDon\'ts:\n• Avoid heavy meals during peak heat hours\n• Don\'t leave children or elderly in parked vehicles\n• Avoid strenuous outdoor exercise\n\nEmergency: Call 108 for heatstroke symptoms.',
        mediaUrl: 'https://cdn-icons-png.flaticon.com/512/1779/1779940.png',
        category: PostCategory.govAdvisory,
        publisher: _ministry,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        likesCount: 3200,
        commentsCount: 201,
        sharesCount: 1560,
        viewsCount: 45000,
      ),
      HealthPost(
        id: 'hp_6',
        type: PostType.plain,
        title: 'Why Walking 10,000 Steps is Overrated — What Science Actually Says',
        description: 'The 10,000-step goal was actually created as a marketing campaign for a Japanese pedometer in the 1960s. Recent research from Harvard Medical School shows:\n\n• Health benefits plateau around 7,500 steps/day\n• Intensity matters more than total steps\n• 4,400 steps/day already reduces mortality risk by 41%\n\nFocus on consistent movement throughout the day rather than hitting an arbitrary number. Your AxioVital step tracker can help you find your personal sweet spot.',
        category: PostCategory.fitness,
        publisher: _axioVital,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        likesCount: 567,
        commentsCount: 42,
        sharesCount: 189,
        viewsCount: 6700,
      ),
    ];
  }

  void toggleLike(String postId) {
    final post = _posts.firstWhere((p) => p.id == postId);
    post.isLiked = !post.isLiked;
    post.likesCount += post.isLiked ? 1 : -1;
    notifyListeners();
  }

  void toggleSave(String postId) {
    final post = _posts.firstWhere((p) => p.id == postId);
    post.isSaved = !post.isSaved;
    notifyListeners();
  }

  void addComment(String postId, String text) {
    final post = _posts.firstWhere((p) => p.id == postId);
    final comment = PostComment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user_me',
      userName: 'You',
      userAvatar: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      text: text,
      timestamp: DateTime.now(),
    );
    post.comments = [comment, ...post.comments];
    post.commentsCount++;
    notifyListeners();
  }

  void sharePost(String postId) {
    final post = _posts.firstWhere((p) => p.id == postId);
    post.sharesCount++;
    notifyListeners();
  }

  void incrementView(String postId) {
    final post = _posts.firstWhere((p) => p.id == postId);
    post.viewsCount++;
    notifyListeners();
  }

  void setFilter(PostCategory? category) {
    _activeFilter = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSavedFilter() {
    _showSavedOnly = !_showSavedOnly;
    notifyListeners();
  }

  String categoryLabel(PostCategory cat) {
    switch (cat) {
      case PostCategory.virusAlert: return '🦠 Virus Alert';
      case PostCategory.fitness: return '🏃 Fitness';
      case PostCategory.immunity: return '🛡️ Immunity';
      case PostCategory.mentalHealth: return '🧠 Mental Health';
      case PostCategory.whoUpdate: return '🌍 WHO Update';
      case PostCategory.govAdvisory: return '🏛️ Gov Advisory';
      case PostCategory.doctorInsight: return '🩺 Doctor Insight';
      case PostCategory.nutrition: return '🥗 Nutrition';
    }
  }

  Color categoryColor(PostCategory cat) {
    switch (cat) {
      case PostCategory.virusAlert: return const Color(0xFFDC2626);
      case PostCategory.fitness: return const Color(0xFF16A34A);
      case PostCategory.immunity: return const Color(0xFF2563EB);
      case PostCategory.mentalHealth: return const Color(0xFF9333EA);
      case PostCategory.whoUpdate: return const Color(0xFF0891B2);
      case PostCategory.govAdvisory: return const Color(0xFFD97706);
      case PostCategory.doctorInsight: return const Color(0xFF0D9488);
      case PostCategory.nutrition: return const Color(0xFFE11D48);
    }
  }
}
