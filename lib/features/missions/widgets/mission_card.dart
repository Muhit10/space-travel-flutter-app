import 'package:flutter/material.dart';
import 'package:random_01_space_travel/features/missions/models/mission_model.dart';
import 'package:random_01_space_travel/shared/providers/audio_provider.dart';
import 'package:random_01_space_travel/shared/services/haptic_service.dart';
import 'package:random_01_space_travel/shared/widgets/glass_card.dart';
import 'package:provider/provider.dart';

class MissionCard extends StatefulWidget {
  final Mission mission;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showDetails;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  
  const MissionCard({
    Key? key,
    required this.mission,
    this.onTap,
    this.isSelected = false,
    this.showDetails = true,
    this.width = 320,
    this.height = 200,
    this.margin = const EdgeInsets.all(12.0),
  }) : super(key: key);
  
  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  
  bool _isHovering = false;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }
  
  @override
  void didUpdateWidget(MissionCard oldWidget) {
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
    HapticService().feedback(HapticFeedbackType.medium);
    
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
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _handleHoverChanged(true),
            onExit: (_) => _handleHoverChanged(false),
            child: GestureDetector(
              onTap: _handleTap,
              child: GlassCard(
                width: widget.width,
                height: widget.height,
                margin: widget.margin,
                borderRadius: 20,
                blur: 10,
                opacity: 0.15,
                border: Border.all(
                  color: widget.isSelected || _isHovering
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.1),
                  width: 2,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.surface.withOpacity(0.5),
                    theme.colorScheme.surface.withOpacity(0.3),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.3),
                    blurRadius: _elevationAnimation.value,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: Stack(
                  children: [
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mission header
                          Row(
                            children: [
                              // Mission type icon
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  widget.mission.getTypeIcon(),
                                  color: theme.colorScheme.primary,
                                  size: 24,
                                ),
                              ),
                              
                              const SizedBox(width: 12),
                              
                              // Mission name and type
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.mission.name,
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    const SizedBox(height: 4),
                                    
                                    Text(
                                      widget.mission.type.toString().split('.').last,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Mission price
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  widget.mission.getFormattedPrice(),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          if (widget.showDetails) ...[  
                            const SizedBox(height: 16),
                            
                            // Mission details
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left column - Spaceship info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildDetailItem(
                                          context,
                                          'Spaceship',
                                          widget.mission.spaceshipModel,
                                          Icons.rocket,
                                        ),
                                        
                                        const SizedBox(height: 8),
                                        
                                        _buildDetailItem(
                                          context,
                                          'Captain',
                                          widget.mission.captainName,
                                          Icons.person,
                                        ),
                                        
                                        const Spacer(),
                                        
                                        // Departure date
                                        _buildDetailItem(
                                          context,
                                          'Departure',
                                          widget.mission.formattedDepartureDate,
                                          Icons.calendar_today,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 16),
                                  
                                  // Right column - Status and progress
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Status indicator
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: widget.mission.getStatusColor().withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _getStatusIcon(widget.mission.status),
                                                color: widget.mission.getStatusColor(),
                                                size: 16,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                widget.mission.status.toString().split('.').last,
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: widget.mission.getStatusColor(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 12),
                                        
                                        // Progress indicator (only for in-progress missions)
                                        if (widget.mission.status == MissionStatus.inProgress) ...[  
                                          Text(
                                            'Mission Progress',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                                            ),
                                          ),
                                          
                                          const SizedBox(height: 8),
                                          
                                          _buildProgressIndicator(context),
                                        ],
                                        
                                        const Spacer(),
                                        
                                        // Availability status
                                        Text(
                                          widget.mission.getAvailabilityStatus(),
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: widget.mission.getAvailabilityStatus() != 'Fully Booked'
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
        );
      },
    );
  }
  
  Widget _buildDetailItem(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildProgressIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final progress = widget.mission.completionPercentage;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        Stack(
          children: [
            // Background
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            
            // Progress
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 8,
              width: (widget.width - 32) * 0.5 * (progress / 100), // Adjust width based on container size
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: -1,
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 4),
        
        // Percentage text
        Text(
          '${widget.mission.completionPercentage.toStringAsFixed(1)}%',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
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
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}

class MissionCardCompact extends StatelessWidget {
  final Mission mission;
  final VoidCallback? onTap;
  final bool isSelected;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  
  const MissionCardCompact({
    Key? key,
    required this.mission,
    this.onTap,
    this.isSelected = false,
    this.width = 180,
    this.height = 120,
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // Content
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mission name and type
                    Row(
                      children: [
                        Icon(
                          mission.getTypeIcon(),
                          color: theme.colorScheme.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            mission.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Mission type
                    Text(
                      mission.type.toString().split('.').last,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Spacer(),
                    
                    // Status and price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Status indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: mission.getStatusColor().withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            mission.status.toString().split('.').last,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: mission.getStatusColor(),
                            ),
                          ),
                        ),
                        
                        // Price
                        Text(
                          mission.getFormattedPrice(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
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