import 'package:flutter/material.dart';
import 'package:random_01_space_travel/features/missions/mission_model.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';

class MissionsProvider extends ChangeNotifier {
  final List<Mission> _missions = [];
  
  List<Mission> get missions => _missions;
  
  List<Mission> get upcomingMissions => _missions
      .where((mission) => mission.status == MissionStatus.upcoming)
      .toList();
  
  List<Mission> get inProgressMissions => _missions
      .where((mission) => mission.status == MissionStatus.inProgress)
      .toList();
  
  List<Mission> get completedMissions => _missions
      .where((mission) => mission.status == MissionStatus.completed)
      .toList();
  
  List<Mission> getMissionsByPlanet(String planetId) {
    return _missions.where((mission) => mission.planetId == planetId).toList();
  }
  
  Mission? getMissionById(String id) {
    try {
      return _missions.firstWhere((mission) => mission.id == id);
    } catch (e) {
      return null;
    }
  }
  
  void addMission(Mission mission) {
    _missions.add(mission);
    notifyListeners();
  }
  
  void updateMission(Mission mission) {
    final index = _missions.indexWhere((m) => m.id == mission.id);
    if (index != -1) {
      _missions[index] = mission;
      notifyListeners();
    }
  }
  
  void startMission(String id) {
    final mission = getMissionById(id);
    if (mission != null && mission.status == MissionStatus.upcoming) {
      updateMission(
        mission.copyWith(status: MissionStatus.inProgress),
      );
    }
  }
  
  void completeMission(String id) {
    final mission = getMissionById(id);
    if (mission != null && mission.status == MissionStatus.inProgress) {
      updateMission(
        mission.copyWith(status: MissionStatus.completed),
      );
    }
  }
  
  // Initialize with some sample missions
  void initializeSampleMissions() {
    final now = DateTime.now();
    
    _missions.addAll([
      Mission(
        id: '1',
        name: 'Mars Exploration',
        description: 'Explore the surface of Mars to find signs of ancient life.',
        type: MissionType.exploration,
        status: MissionStatus.upcoming,
        startDate: now.add(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 30)),
        durationDays: 28,
        planetId: 'mars',
        reward: 5000,
        difficulty: 4,
        color: AppTheme.marsRed,
      ),
      Mission(
        id: '2',
        name: 'Lunar Base Construction',
        description: 'Help build the first permanent human settlement on the Moon.',
        type: MissionType.colonization,
        status: MissionStatus.upcoming,
        startDate: now.add(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 20)),
        durationDays: 15,
        planetId: 'moon',
        reward: 3000,
        difficulty: 3,
        color: AppTheme.moonGray,
      ),
      Mission(
        id: '3',
        name: 'Jupiter Atmosphere Study',
        description: 'Collect data on Jupiter\'s atmospheric composition.',
        type: MissionType.research,
        status: MissionStatus.upcoming,
        startDate: now.add(const Duration(days: 10)),
        endDate: now.add(const Duration(days: 45)),
        durationDays: 35,
        planetId: 'jupiter',
        reward: 7000,
        difficulty: 5,
        color: AppTheme.jupiterOrange,
      ),
      Mission(
        id: '4',
        name: 'Asteroid Mining',
        description: 'Extract valuable minerals from the asteroid belt.',
        type: MissionType.mining,
        status: MissionStatus.upcoming,
        startDate: now.add(const Duration(days: 3)),
        endDate: now.add(const Duration(days: 18)),
        durationDays: 15,
        planetId: 'asteroid',
        reward: 4000,
        difficulty: 2,
        color: AppTheme.asteroidBrown,
      ),
    ]);
  }
}