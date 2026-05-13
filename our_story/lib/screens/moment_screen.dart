import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_theme.dart';

class MomentScreen extends StatefulWidget {
  const MomentScreen({super.key});

  @override
  State<MomentScreen> createState() => _MomentScreenState();
}

class _MomentScreenState extends State<MomentScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Moment> _moments = [
    Moment(
      id: '1',
      content: '今天一起看了日落，他/她偷偷牵住了我的手 💕',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      hugs: 5,
      headPats: 3,
      isMe: true,
    ),
    Moment(
      id: '2',
      content: '第一次一起做饭，虽然把厨房弄得一团糟，但是好开心呀～',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      hugs: 12,
      headPats: 8,
      isMe: false,
    ),
    Moment(
      id: '3',
      content: '收到了一份小礼物，是一对情侣手表⌚，感动到哭...',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      hugs: 20,
      headPats: 15,
      isMe: true,
    ),
  ];

  void _addMoment() {
    if (_textController.text.trim().isEmpty) return;
    
    setState(() {
      _moments.insert(
        0,
        Moment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: _textController.text.trim(),
          imageUrl: null,
          createdAt: DateTime.now(),
          hugs: 0,
          headPats: 0,
          isMe: true,
        ),
      );
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _moments.length,
                  itemBuilder: (context, index) {
                    final moment = _moments[index];
                    final showTimeline = index < _moments.length - 1;
                    return Column(
                      children: [
                        if (showTimeline) _buildTimeline(),
                        _MomentCard(
                          moment: moment,
                          onHug: () => setState(() => moment.hugs++),
                          onHeadPat: () => setState(() => moment.headPats++),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨ 瞬间胶囊',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          _buildPostBox(),
        ],
      ),
    );
  }

  Widget _buildPostBox() {
    return SoftCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.softPink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '👤',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _textController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: '记录这一刻的美好...',
                    border: InputBorder.none,
                    filled: true,
                    fillColor: AppColors.cream,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildUploadButton(),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _addMoment,
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text('发布'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('图片上传功能开发中... 📸'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.add_photo_alternate_rounded,
                  color: AppColors.deepRose,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  '添加图片',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.warmBrown,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      width: 2,
      height: 24,
      margin: const EdgeInsets.only(left: 29),
      color: AppColors.primaryPink.withOpacity(0.4),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class Moment {
  final String id;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  int hugs;
  int headPats;
  final bool isMe;

  Moment({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    this.hugs = 0,
    this.headPats = 0,
    this.isMe = true,
  });
}

class _MomentCard extends StatelessWidget {
  final Moment moment;
  final VoidCallback onHug;
  final VoidCallback onHeadPat;

  const _MomentCard({
    required this.moment,
    required this.onHug,
    required this.onHeadPat,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: moment.isMe ? AppColors.softPink : AppColors.softLavender,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    moment.isMe ? '😊' : '🥰',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moment.isMe ? '我' : 'Ta',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      _formatTime(moment.createdAt),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (moment.imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 150,
                width: double.infinity,
                color: AppColors.cream,
                child: const Center(
                  child: Icon(Icons.image, size: 48, color: AppColors.dustyRose),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            moment.content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _buildReactionBar(context),
        ],
      ),
    );
  }

  Widget _buildReactionBar(BuildContext context) {
    return Row(
      children: [
        _ReactionButton(
          icon: '🤗',
          label: '拥抱',
          count: moment.hugs,
          onTap: onHug,
        ),
        const SizedBox(width: 16),
        _ReactionButton(
          icon: '🙆',
          label: '摸摸头',
          count: moment.headPats,
          onTap: onHeadPat,
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';
    return DateFormat('MM月dd日').format(time);
  }
}

class _ReactionButton extends StatelessWidget {
  final String icon;
  final String label;
  final int count;
  final VoidCallback onTap;

  const _ReactionButton({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text(
                '$label $count',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.warmBrown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
