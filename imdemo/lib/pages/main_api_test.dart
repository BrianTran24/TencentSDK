import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/enum/log_level_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/login_status.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_priority_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_info.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_user_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_search_result.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_user_search_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_search_param.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_user_search_param.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sdk_example/config.dart';
import 'package:tencent_cloud_chat_sdk_example/utils/GenerateUserSig.dart';
import 'package:tencent_cloud_chat_sdk_example/utils/listener_manager.dart';
import 'package:tencent_cloud_chat_sdk_example/utils/log_manager.dart';
import 'package:tencent_cloud_chat_sdk_example/utils/toast_utils.dart';
import 'base_api_test.dart';

class MainAPITest extends StatefulWidget {
  const MainAPITest({Key? key}) : super(key: key);

  @override
  State<MainAPITest> createState() => _MainAPITestState();
}

class _MainAPITestState extends State<MainAPITest> {
  // Button stylerelated constants
  static const double BUTTON_HORIZONTAL_PADDING = 5.0; // Button internalleft and right padding
  static const double BUTTON_VERTICAL_PADDING = 3.0; // Button internaltop and bottom padding
  static const double BUTTON_MIN_HEIGHT = 30.0; // Button min height
  static const double BUTTON_FONT_SIZE = 12.0; // Button font size
  static const double BUTTON_BORDER_RADIUS = 4.0; // Button border radius
  static const double BUTTON_CHAR_WIDTH = 6.0; // Estimated width per character
  static const double BUTTON_EXTRA_WIDTH = 12.0; // Button extra width
  static const Color BUTTON_TEXT_COLOR = Colors.white; // Button text color
  static const Color BUTTON_BG_COLOR = Colors.blue; // Button background color

  // Button layoutrelated constants
  static const double BUTTON_HORIZONTAL_SPACING = 2.0; // Button betweenhorizontal spacing
  static const double BUTTON_VERTICAL_SPACING = 4.0; // Button betweenvertical spacing
  static const double BUTTONS_TOP_MARGIN = 2.0; // Button areatop margin
  static const double BUTTON_BOTTOM_MARGIN = 1.0; // Single buttonbottom margin

  final TextEditingController _loginUserController = TextEditingController();
  final TextEditingController _receiverIDController = TextEditingController();
  final TextEditingController _groupIDController = TextEditingController();
  final TextEditingController _conversationIDController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _customDataController = TextEditingController(); // Custom message data
  final TextEditingController _userIDListController = TextEditingController(); // User ID list
  final TextEditingController _groupTypeController = TextEditingController(); // Group type
  final TextEditingController _groupNameController = TextEditingController(); // Group name

  // Using global log manager and listener manager
  final LogManager _logManager = LogManager();
  final ListenerManager _listenerManager = ListenerManager();

  @override
  void initState() {
  super.initState();
  _loginUserController.text = 'teacher10';
  _receiverIDController.text = 'teacher13';
  _groupIDController.text = 'public15';
  _conversationIDController.text = 'c2c_@TOA#_@TOA#dHD4';
  _messageController.text = 'This is a test message';
  _customDataController.text = 'This is a custom message';
  _userIDListController.text = 'teacher10,teacher13,teacher20';

  // Initialize global listeners
  _listenerManager.initialize();
  }

  // Clear log
  void _clearLog() {
  _logManager.clearAllLogs();
  }

  // SDKInitialize
  Future<void> _initSDK() async {
  // Usingconfig.dartdefined insdkAppID
  if (IMConfig.sdkappid == 0) {
  ToastUtils.toast("Please input sdkappid and appKey in config.dart");
  return;
  }

  var initSDKRes = await TencentImSDKPlugin.v2TIMManager.initSDK(
  sdkAppID: IMConfig.sdkappid,
  loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
  listener: _listenerManager.sdkListener,
  );

  if (initSDKRes.code == 0) {
  _logManager.updateLogText('InitializeSDKsuccess');
  } else {
  _logManager.updateLogText('InitializeSDKfailed: ${initSDKRes.code} ${initSDKRes.desc ?? ''}');
  }
  }

