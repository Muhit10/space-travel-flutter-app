import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:random_01_space_travel/features/planets/models/planet_model.dart';
import 'package:random_01_space_travel/shared/providers/audio_provider.dart';
import 'package:random_01_space_travel/shared/services/haptic_service.dart';


class PlanetCard extends StatefulWidget {
  final Planet planet;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool animate;
  final bool showDetails;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  
  const PlanetCard({
    Key? key,
    required this.planet,
    this.onTap,
    this.isSelected = false,
    this.animate = true,
    this.showDetails = true,
    this.width = 280,
    this.height = 320,
    this.margin = const EdgeInsets.all(12.0),
  }) : super(key: key);
  
  @override
  State<PlanetCard> createState() => _PlanetCardState();
}

class _PlanetCardState extends State<PlanetCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  
  bool _isHovering = false;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 5.0,
      end: 15.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }
  
  @override
  void didUpdateWidget(PlanetCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleTap() {
    // Play sound effect
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSoundEffect(SoundEffect.buttonClick);
    
    // Trigger haptic feedback
    HapticService().feedback(HapticFeedbackType.light);
    
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }
  
  void _handleHoverChanged(bool isHovering) {
    if (_isHovering != isHovering) {
      setState(() {
        _isHovering = isHovering;
      });
      
      if (isHovering && !widget.isSelected) {
        _controller.forward();
      } else if (!isHovering && !widget.isSelected) {
        _controller.reverse();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.animate ? _scaleAnimation.value : 1.0,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(widget.animate ? _rotationAnimation.value : 0.0),
            child: MouseRegion(
              onEnter: (_) => _handleHoverChanged(true),
              onExit: (_) => _handleHoverChanged(false),
              child: GestureDetector(
                onTap: _handleTap,
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  margin: widget.margin,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.3),
                        blurRadius: widget.animate ? _elevationAnimation.value : 5.0,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.surface,
                        theme.colorScheme.surface.withOpacity(0.8),
                      ],
                    ),
                    border: Border.all(
                      color: widget.isSelected || _isHovering
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      children: [
                        // Background gradient
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  theme.colorScheme.primary.withOpacity(0.1),
                                  theme.colorScheme.primary.withOpacity(0.2),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Planet image with rotation animation
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Hero(
                                    tag: 'planet-${widget.planet.id}',
                                    child: _PlanetImage(
                                      imagePath: widget.planet.imagePath,
                                      isSelected: widget.isSelected || _isHovering,
                                    ),
                                  ),
                                ),
                              ),
                              
                              if (widget.showDetails) ...[  
                                const SizedBox(height: 16),
                                
                                // Planet name
                                Text(
                                  widget.planet.name,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Planet location
                                Text(
                                  widget.planet.galaxyLocation,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Planet stats
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildStat(
                                      context,
                                      'Distance',
                                      '${widget.planet.distanceFromEarth} ly',
                                      Icons.route,
                                    ),
                                    _buildStat(
                                      context,
                                      'Gravity',
                                      '${widget.planet.gravity} g',
                                      Icons.fitness_center,
                                    ),
                                    _buildStat(
                                      context,
                                      'Temp',
                                      '${widget.planet.temperature}°C',
                                      Icons.thermostat,
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Exploration status
                                Row(
                                  children: [
                                    Icon(
                                      widget.planet.isExplored
                                          ? Icons.check_circle
                                          : Icons.explore,
                                      color: widget.planet.isExplored
                                          ? Colors.green
                                          : theme.colorScheme.primary,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.planet.isExplored
                                          ? 'Explored'
                                          : 'Unexplored',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: widget.planet.isExplored
                                            ? Colors.green
                                            : theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    _buildDifficultyIndicator(context, widget.planet.explorationDifficulty),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        
                        // Selection indicator
                        if (widget.isSelected)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: theme.colorScheme.onPrimary,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildStat(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 16,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  Widget _buildDifficultyIndicator(BuildContext context, double difficulty) {
    final theme = Theme.of(context);
    
    // Determine color based on difficulty
    Color difficultyColor;
    if (difficulty < 3.0) {
      difficultyColor = Colors.green;
    } else if (difficulty < 7.0) {
      difficultyColor = Colors.orange;
    } else {
      difficultyColor = Colors.red;
    }
    
    return Row(
      children: [
        Text(
          'Difficulty:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 40,
          height: 8,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: difficulty / 10.0,
            child: Container(
              decoration: BoxDecoration(
                color: difficultyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanetImage extends StatefulWidget {
  final String imagePath;
  final bool isSelected;
  
  const _PlanetImage({
    Key? key,
    required this.imagePath,
    this.isSelected = false,
  }) : super(key: key);
  
  @override
  State<_PlanetImage> createState() => _PlanetImageState();
}

class _PlanetImageState extends State<_PlanetImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
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
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: AnimatedScale(
            scale: widget.isSelected ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: widget.imagePath.toLowerCase().endsWith('.svg')
                ? SvgPicture.asset(
                    widget.imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  )
                : Icon(
                    Icons.public,
                    size: 100,
                    color: Color.fromARGB(
                      255,
                      100 + (widget.imagePath.hashCode % 155),
                      150 + (widget.imagePath.hashCode % 105),
                      200 + (widget.imagePath.hashCode % 55),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class PlanetCardCompact extends StatelessWidget {
  final Planet planet;
  final VoidCallback? onTap;
  final bool isSelected;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  
  const PlanetCardCompact({
    Key? key,
    required this.planet,
    this.onTap,
    this.isSelected = false,
    this.width = 160,
    this.height = 180,
    this.margin = const EdgeInsets.all(8.0),
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () {
        // Play sound effect
        final audioProvider = Provider.of<AudioProvider>(context, listen: false);
        audioProvider.playSoundEffect(SoundEffect.buttonClick);
        
        // Trigger haptic feedback
        HapticService().feedback(HapticFeedbackType.light);
        
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // Background gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.primary.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Planet image
                    Expanded(
                      child: Center(
                        child: Hero(
                          tag: 'planet-compact-${planet.id}',
                          child: planet.imagePath.toLowerCase().endsWith('.svg')
                              ? SvgPicture.asset(
                                  planet.imagePath,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                )
                              : Icon(
                                  Icons.public,
                                  size: 80,
                                  color: Color.fromARGB(
                                    255,
                                    100 + (planet.name.hashCode * 20) % 155,
                                    150 + (planet.name.hashCode * 15) % 105,
                                    200 + (planet.name.hashCode * 10) % 55,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Planet name
                    Text(
                      planet.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Distance
                    Row(
                      children: [
                        Icon(
                          Icons.route,
                          color: theme.colorScheme.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${planet.distanceFromEarth} ly',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Selection indicator
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: theme.colorScheme.onPrimary,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}