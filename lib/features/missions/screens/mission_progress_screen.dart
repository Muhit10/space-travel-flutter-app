import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/core/navigation/app_router.dart';
import 'package:random_01_space_travel/features/missions/models/mission_model.dart';
import 'package:random_01_space_travel/features/missions/providers/missions_provider.dart';
import 'package:random_01_space_travel/features/planets/models/planet_model.dart';
import 'package:random_01_space_travel/features/planets/providers/planets_provider.dart';
import 'package:random_01_space_travel/shared/models/graphics_quality.dart';
import 'package:random_01_space_travel/shared/providers/animations_provider.dart';
import 'package:random_01_space_travel/shared/providers/audio_provider.dart';
import 'package:random_01_space_travel/shared/providers/user_preferences_provider.dart';
import 'package:random_01_space_travel/shared/services/haptic_service.dart';
import 'package:random_01_space_travel/shared/widgets/glass_card.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';
import 'package:random_01_space_travel/shared/widgets/space_button.dart';
import 'package:random_01_space_travel/shared/widgets/star_field_background.dart';

class MissionProgressScreen extends StatefulWidget {
  final String missionId;
  
  const MissionProgressScreen({Key? key, required this.missionId}) : super(key: key);

  @override
  State<MissionProgressScreen> createState() => _MissionProgressScreenState();
}

class _MissionProgressScreenState extends State<MissionProgressScreen> with TickerProviderStateMixin {
  late AnimationController _orbitController;
  late AnimationController _pulseController;
  late AnimationController _pathController;
  late Animation<double> _pathAnimation;
  
  // For manual progress control (demo purposes)
  bool _showProgressControls = false;
  
