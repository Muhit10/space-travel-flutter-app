import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.spaceGradient,
        ),
        child: CustomScrollView(
          slivers: [
            // App bar with profile image
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Background image
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.deepSpace,
                              AppTheme.spacePurple,
                            ],
                          ),
                        ),
                        child: Opacity(
                          opacity: 0.2,
                          child: Icon(
                            Icons.star,
                            size: 100,
                            color: AppTheme.starWhite,
                          ),
                        ),
                      ),
                    ),
                    
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppTheme.deepSpace.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Profile image and name
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.neonPink,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.neonPink.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                ),
                              ],
                              color: AppTheme.deepSpace,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: AppTheme.neonBlue,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingM),
                          Text(
                            'Commander Alex',
                            style: AppTheme.headingLarge,
                          ),
                          Text(
                            'Space Explorer Level 3',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.neonBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Profile stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                child: _buildProfileStats(),
              ),
            ),
            
            // Upcoming trips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingL,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Upcoming Trips',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    _buildUpcomingTrips(context),
                  ],
                ),
              ),
            ),
            
            // Past journeys
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Past Journeys',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    _buildPastJourneys(context),
                  ],
                ),
              ),
            ),
            
            // Settings section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    _buildSettingsSection(context),
                  ],
                ),
              ),
            ),
            
            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: AppConstants.spacingXXL),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileStats() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.spaceBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppTheme.neonBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Trips', '7'),
          _buildStatItem('Planets', '4'),
          _buildStatItem('Miles', '18.2M'),
          _buildStatItem('Credits', '32.5K'),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.headingMedium.copyWith(
            color: AppTheme.neonPink,
          ),
        ),
        const SizedBox(height: AppConstants.spacingXS),
        Text(
          label,
          style: AppTheme.bodySmall,
        ),
      ],
    );
  }
  
  Widget _buildUpcomingTrips(BuildContext context) {
    return Column(
      children: [
        _buildTripCard(
          planetName: 'Mars',
          missionType: 'Exploration',
          date: 'June 15, 2025',
          imageIndex: 3,
          isUpcoming: true,
          context: context,
        ),
        const SizedBox(height: AppConstants.spacingM),
        _buildTripCard(
          planetName: 'Europa',
          missionType: 'Research',
          date: 'August 22, 2025',
          imageIndex: 5,
          isUpcoming: true,
          context: context,
        ),
      ],
    );
  }
  
  Widget _buildPastJourneys(BuildContext context) {
    return Column(
      children: [
        _buildTripCard(
          planetName: 'Moon',
          missionType: 'Tourism',
          date: 'March 10, 2025',
          imageIndex: 1,
          isUpcoming: false,
          rating: 4.5,
          context: context,
        ),
        const SizedBox(height: AppConstants.spacingM),
        _buildTripCard(
          planetName: 'Venus Orbit',
          missionType: 'Observation',
          date: 'January 5, 2025',
          imageIndex: 2,
          isUpcoming: false,
          rating: 5.0,
          context: context,
        ),
      ],
    );
  }
  
  Widget _buildTripCard({
    required String planetName,
    required String missionType,
    required String date,
    required int imageIndex,
    required bool isUpcoming,
    double? rating,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.spaceBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppTheme.neonBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip image
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusM),
              ),
              // Use SVG image instead of PNG
            ),
            child: Stack(
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/images/planet_$imageIndex.svg',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppConstants.radiusM),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.deepSpace.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Mission type badge
                Positioned(
                  top: AppConstants.spacingM,
                  left: AppConstants.spacingM,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingM,
                      vertical: AppConstants.spacingS,
                    ),
                    decoration: BoxDecoration(
                      color: isUpcoming ? AppTheme.neonPink : AppTheme.neonBlue,
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: Text(
                      missionType,
                      style: AppTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Planet name
                Positioned(
                  bottom: AppConstants.spacingM,
                  left: AppConstants.spacingM,
                  child: Text(
                    planetName,
                    style: AppTheme.headingMedium,
                  ),
                ),
              ],
            ),
          ),
          
          // Trip details
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppTheme.neonBlue,
                          size: AppConstants.iconSizeS,
                        ),
                        const SizedBox(width: AppConstants.spacingS),
                        Text(
                          date,
                          style: AppTheme.bodyMedium,
                        ),
                      ],
                    ),
                    if (rating != null) ...[  
                      const SizedBox(height: AppConstants.spacingS),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: AppConstants.iconSizeS,
                          ),
                          const SizedBox(width: AppConstants.spacingS),
                          Text(
                            '$rating/5.0',
                            style: AppTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Show trip details
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isUpcoming ? 'View details for $planetName $missionType mission' : 'Journey Memories for $planetName $missionType mission'),
                        backgroundColor: AppTheme.deepSpace,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(AppConstants.spacingM),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusM),
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUpcoming ? AppTheme.neonPink : AppTheme.neonBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingM,
                      vertical: AppConstants.spacingS,
                    ),
                  ),
                  child: Text(
                    isUpcoming ? 'View Details' : 'View Memories',
                    style: AppTheme.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.spaceBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppTheme.neonBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            'Edit Profile',
            Icons.person,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Profile editing will be available soon'),
                  backgroundColor: AppTheme.deepSpace,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(AppConstants.spacingM),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
          ),
          const Divider(color: AppTheme.spaceGrey),
          _buildSettingsItem(
            'Payment Methods',
            Icons.payment,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Payment method management will be available soon'),
                  backgroundColor: AppTheme.deepSpace,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(AppConstants.spacingM),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
          ),
          const Divider(color: AppTheme.spaceGrey),
          _buildSettingsItem(
            'Notifications',
            Icons.notifications,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Notification settings will be available soon'),
                  backgroundColor: AppTheme.deepSpace,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(AppConstants.spacingM),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                ),
              );
            },
          ),
          const Divider(color: AppTheme.spaceGrey),
          _buildSettingsItem(
            'Help & Support',
            Icons.help,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Support center will be available soon'),
                  backgroundColor: AppTheme.deepSpace,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(AppConstants.spacingM),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                ),
              );
            },
          ),
          const Divider(color: AppTheme.spaceGrey),
          _buildSettingsItem(
            'Log Out',
            Icons.exit_to_app,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppTheme.deepSpace,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    side: BorderSide(
                      color: AppTheme.neonBlue.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  title: Text(
                    'Log Out',
                    style: AppTheme.headingMedium,
                  ),
                  content: Text(
                    'Are you sure you want to log out?',
                    style: AppTheme.bodyMedium,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        'Cancel',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.neonBlue,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('You have been logged out successfully'),
                            backgroundColor: AppTheme.deepSpace,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(AppConstants.spacingM),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neonPink,
                      ),
                      child: Text(
                        'Log Out',
                        style: AppTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildSettingsItem(String title, IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.neonBlue,
              size: AppConstants.iconSizeM,
            ),
            const SizedBox(width: AppConstants.spacingM),
            Text(
              title,
              style: AppTheme.bodyLarge,
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.neonBlue,
              size: AppConstants.iconSizeS,
            ),
          ],
        ),
      ),
    );
  }
}