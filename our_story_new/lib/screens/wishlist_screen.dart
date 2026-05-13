import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_theme.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Wish> _wishes = [
    Wish(
      id: '1',
      title: '一起去看极光',
      description: '在冰岛的夜空下，感受大自然的奇幻时刻',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      claimedBy: null,
      isAchieved: false,
    ),
    Wish(
      id: '2',
      title: '学做对方爱吃的菜',
      description: '为Ta准备一顿用心的爱心晚餐',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      claimedBy: 'me',
      isAchieved: false,
    ),
    Wish(
      id: '3',
      title: '一起养一只小猫咪',
      description: '给它取一个有意义的名字，一起照顾它',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      claimedBy: 'ta',
      isAchieved: false,
    ),
    Wish(
      id: '4',
      title: '在海边看日出',
      description: '凌晨时分，牵着手等待第一缕阳光',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
      claimedBy: 'me',
      achievedAt: DateTime.now().subtract(const Duration(days: 50)),
      isAchieved: true,
    ),
    Wish(
      id: '5',
      title: '一起看演唱会',
      description: '去听最爱的歌手的现场，和Ta一起尖叫',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      claimedBy: 'both',
      achievedAt: DateTime.now().subtract(const Duration(days: 30)),
      isAchieved: true,
    ),
  ];

  String? _celebratingId;

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
      _celebratingId = wish.id;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 愿望"${wish.title}"已实现！'),
        backgroundColor: AppColors.deepRose,
      ),
    );
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _celebratingId = null);
    });
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
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
              const SizedBox(height: 16),
              Text(
                '✨ 许下新愿望',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: '愿望标题',
                  prefixIcon: const Icon(Icons.star_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: '描述一下这个愿望...',
                  prefixIcon: const Icon(Icons.edit_rounded),
                ),
              ),
              const SizedBox(height: 20),
              BouncyTap(
                onTap: () {
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
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      '许下愿望 🌟',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: _buildHeader(),
              ),
              FadeInWidget(
                delay: const Duration(milliseconds: 200),
                child: _buildTabBar(),
              ),
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
          BouncyTap(
            onTap: _showAddWishDialog,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primaryPink,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 24,
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
                color: AppColors.primaryPink.withOpacity(0.15),
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
                  const Icon(Icons.pending_actions_rounded, size: 16),
                  const SizedBox(width: 6),
                  Text('进行中 (${_inProgressWishes.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 16),
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
              style: const TextStyle(fontSize: 56),
            ),
            const SizedBox(height: 14),
            Text(
              _tabController.index == 0 ? '还没有愿望' : '还没有实现的愿望',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
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
        final wish = wishes[index];
        final isCelebrating = _celebratingId == wish.id;
        return FadeInWidget(
          delay: Duration(milliseconds: 100 + index * 80),
          child: Stack(
            children: [
              _WishCard(
                wish: wish,
                onClaim: () => _claimWish(wish),
                onAchieve: () => _markAsAchieved(wish),
              ),
              if (isCelebrating)
                Positioned.fill(child: GoldenCelebration(onComplete: () {})),
            ],
          ),
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

class _WishCard extends StatefulWidget {
  final Wish wish;
  final VoidCallback onClaim;
  final VoidCallback onAchieve;

  const _WishCard({
    required this.wish,
    required this.onClaim,
    required this.onAchieve,
  });

  @override
  State<_WishCard> createState() => _WishCardState();
}

class _WishCardState extends State<_WishCard> with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(_flipController);
  }

  @override
  void didUpdateWidget(_WishCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wish.claimedBy == null && widget.wish.claimedBy != null) {
      _flip();
    }
  }

  void _flip() {
    _flipController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _flipController.reset();
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.wish.isAchieved ? 0.6 : 1.0,
      child: SoftCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.zero,
        child: AnimatedBuilder(
          animation: _flipAnimation,
          builder: (context, child) {
            final angle = _flipAnimation.value * 3.1416;
            final isFront = angle < 3.1416 / 2;
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              alignment: Alignment.center,
              child: isFront ? _buildFront() : _buildBack(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFront() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text(
                  _getWishEmoji(widget.wish.title),
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            if (widget.wish.isAchieved)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.deepRose,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            Positioned(
              bottom: 10,
              left: 10,
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
                  _formatDate(widget.wish.isAchieved ? widget.wish.achievedAt! : widget.wish.createdAt),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.wish.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: widget.wish.isAchieved
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  if (widget.wish.isAchieved)
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
                widget.wish.description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              if (widget.wish.claimedBy != null && widget.wish.claimedBy != 'none' && !widget.wish.isAchieved)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildClaimBadge(context),
                ),
              if (!widget.wish.isAchieved) _buildActionButtons(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBack() {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.softPink,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💝', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              _getClaimText(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.warmBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimBadge(BuildContext context) {
    String text = _getClaimText();
    Color color = AppColors.primaryPink;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
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

  String _getClaimText() {
    switch (widget.wish.claimedBy) {
      case 'me':
        return '🙋 我要带Ta去';
      case 'ta':
        return '🥰 Ta要带我去';
      case 'both':
        return '💝 我们一起去';
      default:
        return '';
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BouncyTap(
            onTap: widget.onClaim,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryPink, width: 1.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.volunteer_activism_rounded, size: 16, color: AppColors.deepRose),
                    const SizedBox(width: 6),
                    Text(
                      widget.wish.claimedBy == null ? '我要认领' : '已认领',
                      style: TextStyle(color: AppColors.deepRose, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: BouncyTap(
            onTap: widget.onAchieve,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.deepRose,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.celebration_rounded, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      '实现啦!',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ),
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
    if (widget.wish.isAchieved) {
      return '实现于 ${DateFormat('yyyy.MM.dd').format(date)}';
    }
    return DateFormat('yyyy.MM.dd').format(date);
  }
}
