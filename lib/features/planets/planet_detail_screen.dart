import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';
import 'package:random_01_space_travel/features/missions/book_mission_screen.dart';
import 'package:random_01_space_travel/core/navigation/app_router.dart';

class PlanetDetailScreen extends StatelessWidget {
  final String planetName;
  
  const PlanetDetailScreen({super.key, required this.planetName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.spaceGradient,
        ),
        child: CustomScrollView(
          slivers: [
            // App bar with planet image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Planet image
                    Positioned.fill(
                      child: Hero(
                        tag: 'planet_$planetName',
                        child: Container(
                          color: AppTheme.spaceBlue,
                          child: Center(
                            child: Icon(
                              Icons.public,
                              size: 120,
                              color: Color.fromARGB(
                                255,
                                100 + (AppConstants.planetNames.indexOf(planetName) * 20) % 155,
                                150 + (AppConstants.planetNames.indexOf(planetName) * 15) % 105,
                                200 + (AppConstants.planetNames.indexOf(planetName) * 10) % 55,
                              ),
                            ),
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
                    
                    // Planet name
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Text(
                        planetName,
                        style: AppTheme.headingLarge,
                      ),
                    ),
                  ],
                ),
              ),
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.deepSpace.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.deepSpace.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border),
                  ),
                  onPressed: () {
                    // TODO: Add to favorites
                  },
                ),
                const SizedBox(width: AppConstants.spacingS),
              ],
            ),
            
            // Planet details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick facts
                    _buildQuickFacts(),
                    
                    const SizedBox(height: AppConstants.spacingL),
                    
                    // Description
                    Text(
                      'About $planetName',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    Text(
                      _getPlanetDescription(planetName),
                      style: AppTheme.bodyLarge,
                    ),
                    
                    const SizedBox(height: AppConstants.spacingXL),
                    
                    // Available missions
                    Text(
                      'Available Missions',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    
                    // Mission cards
                    _buildMissionCards(),
                    
                    const SizedBox(height: AppConstants.spacingXL),
                    
                    // Gallery
                    Text(
                      'Gallery',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    
                    // Image gallery
                    _buildGallery(),
                    
                    const SizedBox(height: AppConstants.spacingXXL),
                    
                    // Book trip button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/home/book-mission/$planetName');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.spacingM,
                          ),
                          backgroundColor: AppTheme.neonPink,
                        ),
                        child: Text(
                          'Book Your Trip',
                          style: AppTheme.buttonText,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickFacts() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.spaceBlue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFactItem('Distance', '${(150 + AppConstants.planetNames.indexOf(planetName) * 50)} M km', Icons.public),
          _buildFactItem('Travel Time', '${(2 + AppConstants.planetNames.indexOf(planetName))} months', Icons.access_time),
          _buildFactItem('Temperature', '${(-100 + AppConstants.planetNames.indexOf(planetName) * 20)}°C', Icons.thermostat),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildFactItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.neonBlue,
          size: AppConstants.iconSizeM,
        ),
        const SizedBox(height: AppConstants.spacingS),
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
  
  Widget _buildMissionCards() {
    final missionTypes = AppConstants.missionTypes;
    
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Show only 3 mission types
        itemBuilder: (context, index) {
          final missionType = missionTypes[index % missionTypes.length];
          
          return Container(
            width: 250,
            margin: EdgeInsets.only(
              right: index < 2 ? AppConstants.spacingM : 0,
            ),
            decoration: BoxDecoration(
              color: AppTheme.spaceBlue.withOpacity(0.7),
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
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppConstants.radiusM),
                    ),
                    color: AppTheme.spacePurple,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.rocket,
                      size: 50,
                      color: index % 2 == 0 ? AppTheme.neonBlue : AppTheme.neonPink,
                    ),
                  ),
                ),
                
                // Mission info
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        missionType,
                        style: AppTheme.headingSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppConstants.spacingXS),
                      Text(
                        'Starting from ${10000 + index * 5000} credits',
                        style: AppTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate()
            .fadeIn(delay: (100 * index).ms, duration: 400.ms)
            .slideX(begin: 0.1, end: 0);
        },
      ),
    );
  }
  
  Widget _buildGallery() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 160,
            margin: EdgeInsets.only(
              right: index < 4 ? AppConstants.spacingM : 0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(
                    255,
                    100 + (index * 30) % 155,
                    150 + (index * 20) % 105,
                    200 + (index * 15) % 55,
                  ),
                  Color.fromARGB(
                    255,
                    100 + (AppConstants.planetNames.indexOf(planetName) * 20) % 155,
                    150 + (AppConstants.planetNames.indexOf(planetName) * 15) % 105,
                    200 + (AppConstants.planetNames.indexOf(planetName) * 10) % 55,
                  ),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.photo,
                size: 40,
                color: AppTheme.starWhite.withOpacity(0.7),
              ),
            ),
          ).animate()
            .fadeIn(delay: (100 * index).ms, duration: 400.ms)
            .slideX(begin: 0.1, end: 0);
        },
      ),
    );
  }
  
  String _getPlanetDescription(String planetName) {
    // Sample descriptions for each planet
    final Map<String, String> descriptions = {
      'Mercury': 'The smallest and innermost planet in the Solar System. Its orbit around the Sun takes 87.97 Earth days, the shortest of all the planets.',
      'Venus': 'The second planet from the Sun. It is named after the Roman goddess of love and beauty. As the brightest natural object in Earth\'s night sky after the Moon, Venus can cast shadows and can be visible to the naked eye in broad daylight.',
      'Earth': 'Our home planet is the third planet from the Sun, and the only astronomical object known to harbor life. About 71% of Earth\'s surface is covered with water, making it the "Blue Planet".',
      'Mars': 'The fourth planet from the Sun and the second-smallest planet in the Solar System. Mars is often referred to as the "Red Planet" because of the iron oxide prevalent on its surface, which gives it a reddish appearance.',
      'Jupiter': 'The fifth planet from the Sun and the largest in the Solar System. It is a gas giant with a mass one-thousandth that of the Sun, but two-and-a-half times that of all the other planets in the Solar System combined.',
      'Saturn': 'The sixth planet from the Sun and the second-largest in the Solar System, after Jupiter. It is a gas giant with an average radius about nine times that of Earth. It has only one-eighth the average density of Earth.',
      'Uranus': 'The seventh planet from the Sun. It has the third-largest planetary radius and fourth-largest planetary mass in the Solar System. Uranus is similar in composition to Neptune, and both have bulk chemical compositions which differ from that of the larger gas giants Jupiter and Saturn.',
      'Neptune': 'The eighth and farthest known planet from the Sun in the Solar System. It is the fourth-largest planet by diameter, the third-most-massive planet, and the densest giant planet. Neptune is 17 times the mass of Earth and is slightly more massive than its near-twin Uranus.',
      'Kepler-186f': 'The first validated Earth-sized planet to orbit a distant star in the habitable zone—a range of distance from a star where liquid water might pool on the planet\'s surface. The planet orbits its star once every 130 days and receives one-third the energy that Earth does from the sun.',
      'TRAPPIST-1e': 'A rocky exoplanet orbiting within the habitable zone of the ultra-cool dwarf star TRAPPIST-1. It is the fourth planet in the TRAPPIST-1 system, which contains a total of seven known planets. TRAPPIST-1e is very similar to Earth in size, density, and the amount of radiation it receives from its host star.',
      'HD 209458 b': 'An exoplanet that orbits the Sun-like star HD 209458 in the constellation Pegasus, approximately 159 light-years from Earth. Also known as "Osiris", it was the first planet to be seen transiting its star, and the first exoplanet known to have an atmosphere.',
      'Proxima Centauri b': 'An exoplanet orbiting within the habitable zone of the red dwarf star Proxima Centauri, which is the closest star to the Sun and part of a triple star system. It is located about 4.2 light-years from Earth in the constellation of Centaurus.',
    };
    
    return descriptions[planetName] ?? 
      'A mysterious celestial body with unique characteristics waiting to be explored by brave space travelers. Scientists are still studying its composition and atmosphere.';
  }
}