  // SDKDispose
  Future<void> _unInitSDK() async {
  var unInitRes = await TencentImSDKPlugin.v2TIMManager.unInitSDK();

  if (unInitRes.code == 0) {
  _logManager.updateLogText('DisposeSDKsuccess');
  } else {
  _logManager.updateLogText('DisposeSDKfailed: ${unInitRes.code} ${unInitRes.desc ?? ''}');
  }
  }

  // Login
  Future<void> _login() async {
  String userID = _loginUserController.text;

  // Using GenerateUserSig class generation UserSig
  String userSig = GenerateDevUsersigForTest(sdkappid: IMConfig.sdkappid, key: IMConfig.appKey)
  .genSig(userID: userID, expireTime: IMConfig.expireTime);

  var loginRes = await TencentImSDKPlugin.v2TIMManager.login(
  userID: userID,
  userSig: userSig,
  );

  if (loginRes.code == 0) {
  var loginStatusResult = await TencentImSDKPlugin.v2TIMManager.getLogin status();
  var statusStr = 'unknown';
  switch (loginStatusResult.data) {
  case 1:
  statusStr = 'Logged in';
  break;
  case 2:
  statusStr = 'Logging in';
  break;
  case 3:
  statusStr = 'Not logged in';
  break;
  default:
  break;
  }
  _logManager.updateLogText('Login success, Login status: $statusStr');
  } else {
  _logManager.updateLogText('Login failed: ${loginRes.code} ${loginRes.desc}');
  }
  }

  // Logout
  Future<void> _logout() async {
  var logoutRes = await TencentImSDKPlugin.v2TIMManager.logout();

  if (logoutRes.code == 0) {
  var loginStatusResult = await TencentImSDKPlugin.v2TIMManager.getLogin status();
  var statusStr = 'unknown';
  switch (loginStatusResult.data) {
  case 1:
  statusStr = 'Logged in';
  break;
  case 2:
  statusStr = 'Logging in';
  break;
  case 3:
  statusStr = 'Not logged in';
  break;
  default:
  break;
  }
  _logManager.updateLogText('Logout success, Login status: $statusStr');
  } else {
  _logManager.updateLogText('Logout failed: ${logoutRes.code} ${logoutRes.desc}');
  }
  }

  // GetLogin status
  Future<void> _getLogin status() async {
  var statusRes = await TencentImSDKPlugin.v2TIMManager.getLogin status();

  if (statusRes.code == 0) {
  var statusStr = 'unknown';
  switch (statusRes.data) {
  case Login status.V2TIM_STATUS_LOGINED:
  statusStr = 'Logged in';
  break;
  case Login status.V2TIM_STATUS_LOGINING:
  statusStr = 'Logging in';
  break;
  case Login status.V2TIM_STATUS_LOGOUT:
  statusStr = 'Not logged in';
  break;
  default:
  break;
  }
  _logManager.updateLogText('Login status: $statusStr');
  } else {
  _logManager.updateLogText('GetLogin statusfailed: ${statusRes.code} ${statusRes.desc}');
  }
  }

  // GetLogin user
  Future<void> _getLoginUser() async {
  var userRes = await TencentImSDKPlugin.v2TIMManager.getLoginUser();

  if (userRes.code == 0) {
  _logManager.updateLogText('GetLogin usersuccess: ${userRes.data}');
  } else {
  _logManager.updateLogText('GetLogin userfailed: ${userRes.code} ${userRes.desc}');
  }
  }

  // SendC2Ctext message
  Future<void> _sendC2CTextMessage() async {
  String receiverID = _receiverIDController.text;
  String text = _messageController.text;

  var sendRes = await TencentImSDKPlugin.v2TIMManager.sendC2CTextMessage(
  text: text,
  userID: receiverID,
  );

  if (sendRes.code == 0) {
  _logManager.updateLogText('SendC2Ctext message success: ${sendRes.data?.msgID}');
  } else {
  _logManager.updateLogText('SendC2Ctext messagefailed: ${sendRes.code} ${sendRes.desc}');
  }
  }

