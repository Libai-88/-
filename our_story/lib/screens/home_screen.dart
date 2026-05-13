import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime _anniversary = DateTime(2024, 1, 1);

  int get _daysTogether {
    return DateTime.now().difference(_anniversary).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildMainTitle(),
              const SizedBox(height: 48),
              _buildWeatherCard(),
              const SizedBox(height: 32),
              _buildDistanceCard(),
              const SizedBox(height: 32),
              _buildHeartDecoration(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainTitle() {
    return Column(
      children: [
        const Text('💕', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 8),
        Text(
          '我们已经在一起',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$_daysTogether',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 56,
                    color: AppTheme.primaryPink,
                  ),
            ),
            const SizedBox(width: 8),
            Text('天', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildWeatherItem(
              emoji: '☀️',
              city: '我的城市',
              weather: '晴',
              temp: '28°C',
            ),
          ),
          Container(
            width: 1,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade200,
                  Colors.grey.shade400,
                  Colors.grey.shade200,
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildWeatherItem(
              emoji: '🌧️',
              city: 'Ta的城市',
              weather: '小雨',
              temp: '18°C',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherItem({
    required String emoji,
    required String city,
    required String weather,
    required String temp,
  }) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 8),
        Text(city, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(weather, style: Theme.of(context).textTheme.titleMedium),
        Text(
          temp,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
        ),
      ],
    );
  }

  Widget _buildDistanceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border, color: AppTheme.primaryPink, size: 24),
          const SizedBox(width: 12),
          Text(
            '我们相距 3.2 公里',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartDecoration() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSmallHeart(),
            const SizedBox(width: 20),
            _buildBigHeart(),
            const SizedBox(width: 20),
            _buildSmallHeart(),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          '每一天都是新的开始',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat('yyyy年MM月dd日').format(DateTime.now()),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightText.withOpacity(0.7),
              ),
        ),
      ],
    );
  }

  Widget _buildSmallHeart() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: AppTheme.primaryPink.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildBigHeart() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            AppTheme.primaryPink,
            AppTheme.primaryPink.withOpacity(0.6),
          ],
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
