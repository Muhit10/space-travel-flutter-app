import 'package:flutter/material.dart';
import 'package:random_01_space_travel/shared/providers/audio_provider.dart';
import 'package:random_01_space_travel/shared/services/haptic_service.dart';
import 'package:provider/provider.dart';

enum SpaceButtonType {
  filled,
  outlined,
  text,
  gradient
}

enum SpaceButtonSize {
  small,
  medium,
  large
}

class SpaceButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final double? iconSize;
  final double elevation;
  final bool hasShadow;
  final bool hasGlow;
  final Color? glowColor;
  final bool hasSound;
  final SoundEffect? soundEffect;
  final bool hasHaptic;
  final HapticFeedbackType? hapticFeedback;
  final TextStyle? textStyle;
  final bool isOutlined;
  final bool isGradient;
  final Gradient? gradient;
  final Widget? child;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final double? minWidth;
  final double? minHeight;
  final SpaceButtonSize? size;
  final SpaceButtonType? type;
  final bool glowOnPressed;
  
  const SpaceButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.onLongPress,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth = 2.0,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    this.width,
    this.height,
    this.iconSize,
    this.elevation = 4.0,
    this.hasShadow = true,
    this.hasGlow = false,
    this.glowColor,
    this.hasSound = true,
    this.soundEffect = SoundEffect.buttonClick,
    this.hasHaptic = true,
    this.hapticFeedback = HapticFeedbackType.light,
    this.textStyle,
    this.isOutlined = false,
    this.isGradient = false,
    this.gradient,
    this.child,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.minWidth,
    this.minHeight,
    this.size = SpaceButtonSize.medium,
    this.type = SpaceButtonType.filled,
    this.glowOnPressed = false,
  }) : super(key: key);
  
  @override
  State<SpaceButton> createState() => _SpaceButtonState();
}

class _SpaceButtonState extends State<SpaceButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _handleTap() {
    if (widget.isDisabled || widget.isLoading) return;
    
    _animationController.forward();
    
    // Play sound effect
    if (widget.hasSound) {
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.playSoundEffect(widget.soundEffect ?? SoundEffect.buttonClick);
    }
    
    // Trigger haptic feedback
    if (widget.hasHaptic) {
      HapticService().feedback(widget.hapticFeedback ?? HapticFeedbackType.light);
    }
    