  // SendGrouptext message
  Future<void> _sendGroupTextMessage() async {
  String groupID = _groupIDController.text;
  String text = _messageController.text;

  var sendRes = await TencentImSDKPlugin.v2TIMManager.sendGroupTextMessage(
  text: text,
  groupID: groupID,
  priority: 0, // V2TIM_PRIORITY_NORMAL
  );

  if (sendRes.code == 0) {
  _logManager.updateLogText('SendGrouptext message success: ${sendRes.data?.msgID}');
  } else {
  _logManager.updateLogText('SendGrouptext messagefailed: ${sendRes.code} ${sendRes.desc}');
  }
  }

  // JoinGroup
  Future<void> _joinGroup() async {
  String groupID = _groupIDController.text;

  var joinRes = await TencentImSDKPlugin.v2TIMManager.joinGroup(
  groupID: groupID,
  message: 'ApplyJoinGroup',
  );

  if (joinRes.code == 0) {
  _logManager.updateLogText('JoinGroupsuccess');
  } else {
  _logManager.updateLogText('JoinGroupfailed: ${joinRes.code} ${joinRes.desc}');
  }
  }

  // QuitGroup
  Future<void> _quitGroup() async {
  String groupID = _groupIDController.text;

  var quitRes = await TencentImSDKPlugin.v2TIMManager.quitGroup(
  groupID: groupID,
  );

  if (quitRes.code == 0) {
  _logManager.updateLogText('QuitGroupsuccess');
  } else {
  _logManager.updateLogText('QuitGroupfailed: ${quitRes.code} ${quitRes.desc}');
  }
  }

  // DismissGroup
  Future<void> _dismissGroup() async {
  String groupID = _groupIDController.text;

  var dismissRes = await TencentImSDKPlugin.v2TIMManager.dismissGroup(
  groupID: groupID,
  );

  if (dismissRes.code == 0) {
  _logManager.updateLogText('DismissGroupsuccess');
  } else {
  _logManager.updateLogText('DismissGroupfailed: ${dismissRes.code} ${dismissRes.desc}');
  }
  }

  // GetUser profile
  Future<void> _getUsersInfo() async {
  if (_userIDListController.text.isEmpty) {
  _logManager.updateLogText('Please enterUser ID list');
  return;
  }

  List<String> userIDList = _userIDListController.text.split(',');

  var userInfoRes = await TencentImSDKPlugin.v2TIMManager.getUsersInfo(
  userIDList: userIDList,
  );

  if (userInfoRes.code == 0) {
  _logManager.updateLogText('GetUser profilesuccess: ${userInfoRes.data?.map((e) => e.toLogString()).toList()}');
  } else {
  _logManager.updateLogText('GetUser profilefailed: ${userInfoRes.code} ${userInfoRes.desc}');
  }
  }

  // GetUser status
  Future<void> _getUserStatus() async {
  if (_userIDListController.text.isEmpty) {
  _logManager.updateLogText('Please enterUser ID list');
  return;
  }

  List<String> userIDList = _userIDListController.text.split(',');

  var statusRes = await TencentImSDKPlugin.v2TIMManager.getUserStatus(
  userIDList: userIDList,
  );

  if (statusRes.code == 0) {
  _logManager.updateLogText('GetUser statussuccess: ${statusRes.data?.map((e) => e.toJson()).toList()}');
  } else {
  _logManager.updateLogText('GetUser statusfailed: ${statusRes.code} ${statusRes.desc}');
  }
  }

  // GetServer time
  Future<void> _getServerTime() async {
  var timeRes = await TencentImSDKPlugin.v2TIMManager.getServerTime();

  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch((timeRes.data ?? 0) * 1000);
  if (timeRes.code == 0) {
  _logManager.updateLogText('GetServer time: ${timeRes.data}, Format time: ${dateTime.toLocal()}');
  } else {
  _logManager.updateLogText('GetServer timefailed: ${timeRes.code} ${timeRes.desc}');
  }
  }

  // GetSDKVersion number
  Future<void> _getVersion() async {
  var versionRes = await TencentImSDKPlugin.v2TIMManager.getVersion();

  if (versionRes.code == 0) {
  _logManager.updateLogText('GetSDKVersion numbersuccess: ${versionRes.data}');
  } else {
  _logManager.updateLogText('GetSDKVersion numberfailed: ${versionRes.code} ${versionRes.desc}');
  }
  }

