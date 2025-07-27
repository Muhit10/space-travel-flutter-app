import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:random_01_space_travel/shared/providers/user_preferences_provider.dart';

enum SoundEffect {
  buttonClick,
  swipe,
  success,
  error,
  notification,
  launch,
  landing,
  warpDrive,
  planetDiscovered,
  missionComplete,
  alert,
  ambient,
  whoosh,
}

class AudioProvider extends ChangeNotifier {
  // Audio players
  final AudioPlayer _effectsPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();
  
  // User preferences
  final UserPreferencesProvider _preferences;
  
  // Sound paths
  final Map<SoundEffect, String> _soundPaths = {
    SoundEffect.buttonClick: 'assets/audio/button_click.mp3',
    SoundEffect.swipe: 'assets/audio/swipe.mp3',
    SoundEffect.success: 'assets/audio/success.mp3',
    SoundEffect.error: 'assets/audio/error.mp3',
    SoundEffect.notification: 'assets/audio/notification.mp3',
    SoundEffect.launch: 'assets/audio/launch.mp3',
    SoundEffect.landing: 'assets/audio/landing.mp3',
    SoundEffect.warpDrive: 'assets/audio/warp_drive.mp3',
    SoundEffect.planetDiscovered: 'assets/audio/planet_discovered.mp3',
    SoundEffect.missionComplete: 'assets/audio/mission_complete.mp3',
    SoundEffect.alert: 'assets/audio/alert.mp3',
    SoundEffect.ambient: 'assets/audio/ambient.mp3',
    SoundEffect.whoosh: 'assets/audio/whoosh.mp3',
  };
  
  // Background music paths
  final List<String> _backgroundMusicPaths = [
    'assets/audio/space_ambient_1.mp3',
    'assets/audio/space_ambient_2.mp3',
    'assets/audio/space_journey.mp3',
  ];
  
  // Current background music index
  int _currentMusicIndex = 0;
  
  // Volume levels
  double _effectsVolume = 0.7;
  double _musicVolume = 0.5;
  
  // Is playing
  bool _isMusicPlaying = false;
  
  // Getters
  bool get isMusicPlaying => _isMusicPlaying;
  double get effectsVolume => _effectsVolume;
  double get musicVolume => _musicVolume;
  
  // Constructor
  AudioProvider(this._preferences) {
    _initAudio();
  }
  
  // Public initialize method that can be awaited
  Future<void> initialize() async {
    return await _initAudio();
  }
  
  // Initialize audio
  Future<void> _initAudio() async {
    // Set up music player
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(_musicVolume);
    
    // Set up effects player
    await _effectsPlayer.setVolume(_effectsVolume);
    
    // Add completion listener for music to handle playlist
    _musicPlayer.onPlayerComplete.listen((_) {
      _playNextBackgroundMusic();
    });
    
    // Start background music if enabled
    if (_preferences.soundEnabled) {
      playBackgroundMusic();
    }
  }
  
  // Play sound effect
  Future<void> playSoundEffect(SoundEffect effect) async {
    if (!_preferences.soundEnabled) return;
    
    try {
      final path = _soundPaths[effect];
      if (path != null) {
        await _effectsPlayer.stop();
        await _effectsPlayer.play(AssetSource(path.replaceFirst('assets/', '')));
      }
    } catch (e) {
      debugPrint('Error playing sound effect: $e');
    }
  }
  
  // Play background music
  Future<void> playBackgroundMusic() async {
    if (!_preferences.soundEnabled) return;
    
    try {
      final path = _backgroundMusicPaths[_currentMusicIndex];
      await _musicPlayer.play(AssetSource(path.replaceFirst('assets/', '')));
      _isMusicPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing background music: $e');
    }
  }
  
  // Pause background music
  Future<void> pauseBackgroundMusic() async {
    try {
      await _musicPlayer.pause();
      _isMusicPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error pausing background music: $e');
    }
  }
  
  // Resume background music
  Future<void> resumeBackgroundMusic() async {
    if (!_preferences.soundEnabled) return;
    
    try {
      await _musicPlayer.resume();
      _isMusicPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error resuming background music: $e');
    }
  }
  
  // Stop background music
  Future<void> stopBackgroundMusic() async {
    try {
      await _musicPlayer.stop();
      _isMusicPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping background music: $e');
    }
  }
  
  // Play next background music
  Future<void> _playNextBackgroundMusic() async {
    if (!_preferences.soundEnabled) return;
    
    _currentMusicIndex = (_currentMusicIndex + 1) % _backgroundMusicPaths.length;
    await playBackgroundMusic();
  }
  
  // Set effects volume
  Future<void> setEffectsVolume(double volume) async {
    _effectsVolume = volume.clamp(0.0, 1.0);
    await _effectsPlayer.setVolume(_effectsVolume);
    notifyListeners();
  }
  
  // Set music volume
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _musicPlayer.setVolume(_musicVolume);
    notifyListeners();
  }
  
  // Handle sound preference change
  void onSoundPreferenceChanged(bool enabled) {
    if (enabled) {
      if (!_isMusicPlaying) {
        playBackgroundMusic();
      }
    } else {
      stopBackgroundMusic();
    }
  }
  
  // Dispose
  @override
  void dispose() {
    _effectsPlayer.dispose();
    _musicPlayer.dispose();
    super.dispose();
  }
}