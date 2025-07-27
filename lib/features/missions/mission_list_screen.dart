import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';
import 'package:random_01_space_travel/features/missions/book_mission_screen.dart';
import 'package:random_01_space_travel/core/navigation/app_router.dart';

class MissionListScreen extends StatelessWidget {
  const MissionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.spaceGradient,
        ),
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Available Missions',
                  style: AppTheme.headingMedium,
                ),
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
                        child: Center(
                          child: Icon(
                            Icons.rocket_launch,
                            size: 80,
                            color: AppTheme.starWhite.withOpacity(0.2),
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
                  ],
                ),
              ),
            ),
            
            // Filter options
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: _buildFilterOptions(),
              ),
            ),
            
            // Mission list
            SliverPadding(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Generate mission data
                    final planetIndex = index % AppConstants.planetNames.length;
                    final planetName = AppConstants.planetNames[planetIndex];
                    final missionType = AppConstants.missionTypes[index % AppConstants.missionTypes.length];
                    final daysUntil = 10 + (index * 5);
                    final price = 10000 + (planetIndex * 5000) + ((index % 3) * 2000);
                    
                    return _buildMissionCard(
                      planetName: planetName,
                      missionType: missionType,
                      daysUntil: daysUntil,
                      price: price,
                      index: index,
                      context: context,
                    );
                  },
                  childCount: 20, // Show 20 missions
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFilterOptions() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Missions',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Row(
            children: [
              Expanded(
                child: _buildFilterChip('All Planets'),
              ),
              const SizedBox(width: AppConstants.spacingS),
              Expanded(
                child: _buildFilterChip('All Types'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingS),
          Row(
            children: [
              Expanded(
                child: _buildFilterChip('Price Range'),
              ),
              const SizedBox(width: AppConstants.spacingS),
              Expanded(
                child: _buildFilterChip('Date Range'),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: AppConstants.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppTheme.deepSpace,
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
        border: Border.all(
          color: AppTheme.neonBlue.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.bodySmall,
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: AppTheme.neonBlue,
            size: AppConstants.iconSizeS,
          ),
        ],
      ),
    );
  }
  
  Widget _buildMissionCard({
    required String planetName,
    required String missionType,
    required int daysUntil,
    required int price,
    required int index,
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.spacingM),
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
          // Mission image
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusM),
              ),
              // Use SVG image instead of PNG
            ),
            child: Stack(
              children: [
                // Planet image
                Center(
                  child: SvgPicture.asset(
                    'assets/images/planet_${index % 5}.svg',
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
                      color: AppTheme.neonPink,
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
          
          // Mission details
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mission info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(
                      Icons.calendar_today,
                      'Departure',
                      'In $daysUntil days',
                    ),
                    _buildInfoItem(
                      Icons.access_time,
                      'Duration',
                      '${2 + (index % 10)} months',
                    ),
                    _buildInfoItem(
                      Icons.group,
                      'Capacity',
                      '${5 + (index % 15)} seats',
                    ),
                  ],
                ),
                
                const SizedBox(height: AppConstants.spacingM),
                const Divider(color: AppTheme.spaceGrey),
                const SizedBox(height: AppConstants.spacingM),
                
                // Price and book button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price per person',
                          style: AppTheme.bodySmall,
                        ),
                        Text(
                          '$price credits',
                          style: AppTheme.headingSmall.copyWith(
                            color: AppTheme.neonPink,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/home/book-mission/$planetName');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neonPink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingL,
                          vertical: AppConstants.spacingM,
                        ),
                      ),
                      child: Text(
                        'Book Now',
                        style: AppTheme.buttonText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: (100 * index).ms, duration: 400.ms)
      .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.neonBlue,
          size: AppConstants.iconSizeM,
        ),
        const SizedBox(height: AppConstants.spacingXS),
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
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
}