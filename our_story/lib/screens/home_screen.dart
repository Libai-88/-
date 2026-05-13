import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime anniversaryDate = DateTime(2023, 1, 1);
  bool _showPetals = false;
  final bool _bothSunny = true; // 模拟两个都是晴天的状态

  int get daysTogether {
    final now = DateTime.now();
    return now.difference(anniversaryDate).inDays;
  }

  void _onDoubleTap() {
    if (!_showPetals) {
      setState(() => _showPetals = true);
    }
  }

  void _onPetalsComplete() {
    setState(() => _showPetals = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GradientBackground(
            child: SafeArea(
              child: GestureDetector(
                onDoubleTap: _onDoubleTap,
                behavior: HitTestBehavior.translucent,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        FadeInWidget(
                          delay: const Duration(milliseconds: 100),
                          child: _buildHeader(),
                        ),
                        const SizedBox(height: 28),
                        FadeInWidget(
                          delay: const Duration(milliseconds: 250),
                          child: _buildDaysCounter(),
                        ),
                        const SizedBox(height: 28),
                        FadeInWidget(
                          delay: const Duration(milliseconds: 400),
                          child: _buildWeatherSection(),
                        ),
                        const SizedBox(height: 20),
                        FadeInWidget(
                          delay: const Duration(milliseconds: 550),
                          child: _buildDistanceCard(),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_bothSunny) const SunParticles(),
          if (_showPetals)
            Positioned.fill(child: PetalFall(onComplete: _onPetalsComplete)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        PulseWidget(
          child: Text(
            '🏠',
            style: TextStyle(fontSize: 52),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '我们的关系小屋',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          DateFormat('yyyy年MM月dd日 EEEE', 'zh_CN').format(DateTime.now()),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildDaysCounter() {
    return SoftCard(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Text(
            '我们已经在一起',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.warmBrown.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              PulseWidget(
                child: TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: daysTogether),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: TextStyle(
                        fontSize: 68,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepRose,
                        fontFamily: 'Dancing Script',
                        height: 1,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '天',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.warmBrown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAnniversaryInfo(),
        ],
      ),
    );
  }

  Widget _buildAnniversaryInfo() {
    final nextAnniversary = _getNextAnniversary();
    final daysUntilNext = nextAnniversary.difference(DateTime.now()).inDays;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.celebration_rounded,
            color: AppColors.deepRose,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '下一个纪念日还有 $daysUntilNext 天 ❤️',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  DateTime _getNextAnniversary() {
    final now = DateTime.now();
    var nextAnniversary = DateTime(now.year, anniversaryDate.month, anniversaryDate.day);
    if (nextAnniversary.isBefore(now) || nextAnniversary.isAtSameMomentAs(now)) {
      nextAnniversary = DateTime(now.year + 1, anniversaryDate.month, anniversaryDate.day);
    }
    return nextAnniversary;
  }

  Widget _buildWeatherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                color: AppColors.primaryPink,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '彼此的天气',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(child: _buildWeatherCard(isMe: true)),
            const SizedBox(width: 14),
            Expanded(child: _buildWeatherCard(isMe: false)),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherCard({required bool isMe}) {
    final weather = isMe 
        ? {'icon': '☀️', 'temp': '28°', 'city': '我的城市', 'condition': '晴'}
        : {'icon': '☀️', 'temp': '26°', 'city': 'Ta的城市', 'condition': '晴'};
    
    return SoftCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Text(
            weather['icon']!,
            style: TextStyle(fontSize: 42),
          ),
          const SizedBox(height: 10),
          Text(
            weather['condition']!,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.warmBrown.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            weather['temp']!,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.deepRose,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            weather['city']!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceCard() {
    return SoftCard(
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.softPink,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.distance_rounded,
              color: AppColors.deepRose,
              size: 30,
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '我们相距',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.warmBrown.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '3.2',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.deepRose,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '公里',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.favorite_rounded,
            color: AppColors.primaryPink.withOpacity(0.5),
            size: 28,
          ),
        ],
      ),
    );
  }
}
