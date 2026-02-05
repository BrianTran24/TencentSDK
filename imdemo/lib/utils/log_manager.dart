import 'package:flutter/foundation.dart';

/// Global log manager for centralized log management
/// Uses ChangeNotifier for reactive updates
class LogManager extends ChangeNotifier {
  // Singleton implementation
  static final LogManager _instance = LogManager._internal();
  factory LogManager() => _instance;
  LogManager._internal();

  // Different types of logs
  String _logText = '';
  String _simpleMsgLog = '';
  String _advMsgLog = '';
  String _groupLog = '';
  String _timSDKLog = '';
  String _conversationLog = '';
  String _friendshipLog = '';
  String _communityLog = '';

  // Getters
  String get logText => _logText;
  String get simpleMsgLog => _simpleMsgLog;
  String get advMsgLog => _advMsgLog;
  String get groupLog => _groupLog;
  String get timSDKLog => _timSDKLog;
  String get conversationLog => _conversationLog;
  String get friendshipLog => _friendshipLog;
  String get communityLog => _communityLog;

  // Update operation log
  void updateLogText(String text) {
    _logText = '$text\n$_logText';
    notifyListeners();
  }

  // Update simple message log
  void updateSimpleMsgLog(String text) {
    _simpleMsgLog = '$text\n$_simpleMsgLog';
    notifyListeners();
  }

  // Update advanced message log
  void updateAdvMsgLog(String text) {
    _advMsgLog = '$text\n$_advMsgLog';
    notifyListeners();
  }

  // Update group log
  void updateGroupLog(String text) {
    _groupLog = '$text\n$_groupLog';
    notifyListeners();
  }

  // Update network status log
  void updateNetStatusLog(String text) {
    _timSDKLog = '$text\n$_timSDKLog';
    notifyListeners();
  }

  // Update conversation log
  void updateConversationLog(String text) {
    _conversationLog = '$text\n$_conversationLog';
    notifyListeners();
  }

  // Update friend log
  void updateFriendshipLog(String text) {
    _friendshipLog = '$text\n$_friendshipLog';
    notifyListeners();
  }

  // Update community log
  void updateCommunityLog(String text) {
    _communityLog = '$text\n$_communityLog';
    notifyListeners();
  }

  // Clear all logs
  void clearAllLogs() {
    _logText = '';
    _simpleMsgLog = '';
    _advMsgLog = '';
    _groupLog = '';
    _timSDKLog = '';
    _conversationLog = '';
    _friendshipLog = '';
    _communityLog = '';
    notifyListeners();
  }
} 