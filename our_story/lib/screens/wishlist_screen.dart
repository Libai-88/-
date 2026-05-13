import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Wish {
  final String title;
  final String imageUrl;
  final bool isCompleted;
  final String? claimedBy;

  Wish({
    required this.title,
    required this.imageUrl,
    this.isCompleted = false,
    this.claimedBy,
  });
}

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Wish> _activeWishes = [
    Wish(title: '一起去看极光 ✨', imageUrl: '', claimedBy: 'Ta'),
    Wish(title: '在海边看日落 🌅', imageUrl: '', claimedBy: '我'),
    Wish(title: '一起做饭 🍳', imageUrl: ''),
  ];
  final List<Wish> _completedWishes = [
    Wish(title: '一起看第一场雪 ❄️', imageUrl: '', isCompleted: true),
  ];

  void _addWish() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('添加愿望', style: Theme.of(context).textTheme.titleLarge),
        content: TextField(
          decoration: const InputDecoration(hintText: '写下你们的愿望...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✨ 愿望已添加！'), backgroundColor: AppTheme.primaryPink),
              );
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _claimWish(int index) {
    setState(() {
      if (_activeWishes[index].claimedBy == null) {
        _activeWishes[index] = Wish(title: _activeWishes[index].title, imageUrl: _activeWishes[index].imageUrl, claimedBy: '我');
      } else if (_activeWishes[index].claimedBy == '我') {
        _activeWishes[index] = Wish(title: _activeWishes[index].title, imageUrl: _activeWishes[index].imageUrl, claimedBy: 'Ta');
      } else {
        _activeWishes[index] = Wish(title: _activeWishes[index].title, imageUrl: _activeWishes[index].imageUrl, claimedBy: '我 & Ta');
        _completedWishes.insert(0, Wish(title: _activeWishes[index].title, imageUrl: _activeWishes[index].imageUrl, isCompleted: true));
        _activeWishes.removeAt(index);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('💕 共同实现愿望！'), backgroundColor: AppTheme.primaryPink, duration: Duration(seconds: 1)),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(child: _buildTabBarView()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('💝 愿望清单', style: Theme.of(context).textTheme.displayMedium),
          GestureDetector(
            onTap: _addWish,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: AppTheme.primaryPink, borderRadius: BorderRadius.circular(20)),
              child: const Row(
                children: [
                  Icon(Icons.add, color: Colors.white, size: 20),
                  SizedBox(width: 4),
                  Text('添加愿望', style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(16)),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(color: AppTheme.primaryPink, borderRadius: BorderRadius.circular(16)),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.lightText,
        dividerColor: Colors.transparent,
        tabs: const [Tab(text: '进行中'), Tab(text: '已实现')],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [_buildActiveWishes(), _buildCompletedWishes()],
    );
  }

  Widget _buildActiveWishes() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _activeWishes.length,
      itemBuilder: (context, index) => _buildWishCard(_activeWishes[index], index, isActive: true),
    );
  }

  Widget _buildCompletedWishes() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _completedWishes.length,
      itemBuilder: (context, index) => _buildWishCard(_completedWishes[index], index, isActive: false),
    );
  }

  Widget _buildWishCard(Wish wish, int index, {required bool isActive}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isActive ? 0.9 : 0.6),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor.withOpacity(isActive ? 0.2 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Center(child: Icon(Icons.landscape, size: 48, color: Colors.grey[400])),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    if (!isActive)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 14),
                      ),
                    Expanded(
                      child: Text(
                        wish.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              decoration: isActive ? null : TextDecoration.lineThrough,
                              color: isActive ? null : AppTheme.lightText.withOpacity(0.5),
                            ),
                      ),
                    ),
                  ],
                ),
                if (wish.claimedBy != null && isActive) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.favorite, size: 16, color: AppTheme.primaryPink.withOpacity(0.8)),
                      const SizedBox(width: 6),
                      Text('由 ${wish.claimedBy} 认领', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12, color: AppTheme.primaryPink)),
                    ],
                  ),
                ],
                if (isActive) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _claimWish(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: wish.claimedBy == null ? AppTheme.primaryPink : wish.claimedBy == '我 & Ta' ? Colors.green : AppTheme.warmBrown,
                      ),
                      child: Text(wish.claimedBy == null ? '认领' : wish.claimedBy == '我 & Ta' ? '✨ 已实现！' : 'Ta也来认领 ✨'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