  // CreateGroup
  Future<void> _createGroup() async {
  if (_groupTypeController.text.isEmpty || _groupNameController.text.isEmpty) {
  _logManager.updateLogText('Please enterGroup typeandGroup name');
  return;
  }

  var createRes = await TencentImSDKPlugin.v2TIMManager.createGroup(
  groupType: _groupTypeController.text,
  groupName: _groupNameController.text,
  groupID: _groupIDController.text.isEmpty ? null : _groupIDController.text,
  );

  if (createRes.code == 0) {
  _logManager.updateLogText('CreateGroupsuccess: ${createRes.data}');
  } else {
  _logManager.updateLogText('CreateGroupfailed: ${createRes.code} ${createRes.desc}');
  }
  }

  // SendGroupCustom message
  Future<void> _sendGroupCustomMessage() async {
  String groupID = _groupIDController.text;
  String customData = _customDataController.text;

  if (groupID.isEmpty) {
  _logManager.updateLogText('Please enterGroupID');
  return;
  }

  if (customData.isEmpty) {
  _logManager.updateLogText('Please enterCustom messagecontent');
  return;
  }

  var sendRes = await TencentImSDKPlugin.v2TIMManager.sendGroupCustomMessage(
  customData: customData,
  groupID: groupID,
  priority: MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
  );

  if (sendRes.code == 0) {
  _logManager.updateLogText('SendGroupCustom message success: ${sendRes.data?.msgID}');
  } else {
  _logManager.updateLogText('SendGroupCustom messagefailed: ${sendRes.code} ${sendRes.desc}');
  }
  }

  // SendC2CCustom message
  Future<void> _sendC2CCustomMessage() async {
  String receiverID = _receiverIDController.text;
  String customData = _customDataController.text;

  if (receiverID.isEmpty) {
  _logManager.updateLogText('Please enter ReceiverID');
  return;
  }

  if (customData.isEmpty) {
  _logManager.updateLogText('Please enterCustom messagecontent');
  return;
  }

  var sendRes = await TencentImSDKPlugin.v2TIMManager.sendC2CCustomMessage(
  customData: customData,
  userID: receiverID,
  );

  if (sendRes.code == 0) {
  _logManager.updateLogText('SendC2CCustom message success: ${sendRes.data?.msgID}');
  } else {
  _logManager.updateLogText('SendC2CCustom messagefailed: ${sendRes.code} ${sendRes.desc}');
  }
  }

  // SetPersonal info
  Future<void> _setSelfInfo() async {
  // CreateUser profile
  Map<String, String> userCustomMap = {"Str": "Str value"};
  V2TimUserFullInfo userInfo = V2TimUserFullInfo(
  userID: TencentImSDKPlugin.v2TIMManager.getLoginUser().toString(),
  nickName: _loginUserController.text,
  faceUrl: 'https://example.com/avatar.jpg',
  // Example avatarURL
  selfSignature: 'This is my signature',
  customInfo: userCustomMap,
  );

  var setInfoRes = await TencentImSDKPlugin.v2TIMManager.setSelfInfo(
  userFullInfo: userInfo,
  );

  if (setInfoRes.code == 0) {
  _logManager.updateLogText('SetPersonal infosuccess');
  } else {
  _logManager.updateLogText('SetPersonal infofailed: ${setInfoRes.code} ${setInfoRes.desc}');
  }
  }

  // SetPersonal status
  Future<void> _setSelfStatus() async {
  var setStatusRes = await TencentImSDKPlugin.v2TIMManager.setSelfStatus(
  status: 'I am online', // CustomStatus
  );

  if (setStatusRes.code == 0) {
  _logManager.updateLogText('SetPersonal statussuccess');
  } else {
  _logManager.updateLogText('SetPersonal statusfailed: ${setStatusRes.code} ${setStatusRes.desc}');
  }
  }

  // SubscribeUser status
  Future<void> _subscribeUserStatus() async {
  if (_userIDListController.text.isEmpty) {
  _logManager.updateLogText('Please enterUser ID list');
  return;
  }

  List<String> userIDList = _userIDListController.text.split(',');

  var subscribeRes = await TencentImSDKPlugin.v2TIMManager.subscribeUserStatus(
  userIDList: userIDList,
  );

  if (subscribeRes.code == 0) {
  _logManager.updateLogText('SubscribeUser statussuccess');
  } else {
  _logManager.updateLogText('SubscribeUser statusfailed: ${subscribeRes.code} ${subscribeRes.desc}');
  }
  }

