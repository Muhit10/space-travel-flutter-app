import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';
import 'package:random_01_space_travel/features/missions/mission_model.dart';

class MissionProgressScreen extends StatefulWidget {
  final String missionId;

  const MissionProgressScreen({
    Key? key,
    required this.missionId,
  }) : super(key: key);

  @override
  State<MissionProgressScreen> createState() => _MissionProgressScreenState();
}

class _MissionProgressScreenState extends State<MissionProgressScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _progress = 0.0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _controller.addListener(() {
      setState(() {
        _progress = _controller.value;
        if (_progress >= 1.0) {
          _isCompleted = true;
        }
      });
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.starWhite),
            onPressed: () => context.pop(),
          ),
          const Expanded(
            child: Text(
              'Mission in Progress',
              style: TextStyle(
                color: AppTheme.starWhite,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balance for the back button
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rocket animation
          Icon(
            Icons.rocket_launch,
            size: 100,
            color: AppTheme.neonBlue,
          ).animate(
            onComplete: (controller) => controller.repeat(),
          ).moveY(
            begin: 0,
            end: -20,
            duration: 1.seconds,
            curve: Curves.easeInOut,
          ).then().moveY(
            begin: -20,
            end: 0,
            duration: 1.seconds,
            curve: Curves.easeInOut,
          ),
          
          const SizedBox(height: AppConstants.spacingXL),
          
          // Progress indicator
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: AppTheme.deepSpace.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.neonBlue),
            minHeight: 10,
          ),
          
          const SizedBox(height: AppConstants.spacingM),
          
          Text(
            _isCompleted ? 'Mission Completed!' : 'Mission in Progress...',
            style: const TextStyle(
              color: AppTheme.starWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingXL),
          
          if (_isCompleted)
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.neonBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingXL,
                  vertical: AppConstants.spacingM,
                ),
              ),
              child: const Text('Return to Base'),
            ),
        ],
      ),
    );
  }
}