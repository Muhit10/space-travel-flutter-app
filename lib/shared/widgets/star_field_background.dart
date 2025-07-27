import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_01_space_travel/shared/providers/user_preferences_provider.dart';

class Star {
  late double x;
  late double y;
  late double size;
  late double brightness;
  late double speed;
  late double angle;
  
  Star(double maxWidth, double maxHeight) {
    final random = math.Random();
    x = random.nextDouble() * maxWidth;
    y = random.nextDouble() * maxHeight;
    size = random.nextDouble() * 2.5 + 0.5; // Size between 0.5 and 3.0
    brightness = random.nextDouble() * 0.7 + 0.3; // Brightness between 0.3 and 1.0
    speed = random.nextDouble() * 0.5 + 0.1; // Speed between 0.1 and 0.6
    angle = random.nextDouble() * 2 * math.pi; // Random angle for movement direction
  }
  
  void update(double delta, double maxWidth, double maxHeight) {
    // Move star based on its speed and angle
    x += math.cos(angle) * speed * delta;
    y += math.sin(angle) * speed * delta;
    
    // Wrap around if star goes off screen
    if (x < 0) x = maxWidth;
    if (x > maxWidth) x = 0;
    if (y < 0) y = maxHeight;
    if (y > maxHeight) y = 0;
    
    // Twinkle effect - slightly vary brightness
    final random = math.Random();
    brightness += (random.nextDouble() * 0.1 - 0.05) * delta;
    brightness = brightness.clamp(0.3, 1.0);
  }
}

class StarFieldBackground extends StatefulWidget {
  final int starCount;
  final Color starColor;
  final Color backgroundColor;
  final bool animate;
  final Widget? child;
  
  const StarFieldBackground({
    Key? key,
    this.starCount = 150,
    this.starColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.animate = true,
    this.child,
  }) : super(key: key);
  
  @override
  State<StarFieldBackground> createState() => _StarFieldBackgroundState();
}

class _StarFieldBackgroundState extends State<StarFieldBackground> with SingleTickerProviderStateMixin {
  late List<Star> _stars;
  late AnimationController _controller;
  late Size _size;
  late DateTime _lastUpdateTime;
  
  @override
  void initState() {
    super.initState();
    
    _stars = [];
    _size = Size.zero;
    _lastUpdateTime = DateTime.now();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    
    _controller.addListener(_updateStars);
  }
  
  @override
  void dispose() {
    _controller.removeListener(_updateStars);
    _controller.dispose();
    super.dispose();
  }
  
  void _initializeStars(Size size) {
    if (_size != size) {
      _size = size;
      _stars = List.generate(
        widget.starCount,
        (_) => Star(size.width, size.height),
      );
    }
  }
  
  void _updateStars() {
    if (!widget.animate) return;
    
    final now = DateTime.now();
    final delta = now.difference(_lastUpdateTime).inMilliseconds / 1000; // Convert to seconds
    _lastUpdateTime = now;
    
    for (final star in _stars) {
      star.update(delta, _size.width, _size.height);
    }
    
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    final userPrefs = Provider.of<UserPreferencesProvider>(context);
    final useHighQuality = userPrefs.highQualityGraphics;
    
    // Adjust star count based on graphics quality
    final effectiveStarCount = useHighQuality ? widget.starCount : (widget.starCount * 0.6).round();
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initializeStars(size);
        
        return Container(
          width: size.width,
          height: size.height,
          color: widget.backgroundColor,
          child: Stack(
            children: [
              // Stars
              CustomPaint(
                size: size,
                painter: StarFieldPainter(
                  stars: _stars.take(effectiveStarCount).toList(),
                  starColor: widget.starColor,
                  useHighQuality: useHighQuality,
                ),
              ),
              
              // Optional child widget
              if (widget.child != null) widget.child!,
            ],
          ),
        );
      },
    );
  }
}

class StarFieldPainter extends CustomPainter {
  final List<Star> stars;
  final Color starColor;
  final bool useHighQuality;
  
