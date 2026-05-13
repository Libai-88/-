import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class Moment {
  final String imageUrl;
  final String content;
  final DateTime timestamp;
  int hugCount;
  int headPatCount;

  Moment({
    required this.imageUrl,
    required this.content,
    required this.timestamp,
    this.hugCount = 0,
    this.headPatCount = 0,
  });
}

class MomentScreen extends StatefulWidget {
  const MomentScreen({super.key});

  @override
  State<MomentScreen> createState() => _MomentScreenState();
}

class _MomentScreenState extends State<MomentScreen> {
  final TextEditingController _contentController = TextEditingController();
  final List<Moment> _moments = [
    Moment(
      imageUrl: '',
      content: '今天一起去看了日落，夕阳真的好美呀～希望时间能永远停在这一刻 ☀️',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Moment(
      imageUrl: '',
      content: '收到了Ta偷偷准备的礼物，感动到哭！❤️',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      hugCount: 5,
      headPatCount: 3,
    ),
    Moment(
      imageUrl: '',
      content: '一起做了顿晚餐，虽然有点糊了但是很开心！🍳',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      hugCount: 12,
      headPatCount: 8,
    ),
    Moment(
      imageUrl: '',
      content: '第一次牵手，心跳得好快～紧张又甜蜜 💕',
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      hugCount: 20,
      headPatCount: 15,
    ),
  ];
  bool _hasImage = false;

  void _toggleHug(int index) {
    setState(() {
      _moments[index].hugCount++;
    });
  }

  void _toggleHeadPat(int index) {
    setState(() {
      _moments[index].headPatCount++;
    });
  }

  void _publishMoment() {
    if (_contentController.text.isEmpty && !_hasImage) return;
    
    setState(() {
      _moments.insert(
        0,
        Moment(
          imageUrl: _hasImage ? 'new' : '',
          content: _contentController.text,
          timestamp: DateTime.now(),
        ),
      );
      _contentController.clear();
      _hasImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildPostArea(),
            Expanded(child: _buildMomentsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text('✨ 瞬间胶囊', style: Theme.of(context).textTheme.displayMedium),
    );
  }

  Widget _buildPostArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _hasImage = !_hasImage;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('📷 模拟选择图片成功！'),
                  backgroundColor: AppTheme.primaryPink,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: _hasImage ? AppTheme.softPink : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryPink.withOpacity(0.3),
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: Center(
                child: _hasImage
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: AppTheme.primaryPink, size: 40),
                          const SizedBox(height: 8),
                          Text('图片已选择 ✓', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey[500]),
                          const SizedBox(height: 8),
                          Text('点击添加图片', style: TextStyle(color: Colors.grey[500])),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            maxLines: 2,
            decoration: const InputDecoration(hintText: '记录此刻的心情...'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _publishMoment,
              child: const Text('发布'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMomentsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _moments.length,
      itemBuilder: (context, index) {
        final moment = _moments[index];
        return _buildMomentCard(moment, index);
      },
    );
  }

  Widget _buildMomentCard(Moment moment, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryPink, AppTheme.primaryPink.withOpacity(0.7)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Text('Ta', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Text(
                _formatTime(moment.timestamp),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightText.withOpacity(0.6),
                      fontSize: 12,
                    ),
              ),
            ],
          ),
          if (moment.imageUrl.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(Icons.image, size: 48, color: Colors.grey[400]),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(moment.content, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildReactionButton(
                icon: '🤗',
                label: '抱抱',
                count: moment.hugCount,
                onTap: () => _toggleHug(index),
              ),
              const SizedBox(width: 16),
              _buildReactionButton(
                icon: '🫳',
                label: '摸摸头',
                count: moment.headPatCount,
                onTap: () => _toggleHeadPat(index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReactionButton({
    required String icon,
    required String label,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.softPink.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              '$label $count',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return DateFormat('MM/dd').format(time);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
