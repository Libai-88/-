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
  final ScrollController _scrollController = ScrollController();
  final List<Moment> _moments = [
    Moment(
      id: '1',
      content: '今天的日落好美呀，他/她偷偷牵住了我的手 💕',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      hugs: 5,
      headPats: 3,
      isMe: true,
    ),
    Moment(
      id: '2',
      content: '第一次一起做饭，厨房被我们弄得一团糟，但好开心呀～',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      hugs: 12,
      headPats: 8,
      isMe: false,
    ),
    Moment(
      id: '3',
      content: '收到了一对情侣手表⌚，感动到眼眶湿润了...',
      imageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      hugs: 20,
      headPats: 15,
      isMe: true,
    ),
  ];
  String? _highlightedId;
  String? _burstEmoji;
  String? _burstId;

  void _addMoment() {
    if (_textController.text.trim().isEmpty) return;
    
    setState(() {
      final newMoment = Moment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _textController.text.trim(),
        imageUrl: null,
        createdAt: DateTime.now(),
        hugs: 0,
        headPats: 0,
        isMe: true,
      );
      _moments.insert(0, newMoment);
      _highlightedId = newMoment.id;
      _textController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _highlightedId = null);
    });
  }

  void _triggerBurst(String emoji, String id) {
    setState(() {
      _burstEmoji = emoji;
      _burstId = id;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _burstEmoji = null);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
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
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _moments.length,
                  itemBuilder: (context, index) {
                    final moment = _moments[index];
                    final showTimeline = index < _moments.length - 1;
                    return FadeInWidget(
                      delay: Duration(milliseconds: 200 + index * 100),
                      child: Column(
                        children: [
                          if (showTimeline) _buildTimeline(),
                          Stack(
                            children: [
                              _MomentCard(
                                moment: moment,
                                isHighlighted: _highlightedId == moment.id,
                                onHug: () {
                                  setState(() => moment.hugs++);
                                  _triggerBurst('🤗', moment.id);
                                },
                                onHeadPat: () {
                                  setState(() => moment.headPats++);
                                  _triggerBurst('🙆', moment.id);
                                },
                              ),
                              if (_burstEmoji != null && _burstId == moment.id)
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: EmojiBurst(
                                      emoji: _burstEmoji!,
                                      onComplete: () {},
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
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
          const SizedBox(height: 14),
          _buildPostBox(),
        ],
      ),
    );
  }

  Widget _buildPostBox() {
    return SoftCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.softPink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('😊', style: TextStyle(fontSize: 20)),
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
              BouncyTap(
                onTap: _addMoment,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '发布',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return BouncyTap(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('图片上传功能开发中... 📸'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_photo_alternate_rounded,
              color: AppColors.deepRose,
              size: 18,
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
    );
  }

  Widget _buildTimeline() {
    return Container(
      width: 2,
      height: 16,
      margin: const EdgeInsets.only(left: 26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryPink.withOpacity(0.0),
            AppColors.primaryPink.withOpacity(0.4),
          ],
        ),
      ),
    );
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

class _MomentCard extends StatefulWidget {
  final Moment moment;
  final bool isHighlighted;
  final VoidCallback onHug;
  final VoidCallback onHeadPat;

  const _MomentCard({
    required this.moment,
    required this.isHighlighted,
    required this.onHug,
    required this.onHeadPat,
  });

  @override
  State<_MomentCard> createState() => _MomentCardState();
}

class _MomentCardState extends State<_MomentCard> {
  bool _isBouncing = false;

  void _bounce() {
    setState(() => _isBouncing = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isBouncing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return HighlightWidget(
      highlight: widget.isHighlighted,
      child: AnimatedScale(
        scale: _isBouncing ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: SoftCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.moment.isMe ? AppColors.softPink : AppColors.softLavender,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.moment.isMe ? '😊' : '🥰',
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
                          widget.moment.isMe ? '我' : 'Ta',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          _formatTime(widget.moment.createdAt),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.moment.imageUrl != null) ...[
                const SizedBox(height: 12),
                const ImagePlaceholder(height: 140),
              ],
              const SizedBox(height: 12),
              Text(
                widget.moment.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              _buildReactionBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReactionBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BouncyTap(
            onTap: () {
              _bounce();
              widget.onHug();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🤗', style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    '拥抱 ${widget.moment.hugs}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.warmBrown,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: BouncyTap(
            onTap: () {
              _bounce();
              widget.onHeadPat();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🙆', style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    '摸摸头 ${widget.moment.headPats}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.warmBrown,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