  StarFieldPainter({
    required this.stars,
    required this.starColor,
    this.useHighQuality = true,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final paint = Paint()
        ..color = starColor.withOpacity(star.brightness)
        ..style = PaintingStyle.fill;
      
      if (useHighQuality && star.size > 1.5) {
        // Draw glow effect for larger stars
        final glowPaint = Paint()
          ..color = starColor.withOpacity(star.brightness * 0.3)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
        
        canvas.drawCircle(
          Offset(star.x, star.y),
          star.size * 1.5,
          glowPaint,
        );
      }
      
      // Draw star
      canvas.drawCircle(
        Offset(star.x, star.y),
        star.size,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(StarFieldPainter oldDelegate) {
    return oldDelegate.stars != stars || 
           oldDelegate.starColor != starColor ||
           oldDelegate.useHighQuality != useHighQuality;
  }
}

class ParallaxStarField extends StatefulWidget {
  final int starCount;
  final Color starColor;
  final Color backgroundColor;
  final Widget? child;
  final double parallaxFactor;
  
  const ParallaxStarField({
    Key? key,
    this.starCount = 200,
    this.starColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.child,
    this.parallaxFactor = 0.1,
  }) : super(key: key);
  
  @override
  State<ParallaxStarField> createState() => _ParallaxStarFieldState();
}

class _ParallaxStarFieldState extends State<ParallaxStarField> {
  late List<Star> _nearStars;
  late List<Star> _midStars;
  late List<Star> _farStars;
  Offset _offset = Offset.zero;
  
  @override
  void initState() {
    super.initState();
    _nearStars = [];
    _midStars = [];
    _farStars = [];
  }
  
  void _initializeStars(Size size) {
    if (_nearStars.isEmpty) {
      final starCountPerLayer = widget.starCount ~/ 3;
      
      _nearStars = List.generate(
        starCountPerLayer,
        (_) => Star(size.width, size.height),
      );
      
      _midStars = List.generate(
        starCountPerLayer,
        (_) => Star(size.width, size.height),
      );
      
      _farStars = List.generate(
        widget.starCount - (starCountPerLayer * 2),
        (_) => Star(size.width, size.height),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final userPrefs = Provider.of<UserPreferencesProvider>(context);
    final useHighQuality = userPrefs.highQualityGraphics;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initializeStars(size);
        
        return GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _offset += details.delta;
            });
          },
          child: Container(
            width: size.width,
            height: size.height,
            color: widget.backgroundColor,
            child: Stack(
              children: [
                // Far stars (slow parallax)
                CustomPaint(
                  size: size,
                  painter: ParallaxStarLayerPainter(
                    stars: _farStars,
                    starColor: widget.starColor,
                    offset: _offset * (widget.parallaxFactor * 0.2),
                    useHighQuality: useHighQuality,
                  ),
                ),
                
                // Mid stars (medium parallax)
                CustomPaint(
                  size: size,
                  painter: ParallaxStarLayerPainter(
                    stars: _midStars,
                    starColor: widget.starColor,
                    offset: _offset * (widget.parallaxFactor * 0.5),
                    useHighQuality: useHighQuality,
                  ),
                ),
                
                // Near stars (fast parallax)
                CustomPaint(
                  size: size,
                  painter: ParallaxStarLayerPainter(
                    stars: _nearStars,
                    starColor: widget.starColor,
                    offset: _offset * widget.parallaxFactor,
                    useHighQuality: useHighQuality,
                  ),
                ),
                
                // Optional child widget
                if (widget.child != null) widget.child!,
              ],
            ),
          ),
        );
      },
    );
  }
}

class ParallaxStarLayerPainter extends CustomPainter {
  final List<Star> stars;
  final Color starColor;
  final Offset offset;
  final bool useHighQuality;
  
  ParallaxStarLayerPainter({
    required this.stars,
    required this.starColor,
    required this.offset,
    this.useHighQuality = true,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      // Apply parallax effect
      final adjustedX = (star.x + offset.dx) % size.width;
      final adjustedY = (star.y + offset.dy) % size.height;
      
      final paint = Paint()
        ..color = starColor.withOpacity(star.brightness)
        ..style = PaintingStyle.fill;
      
      if (useHighQuality && star.size > 1.5) {
        // Draw glow effect for larger stars
        final glowPaint = Paint()
          ..color = starColor.withOpacity(star.brightness * 0.3)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
        
        canvas.drawCircle(
          Offset(adjustedX, adjustedY),
          star.size * 1.5,
          glowPaint,
        );
      }
      
      // Draw star
      canvas.drawCircle(
        Offset(adjustedX, adjustedY),
        star.size,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(ParallaxStarLayerPainter oldDelegate) {
    return oldDelegate.stars != stars || 
           oldDelegate.starColor != starColor ||
           oldDelegate.offset != offset ||
           oldDelegate.useHighQuality != useHighQuality;
  }
}