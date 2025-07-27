import 'package:flutter/material.dart';
import 'package:random_01_space_travel/features/missions/data/missions_repository.dart';
import 'package:random_01_space_travel/features/missions/models/mission_model.dart';

class MissionsProvider extends ChangeNotifier {
  final MissionsRepository _repository = MissionsRepository();
  
  // All missions
  List<Mission> _missions = [];
  List<Mission> get missions => _missions;
  
  // Selected mission
  Mission? _selectedMission;
  Mission? get selectedMission => _selectedMission;
  
  // Filtered missions
  List<Mission> _filteredMissions = [];
  List<Mission> get filteredMissions => _filteredMissions;
  
  // Filter options
  MissionStatus? _statusFilter;
  MissionStatus? get statusFilter => _statusFilter;
  
  MissionType? _typeFilter;
  MissionType? get typeFilter => _typeFilter;
  
  String? _planetIdFilter;
  String? get planetIdFilter => _planetIdFilter;
  
  double _minPrice = 0.0;
  double get minPrice => _minPrice;
  
  double _maxPrice = double.infinity;
  double get maxPrice => _maxPrice;
  
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  
  // Initialize provider
  MissionsProvider() {
    _loadMissions();
  }
  
  // Load missions from repository
  void _loadMissions() {
    _missions = _repository.getAllMissions();
    _applyFilters();
    notifyListeners();
  }
  
  // Select a mission
  void selectMission(String missionId) {
    _selectedMission = _repository.getMissionById(missionId);
    notifyListeners();
  }
  
  // Clear selected mission
  void clearSelectedMission() {
    _selectedMission = null;
    notifyListeners();
  }
  
  // Book a mission
  Future<bool> bookMission(String missionId) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      
      final mission = _repository.getMissionById(missionId);
      if (mission == null) return false;
      
      // Update mission status
      final updatedMission = mission.copyWith(
        status: MissionStatus.scheduled,
      );
      
      // Update in repository (in a real app)
      // await _repository.updateMission(updatedMission);
      
      // Update local state
      final index = _missions.indexWhere((m) => m.id == missionId);
      if (index != -1) {
        _missions[index] = updatedMission;
        _applyFilters();
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      debugPrint('Error booking mission: $e');
      return false;
    }
  }
  
  // Start a mission
  Future<bool> startMission(String missionId) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      
      final mission = _repository.getMissionById(missionId);
      if (mission == null) return false;
      
      // Update mission status
      final updatedMission = mission.copyWith(
        status: MissionStatus.inProgress,
        completionPercentage: 0.0,
      );
      
      // Update in repository (in a real app)
      // await _repository.updateMission(updatedMission);
      
      // Update local state
      final index = _missions.indexWhere((m) => m.id == missionId);
      if (index != -1) {
        _missions[index] = updatedMission;
        _applyFilters();
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      debugPrint('Error starting mission: $e');
      return false;
    }
  }
  
  // Update mission progress
  Future<bool> updateMissionProgress(String missionId, double progress) async {
    try {
      final mission = _repository.getMissionById(missionId);
      if (mission == null) return false;
      
      // Calculate new status based on progress
      MissionStatus newStatus = mission.status;
      if (progress >= 100) {
        newStatus = MissionStatus.completed;
      } else if (progress > 0) {
        newStatus = MissionStatus.inProgress;
      }
      
      // Update mission
      final updatedMission = mission.copyWith(
        status: newStatus,
        completionPercentage: progress.clamp(0.0, 100.0),
      );
      
      // Update in repository (in a real app)
      // await _repository.updateMission(updatedMission);
      
      // Update local state
      final index = _missions.indexWhere((m) => m.id == missionId);
      if (index != -1) {
        _missions[index] = updatedMission;
        _applyFilters();
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      debugPrint('Error updating mission progress: $e');
      return false;
    }
  }
  
  // Cancel a mission
  Future<bool> cancelMission(String missionId) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      final mission = _repository.getMissionById(missionId);
      if (mission == null) return false;
      
      // Update mission status
      final updatedMission = mission.copyWith(
        status: MissionStatus.cancelled,
      );
      
      // Update in repository (in a real app)
      // await _repository.updateMission(updatedMission);
      
      // Update local state
      final index = _missions.indexWhere((m) => m.id == missionId);
      if (index != -1) {
        _missions[index] = updatedMission;
        _applyFilters();
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      debugPrint('Error cancelling mission: $e');
      return false;
    }
  }
  
  // Set status filter
  void setStatusFilter(MissionStatus? status) {
    _statusFilter = status;
    _applyFilters();
    notifyListeners();
  }
  
  // Set type filter
  void setTypeFilter(MissionType? type) {
    _typeFilter = type;
    _applyFilters();
    notifyListeners();
  }
  
  // Set planet filter
  void setPlanetFilter(String? planetId) {
    _planetIdFilter = planetId;
    _applyFilters();
    notifyListeners();
  }
  
  // Set price range filter
  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
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
    _filteredMissions = _missions;
    
    // Apply status filter
    if (_statusFilter != null) {
      _filteredMissions = _filteredMissions
          .where((mission) => mission.status == _statusFilter)
          .toList();
    }
    
    // Apply type filter
    if (_typeFilter != null) {
      _filteredMissions = _filteredMissions
          .where((mission) => mission.type == _typeFilter)
          .toList();
    }
    
    // Apply planet filter
    if (_planetIdFilter != null && _planetIdFilter!.isNotEmpty) {
      _filteredMissions = _filteredMissions
          .where((mission) => mission.planetId == _planetIdFilter)
          .toList();
    }
    
    // Apply price range filter
    _filteredMissions = _filteredMissions
        .where((mission) =>
            mission.price >= _minPrice && mission.price <= _maxPrice)
        .toList();
    
    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      _filteredMissions = _filteredMissions
          .where((mission) =>
              mission.name.toLowerCase().contains(query) ||
              mission.spaceshipModel.toLowerCase().contains(query) ||
              mission.captainName.toLowerCase().contains(query))
          .toList();
    }
  }
  
  // Reset all filters
  void resetFilters() {
    _statusFilter = null;
    _typeFilter = null;
    _planetIdFilter = null;
    _minPrice = 0.0;
    _maxPrice = double.infinity;
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }
  
  // Get missions by planet
  List<Mission> getMissionsByPlanet(String planetId) {
    return _repository.getMissionsByPlanetId(planetId);
  }
  
  // Get missions by planet ID
  List<Mission> getMissionsByPlanetId(String planetId) {
    return _repository.getMissionsByPlanetId(planetId);
  }
  
  // Load missions by planet ID
  void loadMissionsByPlanetId(String planetId) {
    setPlanetFilter(planetId);
    _filteredMissions = _repository.getMissionsByPlanetId(planetId);
    notifyListeners();
  }
  
  // Get missions by status
  List<Mission> getMissionsByStatus(MissionStatus status) {
    return _repository.getMissionsByStatus(status);
  }
  
  // Get missions by type
  List<Mission> getMissionsByType(MissionType type) {
    return _repository.getMissionsByType(type);
  }
  
  // Get mission by id
  Mission? getMissionById(String id) {
    return _repository.getMissionById(id);
  }
  
  // Public method to reload missions
  void loadMissions() {
    _loadMissions();
  }
}