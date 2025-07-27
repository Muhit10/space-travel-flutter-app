import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';
import 'package:random_01_space_travel/features/planets/planet_detail_screen.dart';
import 'package:random_01_space_travel/features/planets/providers/planets_provider.dart';
import 'package:random_01_space_travel/features/profile/profile_screen.dart';
import 'package:random_01_space_travel/features/missions/mission_list_screen.dart';


class HomeScreen extends StatefulWidget {
  final Widget? child;
  const HomeScreen({this.child, super.key});
  
  // Static method to allow navigation from other widgets
  static void navigateToTab(BuildContext context, int index) {
    final homeState = context.findAncestorStateOfType<_HomeScreenState>();
    if (homeState != null) {
      homeState._onItemTapped(index);
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeContent(),
    const MissionListScreen(),
    const ProfileScreen(), // Using the imported ProfileScreen
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  // This method is used by other widgets to access the navigation
  static void navigateToTab(BuildContext context, int index) {
    final homeState = context.findAncestorStateOfType<_HomeScreenState>();
    if (homeState != null) {
      homeState._onItemTapped(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.spaceGradient,
        ),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppTheme.neonBlue,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rocket_launch),
              label: 'Missions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});
  
  // Method to navigate to a specific tab
  void _onItemTapped(BuildContext context, int index) {
    HomeScreen.navigateToTab(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            title: Text(
              AppConstants.welcomeTitle,
              style: AppTheme.headingMedium,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Show notifications
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  context.go('/settings');
                },
              ),
            ],
          ),
          
          // Welcome section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore the cosmos',
                    style: AppTheme.headingLarge,
                  )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 100.ms)
                    .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 8),
                  Text(
                    'Discover new worlds and plan your next space adventure',
                    style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
                  )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
          
          // Featured planets section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Destinations',
                        style: AppTheme.headingSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to all planets
                        },
                        child: Text(
                          'View All',
                          style: AppTheme.buttonText.copyWith(color: AppTheme.neonBlue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // Replace with actual planet count
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to planet detail
                              context.go('/planets/$index');
                            },
                            child: Container(
                              width: 160,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.neonBlue.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: Container(
                                      height: 120,
                                      width: double.infinity,
                                      color: Colors.black,
                                      child: Center(
                                        child: Builder(builder: (context) {
                                          final planetsProvider = Provider.of<PlanetsProvider>(context, listen: false);
                                          final planets = planetsProvider.filteredPlanets;
                                          final planet = index < planets.length ? planets[index] : null;
                                          
                                          if (planet != null && planet.imagePath.toLowerCase().endsWith('.svg')) {
                                            return SvgPicture.asset(
                                              planet.imagePath,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.contain,
                                            );
                                          }
                                          
                                          return Icon(
                                            Icons.public,
                                            size: 60,
                                            color: Color.fromARGB(
                                              255,
                                              100 + (index * 20) % 155,
                                              150 + (index * 15) % 105,
                                              200 + (index * 10) % 55,
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Planet ${index + 1}',
                                          style: AppTheme.headingSmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.amber,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${4 + (index % 10) / 10}',
                                              style: AppTheme.captionText,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${1000 + index * 100} ly',
                                              style: AppTheme.captionText.copyWith(color: Colors.white54),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 100.ms * index)
                          .slideX(begin: 0.2, end: 0);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Upcoming missions section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Missions',
                        style: AppTheme.headingSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to missions tab
                          _onItemTapped(context, 1);
                        },
                        child: Text(
                          'View All',
                          style: AppTheme.buttonText.copyWith(color: AppTheme.neonBlue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3, // Show only 3 missions
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppTheme.spaceBlue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.neonBlue.withOpacity(0.3)),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.rocket_launch,
                                  color: AppTheme.neonBlue,
                                ),
                              ),
                            ),
                            title: Text(
                              'Mission to Planet ${index + 1}',
                              style: AppTheme.bodyLarge,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.white54,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Launching in ${10 - index} days',
                                    style: AppTheme.captionText.copyWith(color: Colors.white54),
                                  ),
                                ],
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white54,
                            ),
                            onTap: () {
                              // Navigate to mission detail
                              context.go('/missions/$index');
                            },
                          ),
                        ),
                      )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 100.ms * index)
                        .slideY(begin: 0.1, end: 0);
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Space news section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Space News',
                    style: AppTheme.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: List.generate(3, (index) {
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              title: Text(
                                'Space News Headline ${index + 1}',
                                style: AppTheme.bodyLarge,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam in dui mauris.',
                                  style: AppTheme.bodySmall.copyWith(color: Colors.white70),
                                ),
                              ),
                              trailing: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.newspaper,
                                    size: 30,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              onTap: () {
                                // TODO: Open news detail
                              },
                            ),
                            if (index < 2)
                              const Divider(height: 1, color: Colors.white10),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // TODO: View all news
                      },
                      child: Text(
                        'View All News',
                        style: AppTheme.buttonText.copyWith(color: AppTheme.neonBlue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}