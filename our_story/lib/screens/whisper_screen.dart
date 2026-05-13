import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Letter {
  final String content;
  final DateTime? sendTime;
  final bool isDelivered;

  Letter({required this.content, this.sendTime, this.isDelivered = false});
}

class WhisperScreen extends StatefulWidget {
  const WhisperScreen({super.key});

  @override
  State<WhisperScreen> createState() => _WhisperScreenState();
}

class _WhisperScreenState extends State<WhisperScreen> {
  final List<Letter> _letters = [
    Letter(content: '今天的星星好亮，想你了 💫', isDelivered: true),
    Letter(content: '明天见面好期待！', sendTime: DateTime.now().add(const Duration(hours: 1)), isDelivered: false),
    Letter(content: '晚安，做个好梦 🌙', sendTime: DateTime.now().add(const Duration(hours: 8)), isDelivered: false),
  ];

  void _openWriteLetterDialog() {
    final TextEditingController controller = TextEditingController();
    int selectedOption = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('✉️ 写悄悄话', style: Theme.of(context).textTheme.titleLarge),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: '写下想对Ta说的话...'),
                  ),
                  const SizedBox(height: 20),
                  Text('送达时间', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTimeOption(label: '1小时后', isSelected: selectedOption == 0, onTap: () => setModalState(() => selectedOption = 0))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTimeOption(label: '明早8点', isSelected: selectedOption == 1, onTap: () => setModalState(() => selectedOption = 1))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.text.isEmpty) return;
                        final deliveryTime = selectedOption == 0 ? DateTime.now().add(const Duration(hours: 1)) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 8);
                        setState(() {
                          _letters.insert(0, Letter(content: controller.text, sendTime: deliveryTime, isDelivered: false));
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('💌 悄悄话已投递！'), backgroundColor: AppTheme.primaryPink),
                        );
                      },
                      child: const Text('送达'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeOption({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPink : AppTheme.softPink,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: isSelected ? Colors.white : AppTheme.lightText, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildWriteCard(),
            Expanded(child: _buildLettersList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text('💌 悄悄话信箱', style: Theme.of(context).textTheme.displayMedium),
    );
  }

  Widget _buildWriteCard() {
    return GestureDetector(
      onTap: _openWriteLetterDialog,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: AppTheme.shadowColor.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.softPink, borderRadius: BorderRadius.circular(16)),
              child: const Text('✉️', style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('写悄悄话', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('把想说的话送给Ta...', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.lightText.withOpacity(0.6))),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppTheme.lightText, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLettersList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (_letters.any((l) => !l.isDelivered)) ...[
          Padding(padding: const EdgeInsets.only(bottom: 12), child: Text('📨 投递中...', style: Theme.of(context).textTheme.titleMedium)),
          ..._letters.where((l) => !l.isDelivered).map((letter) => _buildLetterCard(letter)),
          const SizedBox(height: 20),
        ],
        if (_letters.any((l) => l.isDelivered)) ...[
          Padding(padding: const EdgeInsets.only(bottom: 12), child: Text('✅ 已送达', style: Theme.of(context).textTheme.titleMedium)),
          ..._letters.where((l) => l.isDelivered).map((letter) => _buildLetterCard(letter)),
        ],
      ],
    );
  }

  Widget _buildLetterCard(Letter letter) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(letter.isDelivered ? 0.9 : 0.7),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppTheme.shadowColor.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: letter.isDelivered ? Colors.green.withOpacity(0.1) : AppTheme.softPink,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(letter.isDelivered ? '📬' : '📨', style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(letter.content, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: letter.isDelivered ? null : AppTheme.lightText.withOpacity(0.7))),
                const SizedBox(height: 8),
                Text(
                  letter.isDelivered ? '已送达 ✓' : '送达中 ${letter.sendTime?.hour.toString().padLeft(2, '0')}:${letter.sendTime?.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12, color: letter.isDelivered ? Colors.green : AppTheme.lightText.withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
