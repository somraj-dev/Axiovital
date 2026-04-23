import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'health_feed_provider.dart';
import 'search_page.dart';

class ReadAboutHealthPage extends StatelessWidget {
  const ReadAboutHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HealthFeedProvider(),
      child: const _HealthFeedShell(),
    );
  }
}

class _HealthFeedShell extends StatefulWidget {
  const _HealthFeedShell();
  @override
  State<_HealthFeedShell> createState() => _HealthFeedShellState();
}

class _HealthFeedShellState extends State<_HealthFeedShell> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Consumer<HealthFeedProvider>(
          builder: (context, provider, _) {
            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(child: _buildHeader(context, provider)),
                // Search
                SliverToBoxAdapter(child: _buildSearchBar(provider)),
                // Category Chips
                SliverToBoxAdapter(child: _buildCategoryChips(provider)),
                // Posts
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (provider.posts.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(child: Text('No posts match your filter', style: TextStyle(color: Colors.black45, fontSize: 15))),
                        );
                      }
                      final post = provider.posts[index];
                      return _HealthPostCard(post: post);
                    },
                    childCount: provider.posts.isEmpty ? 1 : provider.posts.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HealthFeedProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1D2939)),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Health Updates', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1D2939))),
                Text('Trusted health intelligence', style: TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => provider.toggleSavedFilter(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: provider.showSavedOnly ? const Color(0xFF1D2939) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              child: Icon(
                provider.showSavedOnly ? Icons.bookmark : Icons.bookmark_outline, 
                size: 22, 
                color: provider.showSavedOnly ? Colors.white : const Color(0xFF1D2939)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(HealthFeedProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: TextField(
        controller: _searchCtrl,
        readOnly: true,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
        },
        decoration: InputDecoration(
          hintText: 'Search diseases, symptoms, topics...',
          hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF667085), size: 20),
          suffixIcon: _searchCtrl.text.isNotEmpty
            ? GestureDetector(
                onTap: () { _searchCtrl.clear(); provider.setSearchQuery(''); },
                child: const Icon(Icons.close, size: 18, color: Colors.black38),
              )
            : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(HealthFeedProvider provider) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _chipItem(provider, null, '🔥 All'),
          ...PostCategory.values.map((cat) => _chipItem(provider, cat, provider.categoryLabel(cat))),
        ],
      ),
    );
  }

  Widget _chipItem(HealthFeedProvider provider, PostCategory? cat, String label) {
    final isActive = provider.activeFilter == cat;
    return GestureDetector(
      onTap: () => provider.setFilter(cat),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1D2939) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? Colors.transparent : const Color(0xFFE5E7EB)),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : const Color(0xFF475467),
        )),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// HEALTH POST CARD