    // Call onPressed callback
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }
  
  void _handleLongPress() {
    if (widget.isDisabled || widget.isLoading) return;
    
    // Play sound effect
    if (widget.hasSound) {
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.playSoundEffect(SoundEffect.notification);
    }
    
    // Trigger haptic feedback
    if (widget.hasHaptic) {
      HapticService().feedback(HapticFeedbackType.medium);
    }
    
    // Call onLongPress callback
    if (widget.onLongPress != null) {
      widget.onLongPress!();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine button properties based on size
    double buttonPadding;
    double buttonBorderRadius;
    double? buttonIconSize;
    double buttonElevation;
    double? buttonWidth;
    double? buttonHeight;
    double? buttonMinWidth;
    double? buttonMinHeight;
    
    switch (widget.size) {
      case SpaceButtonSize.small:
        buttonPadding = 8.0;
        buttonBorderRadius = 8.0;
        buttonIconSize = 16.0;
        buttonElevation = 2.0;
        buttonMinWidth = 80.0;
        buttonMinHeight = 32.0;
        break;
      case SpaceButtonSize.large:
        buttonPadding = 16.0;
        buttonBorderRadius = 16.0;
        buttonIconSize = 24.0;
        buttonElevation = 6.0;
        buttonMinWidth = 160.0;
        buttonMinHeight = 56.0;
        break;
      case SpaceButtonSize.medium:
      default:
        buttonPadding = 12.0;
        buttonBorderRadius = 12.0;
        buttonIconSize = 20.0;
        buttonElevation = 4.0;
        buttonMinWidth = 120.0;
        buttonMinHeight = 44.0;
        break;
    }
    
    // Determine button appearance based on type
    bool isOutlined = widget.isOutlined;
    bool isGradient = widget.isGradient;
    bool hasGlow = widget.hasGlow;
    
    switch (widget.type) {
      case SpaceButtonType.outlined:
        isOutlined = true;
        isGradient = false;
        break;
      case SpaceButtonType.text:
        isOutlined = false;
        isGradient = false;
        buttonElevation = 0.0;
        break;
      case SpaceButtonType.gradient:
        isOutlined = false;
        isGradient = true;
        break;
      case SpaceButtonType.filled:
      default:
        isOutlined = false;
        isGradient = false;
        break;
    }
    
    // Apply glow effect if specified
    hasGlow = widget.glowOnPressed || widget.hasGlow;
    
    // Default colors based on theme and button type
    final defaultBackgroundColor = isOutlined
        ? Colors.transparent
        : theme.colorScheme.primary;
    
    final defaultTextColor = isOutlined
        ? theme.colorScheme.primary
        : theme.colorScheme.onPrimary;
    
    final defaultBorderColor = theme.colorScheme.primary;
    final defaultGlowColor = theme.colorScheme.primary.withOpacity(0.5);
    
    // Apply disabled state
    final effectiveBackgroundColor = widget.isDisabled
        ? (isOutlined ? Colors.transparent : theme.disabledColor)
        : (widget.backgroundColor ?? defaultBackgroundColor);
    
    final effectiveTextColor = widget.isDisabled
        ? theme.disabledColor
        : (widget.textColor ?? defaultTextColor);
    
    final effectiveBorderColor = widget.isDisabled
        ? theme.disabledColor
        : (widget.borderColor ?? defaultBorderColor);
    
    // Build button content
    Widget buttonContent;
    
    if (widget.isLoading) {
      // Loading state
      buttonContent = SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          ),
        ),
      );
    } else if (widget.child != null) {
      // Custom child
      buttonContent = widget.child!;
    } else {
      // Default text and icon
      buttonContent = Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: [
          if (widget.icon != null) ...[  
            Icon(
              widget.icon,
              color: effectiveTextColor,
              size: widget.iconSize ?? buttonIconSize ?? 20,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            widget.text,
            style: widget.textStyle?.copyWith(color: effectiveTextColor) ??
                theme.textTheme.labelLarge?.copyWith(color: effectiveTextColor),
          ),
        ],
      );
    }
    
    // Build button with decoration
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: _handleTap,
          onLongPress: _handleLongPress,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width ?? buttonWidth,
              height: widget.height ?? buttonHeight,
              constraints: BoxConstraints(
                minWidth: widget.minWidth ?? buttonMinWidth ?? 0,
                minHeight: widget.minHeight ?? buttonMinHeight ?? 0,
              ),
              decoration: BoxDecoration(
                color: isGradient ? null : effectiveBackgroundColor,
                gradient: isGradient ? (widget.gradient ?? _defaultGradient()) : null,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? buttonBorderRadius),
                border: Border.all(
                  color: isOutlined ? effectiveBorderColor : Colors.transparent,
                  width: widget.borderWidth,
                ),
                boxShadow: widget.hasShadow && !widget.isDisabled
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: (widget.elevation ?? buttonElevation) * 2,
                          offset: Offset(0, widget.elevation ?? buttonElevation),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? buttonBorderRadius),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: null, // We're handling taps with GestureDetector
                  child: Container(
                    padding: widget.padding ?? EdgeInsets.symmetric(
                      horizontal: buttonPadding * 2,
                      vertical: buttonPadding
                    ),
                    decoration: hasGlow && !widget.isDisabled
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.borderRadius ?? buttonBorderRadius),
                            boxShadow: [
                              BoxShadow(
                                color: (widget.glowColor ?? defaultGlowColor),
                                blurRadius: 15 * _glowAnimation.value,
                                spreadRadius: 2 * _glowAnimation.value,
                              ),
                            ],
                          )
                        : null,
                    child: buttonContent,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Gradient _defaultGradient() {
    return LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.secondary,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

class SpaceIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool isLoading;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double size;
  final double iconSize;
  final double elevation;
  final bool hasShadow;
  final bool hasGlow;
  final Color? glowColor;
  final bool hasSound;
  final SoundEffect? soundEffect;
  final bool hasHaptic;
  final HapticFeedbackType? hapticFeedback;
  final bool isOutlined;
  final bool isGradient;
  final Gradient? gradient;
  final bool isActive;
  
  const SpaceIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.borderWidth = 2.0,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(8.0),
    this.size = 48.0,
    this.iconSize = 24.0,
    this.elevation = 4.0,
    this.hasShadow = true,
    this.hasGlow = false,
    this.glowColor,
    this.hasSound = true,
    this.soundEffect = SoundEffect.buttonClick,
    this.hasHaptic = true,
    this.hapticFeedback = HapticFeedbackType.light,
    this.isOutlined = false,
    this.isGradient = false,
    this.gradient,
    this.isActive = false,
  }) : super(key: key);
  
  @override
  State<SpaceIconButton> createState() => _SpaceIconButtonState();
}

