import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? width;
  final double? height;
  final Alignment alignment;
  final BoxConstraints? constraints;
  final bool hasShadow;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Gradient? gradient;
  final double opacity;
  final Border? border;
  
  const GlassCard({
    Key? key,
    required this.child,
    this.borderRadius = 15.0,
    this.blur = 10.0,
    this.borderColor = Colors.white30,
    this.backgroundColor = Colors.white10,
    this.borderWidth = 1.5,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.constraints,
    this.hasShadow = true,
    this.boxShadow,
    this.onTap,
    this.onLongPress,
    this.gradient,
    this.opacity = 1.0,
    this.border,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final defaultShadows = [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 15,
        offset: const Offset(0, 5),
      ),
    ];
    
    final cardContent = Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      constraints: constraints,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: hasShadow ? (boxShadow ?? defaultShadows) : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - borderWidth),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                color: gradient == null ? backgroundColor : null,
                gradient: gradient,
                borderRadius: BorderRadius.circular(borderRadius - borderWidth),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
    
    if (onTap != null || onLongPress != null) {
      return Padding(
        padding: margin,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: Colors.white24,
            highlightColor: Colors.white10,
            child: cardContent,
          ),
        ),
      );
    }
    
    return Padding(
      padding: margin,
      child: cardContent,
    );
  }
}

class AnimatedGlassCard extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? width;
  final double? height;
  final Alignment alignment;
  final BoxConstraints? constraints;
  final bool hasShadow;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool animate;
  final Duration animationDuration;
  final Curve animationCurve;
  final BoxShadow? shadow;
  final Gradient? gradient;
  final double opacity;
  final Border? border;
  
  const AnimatedGlassCard({
    Key? key,
    required this.child,
    this.borderRadius = 15.0,
    this.blur = 10.0,
    this.borderColor = Colors.white30,
    this.backgroundColor = Colors.white10,
    this.borderWidth = 1.5,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.constraints,
    this.hasShadow = true,
    this.boxShadow,
    this.onTap,
    this.onLongPress,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.shadow,
    this.gradient,
    this.opacity = 0.7,
    this.border,
  }) : super(key: key);
  
  @override
  State<AnimatedGlassCard> createState() => _AnimatedGlassCardState();
}

class _AnimatedGlassCardState extends State<AnimatedGlassCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    ));
    
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
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
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value * widget.opacity,
            child: GlassCard(
              child: widget.child,
              borderRadius: widget.borderRadius,
              blur: widget.blur,
              borderColor: widget.borderColor,
              backgroundColor: widget.backgroundColor,
              borderWidth: widget.borderWidth,
              padding: widget.padding,
              margin: widget.margin,
              width: widget.width,
              height: widget.height,
              alignment: widget.alignment,
              constraints: widget.constraints,
              hasShadow: widget.hasShadow,
              boxShadow: widget.shadow != null ? [widget.shadow!] : widget.boxShadow,
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              gradient: widget.gradient,
              opacity: widget.opacity,
              border: widget.border,
            ),
          ),
        );
      },
    );
  }
}