  // UnsubscribeUser status
  Future<void> _unsubscribeUserStatus() async {
  if (_userIDListController.text.isEmpty) {
  _logManager.updateLogText('Please enterUser ID list');
  return;
  }

  List<String> userIDList = _userIDListController.text.split(',');

  var unsubscribeRes = await TencentImSDKPlugin.v2TIMManager.unsubscribeUserStatus(
  userIDList: userIDList,
  );

  if (unsubscribeRes.code == 0) {
  _logManager.updateLogText('UnsubscribeUser statussuccess');
  } else {
  _logManager.updateLogText('UnsubscribeUser statusfailed: ${unsubscribeRes.code} ${unsubscribeRes.desc}');
  }
  }

  // SubscribeUser profile
  Future<void> _subscribeUserInfo() async {
  if (_userIDListController.text.isEmpty) {
  _logManager.updateLogText('Please enterUser ID list');
  return;
  }

  List<String> userIDList = _userIDListController.text.split(',');

  var subscribeRes = await TencentImSDKPlugin.v2TIMManager.subscribeUserInfo(
  userIDList: userIDList,
  );

  if (subscribeRes.code == 0) {
  _logManager.updateLogText('SubscribeUser profilesuccess');
  } else {
  _logManager.updateLogText('SubscribeUser profilefailed: ${subscribeRes.code} ${subscribeRes.desc}');
  }
  }

  // UnsubscribeUser profile
  Future<void> _unsubscribeUserInfo() async {
  if (_userIDListController.text.isEmpty) {
  _logManager.updateLogText('Please enterUser ID list');
  return;
  }

  List<String> userIDList = _userIDListController.text.split(',');

  var unsubscribeRes = await TencentImSDKPlugin.v2TIMManager.unsubscribeUserInfo(
  userIDList: userIDList,
  );

  if (unsubscribeRes.code == 0) {
  _logManager.updateLogText('UnsubscribeUser profilesuccess');
  } else {
  _logManager.updateLogText('UnsubscribeUser profilefailed: ${unsubscribeRes.code} ${unsubscribeRes.desc}');
  }
  }

