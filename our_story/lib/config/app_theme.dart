import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF8B4C4);
  static const Color softPink = Color(0xFFFFE4E8);
  static const Color cream = Color(0xFFFFF5E6);
  static const Color warmWhite = Color(0xFFFFFBF5);
  static const Color softPeach = Color(0xFFFFE5D9);
  static const Color dustyRose = Color(0xFFE8B4B8);
  static const Color warmBrown = Color(0xFF8B7355);
  static const Color deepRose = Color(0xFFD4838F);
  static const Color softLavender = Color(0xFFE8E0F0);
  static const Color gold = Color(0xFFFFD700);
  static const Color softGold = Color(0xFFFFECB3);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryPink,
      scaffoldBackgroundColor: AppColors.warmWhite,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryPink,
        secondary: AppColors.softPeach,
        surface: AppColors.warmWhite,
        onPrimary: Colors.white,
        onSecondary: AppColors.warmBrown,
        onSurface: AppColors.warmBrown,
        tertiary: AppColors.dustyRose,
      ),
      textTheme: _buildTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.warmWhite,
        foregroundColor: AppColors.warmBrown,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.dancingScript(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.warmBrown,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: AppColors.primaryPink.withOpacity(0.12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPink,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepRose,
          side: const BorderSide(color: AppColors.primaryPink, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.dustyRose, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.nunito(
          color: AppColors.warmBrown.withOpacity(0.5),
          fontSize: 15,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.deepRose,
        unselectedItemColor: AppColors.warmBrown.withOpacity(0.4),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 11,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.warmBrown,
        size: 24,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.dustyRose.withOpacity(0.3),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.warmBrown,
        contentTextStyle: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.dancingScript(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: AppColors.warmBrown,
      ),
      displayMedium: GoogleFonts.dancingScript(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: AppColors.warmBrown,
      ),
      displaySmall: GoogleFonts.dancingScript(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.warmBrown,
      ),
      headlineLarge: GoogleFonts.dancingScript(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.warmBrown,
      ),
      headlineMedium: GoogleFonts.dancingScript(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.warmBrown,
      ),
      headlineSmall: GoogleFonts.dancingScript(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.warmBrown,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.warmBrown,
      ),
      titleMedium: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.warmBrown,
      ),
      titleSmall: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.warmBrown,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.warmBrown,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.warmBrown,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.warmBrown.withOpacity(0.8),
      ),
      labelLarge: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.warmBrown,
      ),
      labelMedium: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.warmBrown,
      ),
      labelSmall: GoogleFonts.nunito(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.warmBrown.withOpacity(0.7),
      ),
    );
  }
}

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const SoftCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.softPeach.withOpacity(0.06),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.warmWhite,
            AppColors.softPink,
            AppColors.cream,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  final double? height;
  final double? width;

  const ImagePlaceholder({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 120,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_rounded,
              color: AppColors.dustyRose.withOpacity(0.5),
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              '📷',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.warmBrown.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double beginOffset;

  const FadeInWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.beginOffset = 16.0,
  });

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.beginOffset / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

class BouncyTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const BouncyTap({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<BouncyTap> createState() => _BouncyTapState();
}

class _BouncyTapState extends State<BouncyTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.93), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.93, end: 1.05), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

class PulseWidget extends StatefulWidget {
  final Widget child;
  final bool animate;

  const PulseWidget({
    super.key,
    required this.child,
    this.animate = true,
  });

  @override
  State<PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<PulseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.04), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.04, end: 1.0), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.02), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 15),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.animate ? _animation.value : 1.0,
          child: widget.child,
        );
      },
    );
  }
}

class HighlightWidget extends StatefulWidget {
  final Widget child;
  final bool highlight;
  final Duration duration;

  const HighlightWidget({
    super.key,
    required this.child,
    this.highlight = false,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<HighlightWidget> createState() => _HighlightWidgetState();
}

class _HighlightWidgetState extends State<HighlightWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _highlightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _highlightAnimation = Tween(begin: 1.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.highlight) {
      _triggerHighlight();
    }
  }