// ────────────────────────────────────────────────────────────────
class _HealthPostCard extends StatelessWidget {
  final HealthPost post;
  const _HealthPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HealthFeedProvider>();
    return GestureDetector(
      onTap: () {
        provider.incrementView(post.id);
        Navigator.push(context, MaterialPageRoute(builder: (_) =>
          ChangeNotifierProvider.value(value: provider, child: PostDetailScreen(postId: post.id)),
        ));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Publisher Header
            _buildPublisherHeader(context),

            // Category Tag
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: provider.categoryColor(post.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  provider.categoryLabel(post.category),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: provider.categoryColor(post.category)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Content Area
            if (post.type == PostType.poster)
              _buildPosterContent()
            else
              _buildPlainContent(),

            // Footer Actions
            _buildFooterActions(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildPublisherHeader(BuildContext context) {
    String timeAgo = _formatTimeAgo(post.createdAt);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundImage: NetworkImage(post.publisher.avatarUrl)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(post.publisher.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF1D2939)), overflow: TextOverflow.ellipsis),
                    ),
                    if (post.publisher.isVerified)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.verified, color: Color(0xFF2563EB), size: 16),
                      ),
                  ],
                ),
                Text('${post.publisher.role} • $timeAgo', style: const TextStyle(fontSize: 11, color: Colors.black38)),
              ],
            ),
          ),
          const Icon(Icons.more_horiz, color: Colors.black26, size: 20),
        ],
      ),
    );
  }

  Widget _buildPosterContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner area
        if (post.mediaUrl != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _posterGradientStart(post.category),
                  _posterGradientEnd(post.category),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Opacity(
                    opacity: 0.25,
                    child: Image.network(post.mediaUrl!, width: 80, height: 80,
                      errorBuilder: (c,e,s) => const SizedBox()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(post.title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900, height: 1.3), maxLines: 3, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            post.description, 
            maxLines: 3, 
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Color(0xFF475467), height: 1.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Read more...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue.shade700)),
        ),
      ],
    );
  }

  Widget _buildPlainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1D2939), height: 1.3)),
          const SizedBox(height: 8),
          Text(
            post.description, 
            maxLines: 4, 
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Color(0xFF475467), height: 1.6),
          ),
          const SizedBox(height: 4),
          Text('Read more...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue.shade700)),
        ],
      ),
    );
  }

  Widget _buildFooterActions(BuildContext context, HealthFeedProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      child: Column(
        children: [
          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Text('${_formatCount(post.viewsCount)} views', style: const TextStyle(fontSize: 11, color: Colors.black26)),
                const Spacer(),
                Text('${_formatCount(post.commentsCount)} comments • ${_formatCount(post.sharesCount)} shares', style: const TextStyle(fontSize: 11, color: Colors.black26)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 8),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionButton(
                icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                label: _formatCount(post.likesCount),
                color: post.isLiked ? const Color(0xFFE11D48) : const Color(0xFF667085),
                onTap: () => provider.toggleLike(post.id),
              ),
              _actionButton(
                icon: Icons.chat_bubble_outline,
                label: _formatCount(post.commentsCount),
                color: const Color(0xFF667085),
                onTap: () => _showCommentsSheet(context, provider),
              ),
              _actionButton(
                icon: post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                label: 'Save',
                color: post.isSaved ? const Color(0xFF2563EB) : const Color(0xFF667085),
                onTap: () => provider.toggleSave(post.id),
              ),
              _actionButton(
                icon: Icons.share_outlined,
                label: 'Share',
                color: const Color(0xFF667085),
                onTap: () { provider.sharePost(post.id); },
              ),
              _actionButton(
                icon: Icons.repeat,
                label: 'Repost',
                color: const Color(0xFF667085),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showCommentsSheet(BuildContext context, HealthFeedProvider provider) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text('Comments (${post.commentsCount})', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: post.comments.length,
                  itemBuilder: (_, i) {
                    final c = post.comments[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(radius: 16, backgroundImage: NetworkImage(c.userAvatar)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(c.userName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                    const SizedBox(width: 8),
                                    Text(_formatTimeAgo(c.timestamp), style: const TextStyle(fontSize: 11, color: Colors.black38)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(c.text, style: const TextStyle(fontSize: 13, color: Color(0xFF475467), height: 1.4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 12, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: ctrl,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
                            filled: true,
                            fillColor: const Color(0xFFF2F4F7),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (ctrl.text.trim().isNotEmpty) {
                            provider.addComment(post.id, ctrl.text.trim());
                            ctrl.clear();
                            Navigator.pop(ctx);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(color: Color(0xFF1D2939), shape: BoxShape.circle),
                          child: const Icon(Icons.send, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _posterGradientStart(PostCategory cat) {
    switch (cat) {
      case PostCategory.virusAlert: return const Color(0xFFB91C1C);
      case PostCategory.whoUpdate: return const Color(0xFF0E7490);
      case PostCategory.govAdvisory: return const Color(0xFFB45309);
      default: return const Color(0xFF1E40AF);
    }
  }

  Color _posterGradientEnd(PostCategory cat) {
    switch (cat) {
      case PostCategory.virusAlert: return const Color(0xFF7F1D1D);
      case PostCategory.whoUpdate: return const Color(0xFF164E63);
      case PostCategory.govAdvisory: return const Color(0xFF78350F);
      default: return const Color(0xFF1E3A5F);
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ────────────────────────────────────────────────────────────────
// POST DETAIL SCREEN (Full content + comments panel)
// ────────────────────────────────────────────────────────────────
class PostDetailScreen extends StatelessWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthFeedProvider>(
      builder: (context, provider, _) {
        final post = provider.allPosts.firstWhere((p) => p.id == postId);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Color(0xFF1D2939)),
            title: Row(
              children: [
                CircleAvatar(radius: 14, backgroundImage: NetworkImage(post.publisher.avatarUrl)),
                const SizedBox(width: 8),
                Text(post.publisher.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1D2939))),
                if (post.publisher.isVerified)
                  const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.verified, color: Color(0xFF2563EB), size: 14)),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(post.isSaved ? Icons.bookmark : Icons.bookmark_border, color: post.isSaved ? const Color(0xFF2563EB) : null),
                onPressed: () => provider.toggleSave(post.id),
              ),
              IconButton(icon: const Icon(Icons.share_outlined), onPressed: () => provider.sharePost(post.id)),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: provider.categoryColor(post.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(provider.categoryLabel(post.category), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: provider.categoryColor(post.category))),
                ),
                const SizedBox(height: 16),
                // Title
                Text(post.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1D2939), height: 1.3)),
                const SizedBox(height: 8),
                Text('${post.publisher.role} • ${_formatTimeAgo(post.createdAt)}', style: const TextStyle(fontSize: 12, color: Colors.black38)),
                const SizedBox(height: 20),
                // Full description
                Text(post.description, style: const TextStyle(fontSize: 15, color: Color(0xFF344054), height: 1.7)),
                const SizedBox(height: 24),
                // Stats
                Row(
                  children: [
                    _stat(Icons.visibility_outlined, '${_formatCount(post.viewsCount)} views'),
                    const SizedBox(width: 16),
                    _stat(Icons.favorite_border, '${_formatCount(post.likesCount)} likes'),
                    const SizedBox(width: 16),
                    _stat(Icons.chat_bubble_outline, '${_formatCount(post.commentsCount)} comments'),
                  ],
                ),
                const Divider(height: 32),
                // Like/Save row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _detailAction(
                      icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                      label: post.isLiked ? 'Liked' : 'Like',
                      color: post.isLiked ? const Color(0xFFE11D48) : const Color(0xFF667085),
                      onTap: () => provider.toggleLike(post.id),
                    ),
                    _detailAction(icon: Icons.chat_bubble_outline, label: 'Comment', color: const Color(0xFF667085), onTap: () {}),
                    _detailAction(
                      icon: post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      label: post.isSaved ? 'Saved' : 'Save',
                      color: post.isSaved ? const Color(0xFF2563EB) : const Color(0xFF667085),
                      onTap: () => provider.toggleSave(post.id),
                    ),
                    _detailAction(icon: Icons.share_outlined, label: 'Share', color: const Color(0xFF667085), onTap: () => provider.sharePost(post.id)),
                  ],
                ),
                const Divider(height: 32),
                // Comments Section
                Text('Comments (${post.commentsCount})', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 16),
                ...post.comments.map((c) => _commentTile(c)),
                if (post.comments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text('No comments yet. Be the first!', style: TextStyle(color: Colors.black38, fontSize: 13))),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _stat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black38),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.black38)),
      ],
    );
  }

  Widget _detailAction({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _commentTile(PostComment c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 16, backgroundImage: NetworkImage(c.userAvatar)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(c.userName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(width: 8),
                    Text(_formatTimeAgo(c.timestamp), style: const TextStyle(fontSize: 11, color: Colors.black38)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(c.text, style: const TextStyle(fontSize: 13, color: Color(0xFF475467), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