class _SpaceIconButtonState extends State<SpaceIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _handleTap() {
    if (widget.isDisabled || widget.isLoading) return;
    
    _animationController.forward();
    
    // Play sound effect
    if (widget.hasSound) {
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.playSoundEffect(widget.soundEffect ?? SoundEffect.buttonClick);
    }
    
    // Trigger haptic feedback
    if (widget.hasHaptic) {
      HapticService().feedback(widget.hapticFeedback ?? HapticFeedbackType.light);
    }
    
    // Call onPressed callback
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }
  
  void _handleLongPress() {
    if (widget.isDisabled || widget.isLoading) return;
    
    // Play sound effect
    if (widget.hasSound) {
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.playSoundEffect(SoundEffect.notification);
    }
    
    // Trigger haptic feedback
    if (widget.hasHaptic) {
      HapticService().feedback(HapticFeedbackType.medium);
    }
    
    // Call onLongPress callback
    if (widget.onLongPress != null) {
      widget.onLongPress!();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Default colors based on theme and button type
    final defaultBackgroundColor = widget.isOutlined
        ? Colors.transparent
        : theme.colorScheme.primary;
    
    final defaultIconColor = widget.isOutlined
        ? theme.colorScheme.primary
        : theme.colorScheme.onPrimary;
    
    final defaultBorderColor = theme.colorScheme.primary;
    final defaultGlowColor = theme.colorScheme.primary.withOpacity(0.5);
    
    // Apply disabled or active state
    Color effectiveBackgroundColor;
    if (widget.isDisabled) {
      effectiveBackgroundColor = widget.isOutlined ? Colors.transparent : theme.disabledColor;
    } else if (widget.isActive) {
      effectiveBackgroundColor = widget.backgroundColor ?? theme.colorScheme.secondary;
    } else {
      effectiveBackgroundColor = widget.backgroundColor ?? defaultBackgroundColor;
    }
    
    Color effectiveIconColor;
    if (widget.isDisabled) {
      effectiveIconColor = theme.disabledColor;
    } else if (widget.isActive) {
      effectiveIconColor = widget.iconColor ?? theme.colorScheme.onSecondary;
    } else {
      effectiveIconColor = widget.iconColor ?? defaultIconColor;
    }
    
    Color effectiveBorderColor;
    if (widget.isDisabled) {
      effectiveBorderColor = theme.disabledColor;
    } else if (widget.isActive) {
      effectiveBorderColor = widget.borderColor ?? theme.colorScheme.secondary;
    } else {
      effectiveBorderColor = widget.borderColor ?? defaultBorderColor;
    }
    
    // Build button content
    Widget buttonContent;
    
    if (widget.isLoading) {
      // Loading state
      buttonContent = Center(
        child: SizedBox(
          width: widget.iconSize,
          height: widget.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveIconColor),
          ),
        ),
      );
    } else {
      // Icon
      buttonContent = Icon(
        widget.icon,
        color: effectiveIconColor,
        size: widget.iconSize,
      );
    }
    
    // Build button with decoration
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: _handleTap,
          onLongPress: _handleLongPress,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.isGradient ? null : effectiveBackgroundColor,
                gradient: widget.isGradient ? (widget.gradient ?? _defaultGradient()) : null,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: widget.isOutlined ? effectiveBorderColor : Colors.transparent,
                  width: widget.borderWidth,
                ),
                boxShadow: widget.hasShadow && !widget.isDisabled
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: widget.elevation * 2,
                          offset: Offset(0, widget.elevation),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: null, // We're handling taps with GestureDetector
                  child: Container(
                    padding: widget.padding,
                    decoration: (widget.hasGlow && !widget.isDisabled) || widget.isActive
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                            boxShadow: [
                              BoxShadow(
                                color: widget.isActive 
                                    ? (widget.glowColor ?? theme.colorScheme.secondary.withOpacity(0.7))
                                    : (widget.glowColor ?? defaultGlowColor),
                                blurRadius: widget.isActive 
                                    ? 20 * _glowAnimation.value 
                                    : 15 * _glowAnimation.value,
                                spreadRadius: widget.isActive 
                                    ? 3 * _glowAnimation.value 
                                    : 2 * _glowAnimation.value,
                              ),
                            ],
                          )
                        : null,
                    child: buttonContent,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Gradient _defaultGradient() {
    return LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.secondary,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}