  @override
  void didUpdateWidget(HighlightWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlight && !oldWidget.highlight) {
      _triggerHighlight();
    }
  }

  void _triggerHighlight() {
    _controller.reset();
    _highlightAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 80),
    ]).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: widget.highlight
              ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPink.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16),
                )
              : null,
          child: Transform.scale(
            scale: _highlightAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class PetalFall extends StatefulWidget {
  final VoidCallback onComplete;

  const PetalFall({
    super.key,
    required this.onComplete,
  });

  @override
  State<PetalFall> createState() => _PetalFallState();
}

class _PetalFallState extends State<PetalFall> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<Petal> petals = [];

  @override
  void initState() {
    super.initState();
    final random = Random();
    final count = 8 + random.nextInt(5);
    for (int i = 0; i < count; i++) {
      petals.add(Petal(
        delay: Duration(milliseconds: random.nextInt(500)),
        offset: Offset(random.nextDouble() * 2 - 1, -0.1),
        rotation: random.nextDouble() * pi * 2,
      ));
    }

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: petals.map((petal) {
          return TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 3),
            tween: Tween(begin: 0, end: 1),
            curve: Curves.easeInCubic,
            builder: (context, value, child) {
              final screenSize = MediaQuery.of(context).size;
              final y = (value * screenSize.height * 1.2) - 50;
              final x = petal.offset.dx * screenSize.width * 0.4 + screenSize.width * 0.5;
              final opacity = value > 0.9 ? 1 - (value - 0.9) / 0.1 : 1;

              return Positioned(
                left: x + sin(value * pi * 3) * 20,
                top: y,
                child: Opacity(
                  opacity: opacity,
                  child: Transform.rotate(
                    angle: petal.rotation + value * 2 * pi,
                    child: const Text(
                      '🌸',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class Petal {
  final Duration delay;
  final Offset offset;
  final double rotation;

  Petal({
    required this.delay,
    required this.offset,
    required this.rotation,
  });
}

class EmojiBurst extends StatefulWidget {
  final String emoji;
  final VoidCallback onComplete;

  const EmojiBurst({
    super.key,
    required this.emoji,
    required this.onComplete,
  });

  @override
  State<EmojiBurst> createState() => _EmojiBurstState();
}

class _EmojiBurstState extends State<EmojiBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final value = _controller.value;
          final opacity = value > 0.6 ? 1 - (value - 0.6) / 0.4 : 1;
          final scale = 1 + value * 0.5;
          final offsetY = -value * 60;

          return Transform.translate(
            offset: Offset(0, offsetY),
            child: Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: Text(
                  widget.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SunParticles extends StatefulWidget {
  const SunParticles({super.key});

  @override
  State<SunParticles> createState() => _SunParticlesState();
}

class _SunParticlesState extends State<SunParticles> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<SunParticle> particles = [];
  final random = Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 8; i++) {
      particles.add(SunParticle(
        offset: Offset(random.nextDouble() * 2 - 1, random.nextDouble()),
        size: 10 + random.nextDouble() * 10,
        speed: 0.3 + random.nextDouble() * 0.7,
      ));
    }

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: particles.map((particle) {
              final value = _controller.value * particle.speed;
              final screenSize = MediaQuery.of(context).size;
              final x = particle.offset.dx * screenSize.width * 0.4 + screenSize.width * 0.5;
              final y = particle.offset.dy * screenSize.height * 0.5 + screenSize.height * 0.1;
              final opacity = 0.3 + 0.3 * sin(value * pi);

              return Positioned(
                left: x + sin(value * pi * 2) * 10,
                top: y,
                child: Opacity(
                  opacity: opacity,
                  child: Icon(
                    Icons.wb_sunny_rounded,
                    color: AppColors.softGold.withOpacity(0.6),
                    size: particle.size,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class SunParticle {
  final Offset offset;
  final double size;
  final double speed;

  SunParticle({
    required this.offset,
    required this.size,
    required this.speed,
  });
}

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final bool shake;

  const ShakeWidget({
    super.key,
    required this.child,
    this.shake = true,
  });

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    if (widget.shake) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.shake && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final angle = sin(_shakeAnimation.value * pi * 4) * 0.1;
        return Transform.rotate(
          angle: angle,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class GoldenCelebration extends StatefulWidget {
  final VoidCallback onComplete;

  const GoldenCelebration({
    super.key,
    required this.onComplete,
  });

  @override
  State<GoldenCelebration> createState() => _GoldenCelebrationState();
}

class _GoldenCelebrationState extends State<GoldenCelebration> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<GoldenParticle> particles = [];
  final random = Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 20; i++) {
      particles.add(GoldenParticle(
        angle: (i / 20) * pi * 2,
        distance: 50 + random.nextDouble() * 100,
        size: 4 + random.nextDouble() * 8,
        delay: Duration(milliseconds: random.nextInt(200)),
      ));
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: particles.map((particle) {
          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0, end: 1),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              final opacity = value > 0.7 ? 1 - (value - 0.7) / 0.3 : 1;
              final x = cos(particle.angle) * particle.distance * value;
              final y = sin(particle.angle) * particle.distance * value;

              return Positioned.fill(
                child: Center(
                  child: Transform.translate(
                    offset: Offset(x, y),
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: particle.size,
                        height: particle.size,
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(particle.size),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class GoldenParticle {
  final double angle;
  final double distance;
  final double size;
  final Duration delay;

  GoldenParticle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.delay,
  });
}
