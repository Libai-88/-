import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_theme.dart';

class WhisperScreen extends StatefulWidget {
  const WhisperScreen({super.key});

  @override
  State<WhisperScreen> createState() => _WhisperScreenState();
}

class _WhisperScreenState extends State<WhisperScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Whisper> _sentWhispers = [
    Whisper(
      id: '1',
      content: '今天看到一朵云，形状好像你的笑脸 ☁️',
      scheduledTime: DateTime.now().add(const Duration(hours: 2)),
      status: WhisperStatus.delivering,
      isMe: true,
    ),
    Whisper(
      id: '2',
      content: '其实...我一直想告诉你一个秘密 💕',
      scheduledTime: DateTime.now().add(const Duration(days: 1)),
      status: WhisperStatus.delivering,
      isMe: true,
    ),
    Whisper(
      id: '3',
      content: '谢谢你一直陪在我身边，遇见你真好',
      scheduledTime: DateTime.now().subtract(const Duration(days: 2)),
      status: WhisperStatus.delivered,
      isMe: true,
    ),
  ];

  final List<Whisper> _receivedWhispers = [
    Whisper(
      id: '4',
      content: '昨晚梦见我们一起去了海边，醒来发现枕头湿了 🌊',
      scheduledTime: DateTime.now().subtract(const Duration(days: 1)),
      status: WhisperStatus.delivered,
      isMe: false,
    ),
    Whisper(
      id: '5',
      content: '今天是我们在一起的第100天，想对你说... 💌',
      scheduledTime: DateTime.now().subtract(const Duration(days: 3)),
      status: WhisperStatus.delivered,
      isMe: false,
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

  void _showWriteWhisperDialog() {
    final contentController = TextEditingController();
    DateTime selectedTime = DateTime.now().add(const Duration(hours: 1));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
                Row(
                  children: [
                    const Text('✉️', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Text(
                      '写一封悄悄话',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: contentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: '写下你想对Ta说的话...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      hintStyle: TextStyle(
                        color: AppColors.warmBrown.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '选择送达时间',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTimeChip(
                      '1小时后',
                      DateTime.now().add(const Duration(hours: 1)),
                      selectedTime,
                      (time) => setModalState(() => selectedTime = time),
                    ),
                    _buildTimeChip(
                      '今晚12点',
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        23,
                        59,
                      ),
                      selectedTime,
                      (time) => setModalState(() => selectedTime = time),
                    ),
                    _buildTimeChip(
                      '明早8点',
                      DateTime(
                        DateTime.now().add(const Duration(days: 1)).year,
                        DateTime.now().add(const Duration(days: 1)).month,
                        DateTime.now().add(const Duration(days: 1)).day,
                        8,
                      ),
                      selectedTime,
                      (time) => setModalState(() => selectedTime = time),
                    ),
                    _buildTimeChip(
                      '明天中午',
                      DateTime(
                        DateTime.now().add(const Duration(days: 1)).year,
                        DateTime.now().add(const Duration(days: 1)).month,
                        DateTime.now().add(const Duration(days: 1)).day,
                        12,
                      ),
                      selectedTime,
                      (time) => setModalState(() => selectedTime = time),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BouncyTap(
                  onTap: () {
                    if (contentController.text.trim().isNotEmpty) {
                      setState(() {
                        _sentWhispers.insert(
                          0,
                          Whisper(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            content: contentController.text.trim(),
                            scheduledTime: selectedTime,
                            status: WhisperStatus.delivering,
                            isMe: true,
                          ),
                        );
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('💌 悄悄话已投递，将在 ${_formatTime(selectedTime)} 送达'),
                          backgroundColor: AppColors.deepRose,
                        ),
                      );
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
                        '投递悄悄话 💌',
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
      ),
    );
  }

  Widget _buildTimeChip(
    String label,
    DateTime time,
    DateTime selectedTime,
    Function(DateTime) onSelect,
  ) {
    final isSelected = selectedTime.hour == time.hour &&
        selectedTime.day == time.day &&
        selectedTime.month == time.month;

    return BouncyTap(
      onTap: () => onSelect(time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPink : AppColors.cream,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.warmBrown,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
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
                    _buildWhisperList(_sentWhispers, true),
                    _buildWhisperList(_receivedWhispers, false),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💌 悄悄话信箱',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '延迟送达的惊喜',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              BouncyTap(
                onTap: _showWriteWhisperDialog,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SoftCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(14),
            onTap: _showWriteWhisperDialog,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.softPink,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('✉️', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '写一封新悄悄话',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '选择送达时间，制造延迟惊喜',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.warmBrown.withOpacity(0.3),
                  size: 14,
                ),
              ],
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
                  const Icon(Icons.send_rounded, size: 16),
                  const SizedBox(width: 6),
                  Text('已发送'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_rounded, size: 16),
                  const SizedBox(width: 6),
                  Text('收到的'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhisperList(List<Whisper> whispers, bool isSent) {
    if (whispers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isSent ? '✉️' : '📭',
              style: const TextStyle(fontSize: 56),
            ),
            const SizedBox(height: 14),
            Text(
              isSent ? '还没有发送悄悄话' : '还没有收到悄悄话',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              isSent ? '去给Ta写一封吧~' : '耐心等待，惊喜即将到来',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: whispers.length,
      itemBuilder: (context, index) {
        return FadeInWidget(
          delay: Duration(milliseconds: 100 + index * 80),
          child: _WhisperCard(
            whisper: whispers[index],
            isSent: isSent,
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat('MM月dd日 HH:mm').format(time);
  }
}

enum WhisperStatus { delivering, delivered }

class Whisper {
  final String id;
  final String content;
  final DateTime scheduledTime;
  WhisperStatus status;
  final bool isMe;

  Whisper({
    required this.id,
    required this.content,
    required this.scheduledTime,
    required this.status,
    this.isMe = true,
  });
}

class _WhisperCard extends StatelessWidget {
  final Whisper whisper;
  final bool isSent;

  const _WhisperCard({
    required this.whisper,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    final isDelivering = whisper.status == WhisperStatus.delivering;
    final isDelivered = whisper.status == WhisperStatus.delivered;

    return SoftCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDelivered ? AppColors.softPink : AppColors.cream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: isDelivered
                      ? Icon(
                          Icons.mail_rounded,
                          color: AppColors.deepRose,
                          size: 22,
                        )
                      : const Text('✉️', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isDelivered ? (isSent ? '已送达' : '来自Ta') : '投递中...',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          isDelivered ? Icons.check_circle_rounded : Icons.schedule_rounded,
                          size: 12,
                          color: isDelivered ? AppColors.deepRose : AppColors.warmBrown.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isDelivered
                              ? '送达于 ${_formatTime(whisper.scheduledTime)}'
                              : '预计 ${_formatTime(whisper.scheduledTime)}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isDelivered
                                ? AppColors.deepRose
                                : AppColors.warmBrown.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isDelivering)
                PulseWidget(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPink,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
          if (isDelivered) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                whisper.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_rounded,
                    size: 14,
                    color: AppColors.warmBrown.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '内容将在送达后显示',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.warmBrown.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat('MM/dd HH:mm').format(time);
  }
}