  @override
  void initState() {
    super.initState();
    
    // Setup orbit animation controller
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    // Setup pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Setup path animation controller
    _pathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _pathAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pathController,
      curve: Curves.easeInOut,
    ));
    
    // Load mission data if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
      final planetsProvider = Provider.of<PlanetsProvider>(context, listen: false);
      
      if (missionsProvider.selectedMission?.id != widget.missionId) {
        missionsProvider.selectMission(widget.missionId);
      }
      
      // Load planet data for this mission
      final mission = missionsProvider.selectedMission;
      if (mission != null && planetsProvider.selectedPlanet?.id != mission.planetId) {
        planetsProvider.selectPlanet(mission.planetId);
      }
      
      // Play background sound
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.playSoundEffect(SoundEffect.ambient);
      
      // Animate path based on mission progress
      if (mission != null) {
        _pathController.value = mission.completionPercentage / 100;
      }
    });
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  void _updateMissionProgress(double progress) {
    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
    final mission = missionsProvider.selectedMission;
    
    if (mission != null) {
      // Update mission progress
      missionsProvider.updateMissionProgress(mission.id, progress);
      
      // Animate to new progress
      _pathController.animateTo(
        progress / 100,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      
      // Play sound effect
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.playSoundEffect(SoundEffect.notification);
      
      // Trigger haptic feedback
      HapticService().feedback(HapticFeedbackType.medium);
      
      // If mission is complete
      if (progress >= 100) {
        // Play success sound
        audioProvider.playSoundEffect(SoundEffect.success);
        
        // Trigger success haptic feedback
        HapticService().feedback(HapticFeedbackType.success);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final missionsProvider = Provider.of<MissionsProvider>(context);
    final planetsProvider = Provider.of<PlanetsProvider>(context);
    final userPreferences = Provider.of<UserPreferencesProvider>(context);
    
    final mission = missionsProvider.selectedMission;
    final planet = planetsProvider.selectedPlanet;
    
    if (mission == null || planet == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final isHighQuality = userPreferences.graphicsQuality == GraphicsQuality.high;
    
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          StarFieldBackground(
            starCount: isHighQuality ? 200 : 100,
            backgroundColor: Colors.black,
          ),
          
          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      SpaceIconButton(
                        icon: Icons.arrow_back,
                        onPressed: () => context.go(AppRoutes.home),
                        soundEffect: SoundEffect.buttonClick,
                        hapticFeedback: HapticFeedbackType.light,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MISSION PROGRESS',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              mission.name,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.secondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Mission status indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: mission.getStatusColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: mission.getStatusColor()),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getStatusIcon(mission.status),
                              color: mission.getStatusColor(),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              mission.status.toString().split('.').last.toUpperCase(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: mission.getStatusColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Mission visualization
                Expanded(
                  child: Stack(
                    children: [
                      // Orbit visualization
                      Center(
                        child: _buildOrbitVisualization(planet, mission),
                      ),
                      
                      // Mission details overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _buildMissionDetails(mission, planet),
                      ),
                      
                      // Progress controls (for demo purposes)
                      if (_showProgressControls)
                        Positioned(
                          top: 0,
                          right: 16,
                          child: _buildProgressControls(mission),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Demo controls toggle button
          Positioned(
            bottom: 16,
            right: 16,
            child: SpaceIconButton(
              icon: Icons.settings,
              onPressed: () {
                setState(() {
                  _showProgressControls = !_showProgressControls;
                });
                
                // Play sound effect
                final audioProvider = Provider.of<AudioProvider>(context, listen: false);
                audioProvider.playSoundEffect(SoundEffect.buttonClick);
                
                // Trigger haptic feedback
                HapticService().feedback(HapticFeedbackType.light);
              },
              soundEffect: SoundEffect.buttonClick,
              hapticFeedback: HapticFeedbackType.light,
              size: 24.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrbitVisualization(Planet planet, Mission mission) {
    final size = MediaQuery.of(context).size;
    final smallerDimension = math.min(size.width, size.height) * 0.8;
    
    return SizedBox(
      width: smallerDimension,
      height: smallerDimension,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Orbit path
          CustomPaint(
            size: Size(smallerDimension, smallerDimension),
            painter: OrbitPathPainter(
              progress: _pathAnimation.value,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          
          // Planet
          Center(
            child: Container(
              width: smallerDimension * 0.3,
              height: smallerDimension * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.spaceBlue,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: planet.imagePath.toLowerCase().endsWith('.svg')
                    ? SvgPicture.asset(
                        planet.imagePath,
                        width: smallerDimension * 0.15,
                        height: smallerDimension * 0.15,
                        fit: BoxFit.contain,
                      )
                    : Icon(
                        Icons.public,
                        size: smallerDimension * 0.15,
                        color: Color.fromARGB(
                          255,
                          100 + (planet.name.length * 20) % 155,
                          150 + (planet.name.length * 15) % 105,
                          200 + (planet.name.length * 10) % 55,
                        ),
                      ),
              ),
            ),
          ),
          
          // Spaceship
          AnimatedBuilder(
            animation: _orbitController,
            builder: (context, child) {
              // Calculate position based on orbit progress and animation
              final angle = 2 * math.pi * (_orbitController.value - 0.25);
              final orbitRadius = smallerDimension * 0.4;
              
              // Only show spaceship if mission is in progress or completed
              if (mission.status == MissionStatus.scheduled) {
                return const SizedBox.shrink();
              }
              
              // For in-progress missions, position based on completion percentage
              double positionAngle;
              if (mission.status == MissionStatus.inProgress) {
                // Use path animation value for smooth transitions
                positionAngle = 2 * math.pi * (_pathAnimation.value - 0.25);
              } else {
                // For completed missions, continue orbiting
                positionAngle = angle;
              }
              
              final dx = math.cos(positionAngle) * orbitRadius;
              final dy = math.sin(positionAngle) * orbitRadius;
              
              return Transform.translate(
                offset: Offset(dx, dy),
                child: Transform.rotate(
                  angle: positionAngle + math.pi / 2, // Rotate to face direction of travel
                  child: _buildSpaceship(smallerDimension * 0.08),
                ),
              );
            },
          ),
          
          // Progress indicator
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  '${mission.completionPercentage}%',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 10,
                    width: smallerDimension * 0.7,
                    child: LinearProgressIndicator(
                      value: mission.completionPercentage / 100,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpaceship(double size) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: size,
          height: size * 1.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size * 0.2),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.secondary.withOpacity(
                  0.3 + 0.2 * _pulseController.value,
                ),
                blurRadius: 10 + 5 * _pulseController.value,
                spreadRadius: 2 + 2 * _pulseController.value,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Spaceship body
              Center(
                child: Icon(
                  Icons.rocket,
                  color: Theme.of(context).colorScheme.primary,
                  size: size * 0.8,
                ),
              ),
              
              // Engine glow
              Positioned(
                bottom: -size * 0.2,
                left: 0,
                right: 0,
                child: Container(
                  height: size * 0.4,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                        Theme.of(context).colorScheme.secondary.withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      radius: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMissionDetails(Mission mission, Planet planet) {
    final theme = Theme.of(context);
    
    return GlassCard(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      blur: 10,
      opacity: 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mission details
          Row(
            children: [
              // Mission type icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  mission.getTypeIcon(),
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              // Mission details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.type.toString().split('.').last.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').trim(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'To ${planet.name}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Mission price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    mission.getFormattedPrice(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duration: ${mission.durationInDays} days',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const Divider(color: Colors.white24, height: 32),
          
          // Mission stats
          Row(
            children: [
              _buildMissionStat(
                'Departure',
                DateFormat('MMM dd, yyyy').format(mission.departureDate),
                Icons.calendar_today,
              ),
              _buildMissionStat(
                'Spaceship',
                mission.spaceshipModel,
                Icons.rocket,
              ),
              _buildMissionStat(
                'Captain',
                mission.captainName,
                Icons.person,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Mission status message
          _buildStatusMessage(mission),
        ],
      ),
    );
  }

  Widget _buildMissionStat(String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.secondary,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMessage(Mission mission) {
    final theme = Theme.of(context);
    String message = '';
    IconData icon = Icons.info;
    
    switch (mission.status) {
      case MissionStatus.scheduled:
        message = 'Your mission is scheduled. Prepare for departure on ${DateFormat('MMMM dd, yyyy').format(mission.departureDate)}.'; 
        icon = Icons.schedule;
        break;
      case MissionStatus.inProgress:
        if (mission.completionPercentage < 25) {
          message = 'Mission launched! Leaving Earth\'s atmosphere. Enjoy the ride!';
        } else if (mission.completionPercentage < 50) {
          message = 'Cruising through space. Current distance: ${(mission.completionPercentage / 2).round()} million km from Earth.';
        } else if (mission.completionPercentage < 75) {
          message = 'Approaching ${mission.planetId}. Preparing for orbital insertion.';
        } else {
          message = 'Almost there! Preparing for landing procedures.';
        }
        icon = Icons.rocket_launch;
        break;
      case MissionStatus.completed:
        message = 'Mission successfully completed! You have reached ${mission.planetId}.';
        icon = Icons.check_circle;
        break;
      case MissionStatus.cancelled:
        message = 'Mission was cancelled. Contact mission control for details.';
        icon = Icons.cancel;
        break;
      case MissionStatus.aborted:
        message = 'Mission was aborted due to unforeseen circumstances. Contact mission control for details.';
        icon = Icons.error;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mission.getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: mission.getStatusColor().withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: mission.getStatusColor(),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressControls(Mission mission) {
    final theme = Theme.of(context);
    
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 12,
      blur: 10,
      opacity: 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DEMO CONTROLS',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Start mission button
              if (mission.status == MissionStatus.scheduled)
                SpaceButton(
                  text: 'START',
                  onPressed: () {
                    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
                    missionsProvider.startMission(mission.id);
                    _updateMissionProgress(1); // Start with 1% progress
                    
                    // Play sound effect
                    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
                    audioProvider.playSoundEffect(SoundEffect.launch);
                    
                    // Trigger haptic feedback
                    HapticService().feedback(HapticFeedbackType.heavy);
                  },
                  size: SpaceButtonSize.small,
                  soundEffect: SoundEffect.buttonClick,
                  hapticFeedback: HapticFeedbackType.medium,
                ),
              
              // Progress control buttons
              if (mission.status == MissionStatus.inProgress) ...[                
                SpaceButton(
                  text: '+10%',
                  onPressed: () {
                    final newProgress = math.min(mission.completionPercentage + 10, 100);
                    _updateMissionProgress(newProgress.toDouble());
                  },
                  size: SpaceButtonSize.small,
                  soundEffect: SoundEffect.buttonClick,
                  hapticFeedback: HapticFeedbackType.light,
                ),
                const SizedBox(width: 8),
                SpaceButton(
                  text: '+25%',
                  onPressed: () {
                    final newProgress = math.min(mission.completionPercentage + 25, 100);
                    _updateMissionProgress(newProgress.toDouble());
                  },
                  size: SpaceButtonSize.small,
                  soundEffect: SoundEffect.buttonClick,
                  hapticFeedback: HapticFeedbackType.light,
                ),
                const SizedBox(width: 8),
                SpaceButton(
                  text: 'COMPLETE',
                  onPressed: () {
                    _updateMissionProgress(100);
                  },
                  size: SpaceButtonSize.small,
                  soundEffect: SoundEffect.buttonClick,
                  hapticFeedback: HapticFeedbackType.medium,
                ),
              ],
              
              // Cancel mission button
              if (mission.status != MissionStatus.completed && mission.status != MissionStatus.cancelled) ...[                
                const SizedBox(width: 8),
                SpaceButton(
                  text: 'CANCEL',
                  onPressed: () {
                    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
                    missionsProvider.cancelMission(mission.id);
                    
                    // Play sound effect
                    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
                    audioProvider.playSoundEffect(SoundEffect.error);
                    
                    // Trigger haptic feedback
                    HapticService().feedback(HapticFeedbackType.error);
                  },
                  size: SpaceButtonSize.small,
                  backgroundColor: Colors.red,
                  soundEffect: SoundEffect.buttonClick,
                  hapticFeedback: HapticFeedbackType.medium,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(MissionStatus status) {
    switch (status) {
      case MissionStatus.scheduled:
        return Icons.schedule;
      case MissionStatus.inProgress:
        return Icons.rocket_launch;
      case MissionStatus.completed:
        return Icons.check_circle;
      case MissionStatus.cancelled:
        return Icons.cancel;
      case MissionStatus.aborted:
        return Icons.error;
      default:
        return Icons.info;
    }
  }
}

// Custom painter for orbit path
class OrbitPathPainter extends CustomPainter {
  final double progress;
  final Color color;
  
  OrbitPathPainter({required this.progress, required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // Draw full orbit path (gray)
    final fullPathPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, radius, fullPathPaint);
    
    // Draw progress path (colored)
    final progressPathPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    final progressPath = Path();
    progressPath.addArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Arc angle based on progress
    );
    
    canvas.drawPath(progressPath, progressPathPaint);
    
    // Draw glow effect for progress path
    final glowPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    canvas.drawPath(progressPath, glowPaint);
    
    // Draw small dots along the orbit path
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    
    const totalDots = 24;
    for (int i = 0; i < totalDots; i++) {
      final angle = 2 * math.pi * i / totalDots;
      final dotRadius = i % 3 == 0 ? 2.0 : 1.0; // Larger dot every 3rd position
      
      final dotX = center.dx + radius * math.cos(angle);
      final dotY = center.dy + radius * math.sin(angle);
      
      canvas.drawCircle(Offset(dotX, dotY), dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(OrbitPathPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

// Extension to capitalize first letter of a string
extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}