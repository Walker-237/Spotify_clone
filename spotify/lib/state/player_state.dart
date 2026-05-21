import 'package:flutter/material.dart';
import '../models/track.dart';

class PlayerState extends ChangeNotifier {
  Track? currentTrack;
  bool isPlaying = false;
  bool isShuffle = false;
  bool isRepeat = false;
  List<Track> queue = [];
  int queueIndex = 0;

  void play(Track track, {List<Track>? trackList}) {
    currentTrack = track;
    isPlaying = true;
    if (trackList != null) {
      queue = List.of(trackList);
      queueIndex = trackList.indexOf(track);
      if (queueIndex < 0) queueIndex = 0;
    }
    notifyListeners();
  }

  void togglePlay() { isPlaying = !isPlaying; notifyListeners(); }

  void skipNext() {
    if (queue.isEmpty) return;
    queueIndex = (queueIndex + 1) % queue.length;
    currentTrack = queue[queueIndex];
    isPlaying = true;
    notifyListeners();
  }

  void skipPrev() {
    if (queue.isEmpty) return;
    queueIndex = (queueIndex - 1 + queue.length) % queue.length;
    currentTrack = queue[queueIndex];
    isPlaying = true;
    notifyListeners();
  }

  void toggleShuffle() { isShuffle = !isShuffle; notifyListeners(); }
  void toggleRepeat()  { isRepeat  = !isRepeat;  notifyListeners(); }
}

final player = PlayerState();