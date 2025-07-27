import 'package:flutter/material.dart';
import 'package:random_01_space_travel/features/planets/planet_model.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';

class PlanetsProvider extends ChangeNotifier {
  final List<Planet> _planets = [];
  
  List<Planet> get planets => _planets;
  
  Planet? getPlanetById(String id) {
    try {
      return _planets.firstWhere((planet) => planet.id == id);
    } catch (e) {
      return null;
    }
  }
  
  void addPlanet(Planet planet) {
    _planets.add(planet);
    notifyListeners();
  }
  
  void updatePlanet(Planet planet) {
    final index = _planets.indexWhere((p) => p.id == planet.id);
    if (index != -1) {
      _planets[index] = planet;
      notifyListeners();
    }
  }
  
  void updateExplorationProgress(String id, int progress) {
    final planet = getPlanetById(id);
    if (planet != null) {
      updatePlanet(
        planet.copyWith(explorationProgress: progress),
      );
    }
  }
  
  // Initialize with some sample planets
  void initializeSamplePlanets() {
    _planets.addAll([
      Planet(
        id: 'mars',
        name: 'Mars',
        description: 'The Red Planet is the fourth planet from the Sun. It has a thin atmosphere and is home to the largest volcano in the solar system, Olympus Mons.',
        distanceFromEarth: 225.0, // million km (average)
        diameter: 6779.0, // km
        gravity: 0.38, // relative to Earth
        temperature: -65, // average Celsius
        hasAtmosphere: true,
        hasWater: true, // ice caps
        isHabitable: false,
        keyFeatures: [
          'Red surface due to iron oxide',
          'Has two small moons: Phobos and Deimos',
          'Experiences dust storms that can cover the entire planet',
          'Contains evidence of ancient river valleys and lake beds',
        ],
        color: AppTheme.marsRed,
        explorationProgress: 65,
      ),
      Planet(
        id: 'moon',
        name: 'Moon',
        description: 'Earth\'s only natural satellite and the fifth largest moon in the solar system. It has no atmosphere and is covered in craters from asteroid impacts.',
        distanceFromEarth: 0.384, // million km (average)
        diameter: 3474.0, // km
        gravity: 0.166, // relative to Earth
        temperature: -20, // average Celsius (varies widely)
        hasAtmosphere: false,
        hasWater: true, // ice at poles
        isHabitable: false,
        keyFeatures: [
          'Synchronous rotation - always shows the same face to Earth',
          'Surface covered in regolith (fine dust and rock fragments)',
          'Has been visited by humans during the Apollo missions',
          'Experiences extreme temperature variations',
        ],
        color: AppTheme.moonGray,
        explorationProgress: 80,
      ),
      Planet(
        id: 'jupiter',
        name: 'Jupiter',
        description: 'The largest planet in our solar system, Jupiter is a gas giant with a turbulent atmosphere and the famous Great Red Spot - a storm larger than Earth.',
        distanceFromEarth: 588.0, // million km (average)
        diameter: 139820.0, // km
        gravity: 2.4, // relative to Earth
        temperature: -145, // average Celsius
        hasAtmosphere: true,
        hasWater: true, // in atmosphere
        isHabitable: false,
        keyFeatures: [
          'Has at least 79 moons, including the four large Galilean moons',
          'Great Red Spot has been observed for over 300 years',
          'Strongest magnetic field of any planet in the solar system',
          'Composed mainly of hydrogen and helium',
        ],
        color: AppTheme.jupiterOrange,
        explorationProgress: 40,
      ),
      Planet(
        id: 'venus',
        name: 'Venus',
        description: 'Often called Earth\'s sister planet due to similar size, Venus has a toxic atmosphere and is the hottest planet in our solar system due to runaway greenhouse effect.',
        distanceFromEarth: 41.0, // million km (closest approach)
        diameter: 12104.0, // km
        gravity: 0.91, // relative to Earth
        temperature: 462, // average Celsius
        hasAtmosphere: true,
        hasWater: false,
        isHabitable: false,
        keyFeatures: [
          'Rotates in the opposite direction to most planets',
          'Thick atmosphere composed mainly of carbon dioxide',
          'Surface pressure is 92 times that of Earth',
          'Covered in volcanic features',
        ],
        color: AppTheme.nebulaPink,
        explorationProgress: 30,
      ),
      Planet(
        id: 'saturn',
        name: 'Saturn',
        description: 'Famous for its spectacular ring system, Saturn is a gas giant composed mainly of hydrogen and helium with a small rocky core.',
        distanceFromEarth: 1200.0, // million km (average)
        diameter: 116460.0, // km
        gravity: 1.07, // relative to Earth
        temperature: -178, // average Celsius
        hasAtmosphere: true,
        hasWater: true, // in atmosphere and rings
        isHabitable: false,
        keyFeatures: [
          'Has the most extensive ring system of any planet',
          'Has at least 82 moons, including Titan, which has its own atmosphere',
          'Less dense than water - would float if placed in a giant bathtub',
          'Hexagonal cloud pattern at its north pole',
        ],
        color: AppTheme.meteorGrey,
        explorationProgress: 35,
      ),
    ]);
  }
}