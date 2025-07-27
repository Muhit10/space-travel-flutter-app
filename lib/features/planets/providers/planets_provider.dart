import 'package:flutter/material.dart';
import 'package:random_01_space_travel/features/planets/data/planets_repository.dart';
import 'package:random_01_space_travel/features/planets/models/planet_model.dart';

class PlanetsProvider extends ChangeNotifier {
  final PlanetsRepository _repository = PlanetsRepository();
  
  // All planets
  List<Planet> _planets = [];
  List<Planet> get planets => _planets;
  
  // Selected planet
  Planet? _selectedPlanet;
  Planet? get selectedPlanet => _selectedPlanet;
  
  // Filtered planets
  List<Planet> _filteredPlanets = [];
  List<Planet> get filteredPlanets => _filteredPlanets;
  
  // Filter options
  bool _showExploredOnly = false;
  bool get showExploredOnly => _showExploredOnly;
  
  double _minDifficulty = 0.0;
  double get minDifficulty => _minDifficulty;
  
  double _maxDifficulty = 10.0;
  double get maxDifficulty => _maxDifficulty;
  
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  
  // Initialize provider
  PlanetsProvider() {
    _loadPlanets();
  }
  
  // Load planets from repository
  void _loadPlanets() {
    _planets = _repository.getAllPlanets();
    _applyFilters();
    notifyListeners();
  }
  
  // Public method to reload planets
  void loadPlanets() {
    _loadPlanets();
  }
  
  // Select a planet
  void selectPlanet(String planetId) {
    _selectedPlanet = _repository.getPlanetById(planetId);
    notifyListeners();
  }
  
  // Clear selected planet
  void clearSelectedPlanet() {
    _selectedPlanet = null;
    notifyListeners();
  }
  
  // Set exploration filter
  void setExploredOnlyFilter(bool value) {
    _showExploredOnly = value;
    _applyFilters();
    notifyListeners();
  }
  
  // Set difficulty range filter
  void setDifficultyRange(double min, double max) {
    _minDifficulty = min;
    _maxDifficulty = max;
    _applyFilters();
    notifyListeners();
  }
  
  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }
  
  // Apply all filters
  void _applyFilters() {
    _filteredPlanets = _planets;
    
    // Apply exploration filter
    if (_showExploredOnly) {
      _filteredPlanets = _filteredPlanets.where((planet) => planet.isExplored).toList();
    }
    
    // Apply difficulty range filter
    _filteredPlanets = _filteredPlanets
        .where((planet) =>
            planet.explorationDifficulty >= _minDifficulty &&
            planet.explorationDifficulty <= _maxDifficulty)
        .toList();
    
    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      _filteredPlanets = _filteredPlanets
          .where((planet) =>
              planet.name.toLowerCase().contains(query) ||
              planet.description.toLowerCase().contains(query) ||
              planet.galaxyLocation.toLowerCase().contains(query))
          .toList();
    }
  }
  
  // Reset all filters
  void resetFilters() {
    _showExploredOnly = false;
    _minDifficulty = 0.0;
    _maxDifficulty = 10.0;
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }
  
  // Get planets by exploration status
  List<Planet> getPlanetsByExplorationStatus(bool isExplored) {
    return _planets.where((planet) => planet.isExplored == isExplored).toList();
  }
  
  // Get planets by difficulty range
  List<Planet> getPlanetsByDifficultyRange(double min, double max) {
    return _planets
        .where((planet) =>
            planet.explorationDifficulty >= min &&
            planet.explorationDifficulty <= max)
        .toList();
  }
  
  // Get planet by id
  Planet? getPlanetById(String id) {
    return _repository.getPlanetById(id);
  }
}