  Future<void> _searchUsers() async {
  V2TimUserSearchParam searchParam = V2TimUserSearchParam(keywordList: ['tea'], searchCount: 10, searchCursor: '');
  V2TimValueCallback<V2TimUserSearchResult> result = await TencentImSDKPlugin.v2TIMManager.searchUsers(
  searchParam: searchParam);

  if (result.code == 0) {
  String searchUserLog = 'isFinished: ${result.data?.isFinished}, totalCount: ${result.data
  ?.totalCount}, searchCursor: ${result.data?.nextCursor}\n';
  for (V2TimUserInfo userInfo in result.data?.userInfoList ?? []) {
  searchUserLog += '${userInfo.toLogString()}\n\n';
  }

  _logManager.updateLogText('_searchUsers: $searchUserLog');
  } else {
  _logManager.updateLogText('_searchUsers failed: ${result.code} ${result.desc}');
  }
  }

  // Invitesomeone
  Future<void> _invite() async {
  if (_userIDListController.text.isEmpty) {
  _logManager.updateLogText('Please enterUser ID list');
  return;
  }

  List<String> userIDList = _userIDListController.text.split(',');

  var result = await TencentImSDKPlugin.v2TIMManager.getSignalingManager().invite(
  invitee: userIDList[0],
  // data: "test",
  data: jsonEncode(getCustomMap()),
  );

  if (result.code == 0) {
  _logManager.updateLogText('InviteUsersuccess: inviteID: ${result.data}');
  } else {
  _logManager.updateLogText('InviteUserfailed: ${result.code} ${result.desc}');
  }
  }

  // Invite some people in group
  Future<void> _inviteInGroup() async {
  if (_groupIDController.text.isEmpty) {
  _logManager.updateLogText('Please enterGroupID');
  return;
  }
  if (_userIDListController.text.isEmpty) {
  _logManager.updateLogText('Please enterUser ID list');
  return;
  }

  String groupID = _groupIDController.text;

  List<String> userIDList = _userIDListController.text.split(',');

  var result = await TencentImSDKPlugin.v2TIMManager.getSignalingManager().inviteInGroup(
  groupID: groupID,
  inviteeList: userIDList,
  data: "test",
  );

  if (result.code == 0) {
  _logManager.updateLogText('Invitegroup memberssuccess: inviteID: ${result.data}');
  } else {
  _logManager.updateLogText('Invitegroup membersfailed: ${result.code} ${result.desc}');
  }
  }

  Future<void> _setOfflinePushConfig({bool isVoip = false}) async {
  var result = await TencentImSDKPlugin.v2TIMManager.getOfflinePushManager().setOfflinePushConfig(
  businessID: 1,
  token: "test",
  isVoip: isVoip,
  );
  if (result.code == 0) {
  _logManager.updateLogText('setOfflinePushConfig success');
  } else {
  _logManager.updateLogText('setOfflinePushConfig failed: ${result.code} ${result.desc}');
  }
  }

  Future<void> _doBackground() async {
  var result = await TencentImSDKPlugin.v2TIMManager.getOfflinePushManager().doBackground(unreadCount: 0);
  if (result.code == 0) {
  _logManager.updateLogText('doBackground success');
  } else {
  _logManager.updateLogText('doBackground failed: ${result.code} ${result.desc}');
  }
  }

  Future<void> _doForeground() async {
  var result = await TencentImSDKPlugin.v2TIMManager.getOfflinePushManager().doForeground();
  if (result.code == 0) {
  _logManager.updateLogText('doForeground success');
  } else {
  _logManager.updateLogText('doForeground failed: ${result.code} ${result.desc}');
  }
  }

  Map<String, dynamic> getCustomMap() {
  Map<String, dynamic> customMap = <String, dynamic>{};
  customMap['customData1'] = 1;
  customMap['customData2'] = "ccc2";
  customMap['customData3'] = 3;
  customMap['customData4'] = 4;

  return customMap;
  }

  Future<void> _setTestEnv() async {
  Map<String, dynamic> param = {"request_set_env_param": true};
  TencentImSDKPlugin.v2TIMManager.callExperimentalAPI(api: "internal_operation_set_env", param: param);
  }

  // Register all listeners using global listener manager
  void _registerAllListeners() {
  _listenerManager.registerAllListeners();
  }

  @override
  Widget build(BuildContext context) {
  final inputFields = [
  // User input area - Using more compact layout
  Row(
  children: [
  // Login userID
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Login userID:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _loginUserController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 8),
  // ReceiverID
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('ReceiverID:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _receiverIDController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(height: 4),

  // GroupIDandConversationID
  Row(
  children: [
  // GroupID
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('GroupID:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _groupIDController,
  style: const TextStyle(fontSize: 10, letterSpacing: -0.3),
  maxLines: 1,
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  hintStyle: TextStyle(fontSize: 10, height: 1.0),
  ),
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 8),
  // Message content
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Message content:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _messageController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(height: 4),

  // Custom messageandUser ID list
  Row(
  children: [
  // Custom message data
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Custom message:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _customDataController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 8),
  // User ID list
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('User ID list:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _userIDListController,
  style: const TextStyle(fontSize: 10),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  hintText: 'Separated by commas',
  ),
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(height: 4),

  // Group typeandGroup name
  Row(
  children: [
  // Group type
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Group type:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: DropdownButtonFormField<String>(
  value: _groupTypeController.text.isEmpty ? null : _groupTypeController.text,
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  items: const [
  DropdownMenuItem(value: 'Work', child: Text('Work', style: TextStyle(fontSize: 13))),
  DropdownMenuItem(value: 'Public', child: Text('Public', style: TextStyle(fontSize: 13))),
  DropdownMenuItem(value: 'Meeting', child: Text('Meeting', style: TextStyle(fontSize: 13))),
  DropdownMenuItem(value: 'Community', child: Text('Community', style: TextStyle(fontSize: 13))),
  DropdownMenuItem(value: 'AVChatRoom', child: Text('AVChatRoom', style: TextStyle(fontSize: 13))),
  ],
  onChanged: (value) {
  setState(() {
  _groupTypeController.text = value ?? '';
  });
  },
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 8),
  // Group name
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Group name:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _groupNameController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  ];

  final buttons = [
  _buildDynamicButton('initSDK', _initSDK),
  _buildDynamicButton('unInitSDK', _unInitSDK),
  _buildDynamicButton('registerAllListeners', _registerAllListeners),
  _buildDynamicButton('login', _login),
  _buildDynamicButton('logout', _logout),
  _buildDynamicButton('getLogin status', _getLogin status),
  _buildDynamicButton('getLoginUser', _getLoginUser),
  _buildDynamicButton('getServerTime', _getServerTime),
  _buildDynamicButton('getVersion', _getVersion),
  _buildDynamicButton('sendC2CTextMessage', _sendC2CTextMessage),
  _buildDynamicButton('sendC2CCustomMessage', _sendC2CCustomMessage),
  _buildDynamicButton('sendGroupTextMessage', _sendGroupTextMessage),
  _buildDynamicButton('sendGroupCustomMessage', _sendGroupCustomMessage),
  _buildDynamicButton('createGroup', _createGroup),
  _buildDynamicButton('joinGroup', _joinGroup),
  _buildDynamicButton('quitGroup', _quitGroup),
  _buildDynamicButton('dismissGroup', _dismissGroup),
  _buildDynamicButton('getUsersInfo', _getUsersInfo),
  _buildDynamicButton('setSelfInfo', _setSelfInfo),
  _buildDynamicButton('getUserStatus', _getUserStatus),
  _buildDynamicButton('setSelfStatus', _setSelfStatus),
  _buildDynamicButton('subscribeUserStatus', _subscribeUserStatus),
  _buildDynamicButton('unsubscribeUserStatus', _unsubscribeUserStatus),
  _buildDynamicButton('subscribeUserInfo', _subscribeUserInfo),
  _buildDynamicButton('unsubscribeUserInfo', _unsubscribeUserInfo),
  _buildDynamicButton('searchUsers', _searchUsers),
  _buildDynamicButton('invite', _invite),
  _buildDynamicButton('inviteInGroup', _inviteInGroup),
  _buildDynamicButton('setOfflinePushConfig', _setOfflinePushConfig),
  _buildDynamicButton('setOfflinePushConfig(VOIP)', (){_setOfflinePushConfig(isVoip: true);}),
  _buildDynamicButton('doBackground', _doBackground),
  _buildDynamicButton('doForeground', _doForeground),
  ];

  return BaseAPITest(
  title: 'IMSDK API test',
  inputFields: inputFields,
  buttons: buttons,
  onClearLog: _clearLog,
  );
  }

  // CreatewidthBased oncontentadaptive Button
  Widget _buildDynamicButton(String text, VoidCallback onPressed) {
  // Based ontext lengthcalculateapproximate width, Ensure text can be fully displayed
  double width = text.length * BUTTON_CHAR_WIDTH + BUTTON_EXTRA_WIDTH;

  return Container(
  margin: const EdgeInsets.only(bottom: BUTTON_BOTTOM_MARGIN),
  child: ElevatedButton(
  onPressed: onPressed,
  style: ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: BUTTON_HORIZONTAL_PADDING, vertical: BUTTON_VERTICAL_PADDING),
  minimumSize: Size(width, BUTTON_MIN_HEIGHT),
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  // Reduce click area
  visualDensity: VisualDensity.compact,
  // More compact visual density
  textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE),
  foregroundColor: BUTTON_TEXT_COLOR,
  backgroundColor: BUTTON_BG_COLOR,
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS),
  ),
  ),
  child: Text(text),
  ),
  );
  }

  @override
  void dispose() {
  _loginUserController.dispose();
  _receiverIDController.dispose();
  _groupIDController.dispose();
  _conversationIDController.dispose();
  _messageController.dispose();
  _customDataController.dispose();
  _userIDListController.dispose();
  _groupTypeController.dispose();
  _groupNameController.dispose();
  super.dispose();
  }
}
