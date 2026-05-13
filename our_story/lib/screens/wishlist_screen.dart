import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_theme.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final List<Wish> _wishes = [
    Wish(
      id: '1',
      title: '一起去看极光',
      description: '在冰岛的夜空下，感受大自然的奇幻',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      claimedBy: null,
      isAchieved: false,
    ),
    Wish(
      id: '2',
      title: '学做对方爱吃的菜',
      description: '为Ta准备一顿爱心晚餐',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      claimedBy: 'me',
      isAchieved: false,
    ),
    Wish(
      id: '3',
      title: '一起养一只小猫咪',
      description: '给它取一个有意义的名字',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      claimedBy: 'ta',
      isAchieved: false,
    ),
    Wish(
      id: '4',
      title: '在海边看日出',
      description: '凌晨5点，牵着手等待第一缕阳光',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
      claimedBy: 'me',
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
      achievedAt: DateTime.now().subtract(const Duration(days: 50)),
      isAchieved: true,
    ),
    Wish(
      id: '5',
      title: '一起看演唱会',
      description: '去听最爱的歌手的现场演出',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      claimedBy: 'both',
      achievedAt: DateTime.now().subtract(const Duration(days: 30)),
      isAchieved: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Wish> get _inProgressWishes =>
      _wishes.where((w) => !w.isAchieved).toList();

  List<Wish> get _achievedWishes =>
      _wishes.where((w) => w.isAchieved).toList();

  void _claimWish(Wish wish) {
    setState(() {
      if (wish.claimedBy == null) {
        wish.claimedBy = 'me';
      } else if (wish.claimedBy == 'me') {
        wish.claimedBy = 'both';
      }
    });
  }

  void _markAsAchieved(Wish wish) {
    setState(() {
      wish.isAchieved = true;
      wish.achievedAt = DateTime.now();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 愿望"${wish.title}"已实现！'),
        backgroundColor: AppColors.deepRose,
      ),
    );
  }

  void _showAddWishDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.dustyRose.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '✨ 许下新愿望',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: '愿望标题',
                  prefixIcon: const Icon(Icons.star_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: '描述一下这个愿望...',
                  prefixIcon: const Icon(Icons.edit_rounded),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      setState(() {
                        _wishes.insert(
                          0,
                          Wish(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: titleController.text.trim(),
                            description: descController.text.trim(),
                            imageUrl: null,
                            createdAt: DateTime.now(),
                            claimedBy: null,
                            isAchieved: false,
                          ),
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('许下愿望 🌟'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildWishList(_inProgressWishes),
                    _buildWishList(_achievedWishes),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💫 愿望清单',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '一起完成的美好事情',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          SoftCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(12),
            onTap: _showAddWishDialog,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryPink,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPink.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: AppColors.deepRose,
          unselectedLabelColor: AppColors.warmBrown.withOpacity(0.6),
          labelStyle: Theme.of(context).textTheme.labelLarge,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pending_actions_rounded, size: 18),
                  const SizedBox(width: 6),
                  Text('进行中 (${_inProgressWishes.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 18),
                  const SizedBox(width: 6),
                  Text('已实现 (${_achievedWishes.length})'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishList(List<Wish> wishes) {
    if (wishes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _tabController.index == 0 ? '🌟' : '🎉',
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              _tabController.index == 0 ? '还没有愿望' : '还没有实现的愿望',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _tabController.index == 0 ? '去许下第一个愿望吧~' : '完成愿望后来这里打卡吧',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: wishes.length,
      itemBuilder: (context, index) {
        return _WishCard(
          wish: wishes[index],
          onClaim: () => _claimWish(wishes[index]),
          onAchieve: () => _markAsAchieved(wishes[index]),
        );
      },
    );
  }
}

class Wish {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  String? claimedBy;
  DateTime? achievedAt;
  bool isAchieved;

  Wish({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    this.claimedBy,
    this.achievedAt,
    this.isAchieved = false,
  });
}

class _WishCard extends StatelessWidget {
  final Wish wish;
  final VoidCallback onClaim;
  final VoidCallback onAchieve;

  const _WishCard({
    required this.wish,
    required this.onClaim,
    required this.onAchieve,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: wish.isAchieved ? 0.6 : 1.0,
      child: SoftCard(
        margin: const EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getWishEmoji(wish.title),
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
                if (wish.isAchieved)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.deepRose,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatDate(wish.isAchieved ? wish.achievedAt! : wish.createdAt),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          wish.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: wish.isAchieved
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      if (wish.isAchieved)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.softLavender,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '已实现',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.deepRose,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    wish.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  if (wish.claimedBy != null && wish.claimedBy != 'none')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildClaimBadge(context),
                    ),
                  if (!wish.isAchieved) _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimBadge(BuildContext context) {
    String text;
    Color color;
    switch (wish.claimedBy) {
      case 'me':
        text = '🙋 我要带Ta去';
        color = AppColors.primaryPink;
        break;
      case 'ta':
        text = '🥰 Ta要带我去';
        color = AppColors.softLavender;
        break;
      case 'both':
        text = '💕 我们一起去';
        color = AppColors.deepRose;
        break;
      default:
        text = '';
        color = Colors.transparent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.warmBrown,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onClaim,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.volunteer_activism_rounded, size: 18),
                const SizedBox(width: 6),
                Text(wish.claimedBy == null ? '我要认领' : '已认领'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onAchieve,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepRose,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.celebration_rounded, size: 18),
                SizedBox(width: 6),
                Text('实现啦!'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getWishEmoji(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('旅行') || lower.contains('旅游')) return '✈️';
    if (lower.contains('海') || lower.contains('日出') || lower.contains('日落')) return '🌅';
    if (lower.contains('猫') || lower.contains('宠物')) return '🐱';
    if (lower.contains('极光')) return '🌌';
    if (lower.contains('演唱会') || lower.contains('音乐')) return '🎵';
    if (lower.contains('电影')) return '🎬';
    if (lower.contains('美食') || lower.contains('做饭') || lower.contains('餐厅')) return '🍳';
    if (lower.contains('滑雪') || lower.contains('雪')) return '⛷️';
    if (lower.contains('潜水') || lower.contains('游泳')) return '🏊';
    if (lower.contains('露营') || lower.contains('野营')) return '⛺';
    if (lower.contains('烟花')) return '🎆';
    if (lower.contains('生日')) return '🎂';
    return '🌟';
  }

  String _formatDate(DateTime date) {
    if (wish.isAchieved) {
      return '实现于 ${DateFormat('yyyy.MM.dd').format(date)}';
    }
    return DateFormat('yyyy.MM.dd').format(date);
  }
}
