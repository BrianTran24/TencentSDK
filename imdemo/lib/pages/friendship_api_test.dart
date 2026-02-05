import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/enum/friend_application_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/friend_response_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/friend_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info_result.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_friend_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_search_param.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_friend_search_param.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sdk_example/utils/log_manager.dart';
import 'base_api_test.dart';

class FriendshipAPITest extends StatefulWidget {
  const FriendshipAPITest({Key? key}) : super(key: key);

  @override
  State<FriendshipAPITest> createState() => _FriendshipAPITestState();
}

class _FriendshipAPITestState extends State<FriendshipAPITest> {
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _addFriendWithGroupController = TextEditingController();
  final TextEditingController _addWordingController = TextEditingController();
  final TextEditingController _addSourceController = TextEditingController();
  final TextEditingController _addTypeController = TextEditingController(text: '1');
  final TextEditingController _userIDListController = TextEditingController();
  final TextEditingController _deleteTypeController = TextEditingController(text: '1');
  final TextEditingController _checkTypeController = TextEditingController(text: '2');
  final TextEditingController _responseTypeController = TextEditingController(text: '1');
  final TextEditingController _applicationTypeController = TextEditingController(text: '1');
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _oldNameController = TextEditingController();
  final TextEditingController _newNameController = TextEditingController();
  final TextEditingController _officialAccountIDController = TextEditingController();
  final TextEditingController _searchKeywordController = TextEditingController();
  final TextEditingController _searchFriendController = TextEditingController();
  final TextEditingController _friendCustomInfoController = TextEditingController();
  final TextEditingController _friendApplicationRemarkController = TextEditingController();
  final TextEditingController _friendRemarkController = TextEditingController();
  final TextEditingController _friendApplicationIDController = TextEditingController();
  final TextEditingController _followUserListController = TextEditingController();

  // Using global log manager and listener manager
  final LogManager _logManager = LogManager();

  // Search options
  bool isSearchUserID = true;
  bool isSearchNickName = true;
  bool isSearchRemark = true;

  @override
  void initState() {
  super.initState();
  _userIDController.text = 'teacher13';
  _userIDListController.text = 'teacher13,teacher15';
  _groupNameController.text = 'new-group';
  _followUserListController.text = "teacher20,teacher21";
  }

  // Helper method for adding logs
  void _addLog(String log) {
  _logManager.updateLogText(log);
  }

  // Clear log
  void _clearLog() {
  _logManager.clearAllLogs();
  }

  // Get friend list
  Future<void> _getFriendList() async {
  try {
  V2TimValueCallback<List<V2TimFriendInfo>> result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getFriendList();
  if (result.code == 0) {
  String friendLog = '';
  for (V2TimFriendInfo friendInfo in result.data!) {
  friendLog += '${friendInfo.toLogString()}\n';
  }
  _addLog('Get friend list: $friendLog');
  } else {
  _addLog('Get friend listfailed, code: ${result.code}, desc: ${result.desc}');
  }
  } catch (e) {
  _addLog('Get friend listfailed: $e');
  }
  }

  // Get specified friend profile
  Future<void> _getFriendsInfo() async {
  if (_userIDListController.text.isEmpty) {
  _addLog('Please enterUser ID list，Separated by commas');
  return;
  }
  try {
  V2TimValueCallback<List<V2TimFriendInfoResult>> result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getFriendsInfo(
  userIDList: _userIDListController.text.split(','),
  );
  if (result.code == 0) {
  String friendLog = '';
  for (V2TimFriendInfoResult friendInfoResult in result.data!) {
  friendLog += '${friendInfoResult.toLogString()}\n\n';
  }
  _addLog('Get specified friend profile: $friendLog');
  } else {
  _addLog('Get specified friend profilefailed, code = ${result.code}, desc = ${result.desc}');
  }
  } catch (e) {
  _addLog('Get specified friend profilefailed: $e');
  }
  }

  // Set specified friend profile
  Future<void> _setFriendInfo() async {
  if (_userIDController.text.isEmpty) {
  _addLog('Please enterUserID');
  return;
  }
  try {
  Map<String, String> customInfo = {"Str" : "Str friend value"};
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().setFriendInfo(
  userID: _userIDController.text,
  friendRemark: _friendRemarkController.text.isEmpty ? null : _friendRemarkController.text,
  friendCustomInfo: customInfo,
  );
  _addLog('Set specified friend profilesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Set specified friend profilefailed: $e');
  }
  }

  // Add friend
  Future<void> _addFriend() async {
  if (_userIDController.text.isEmpty || _addTypeController.text.isEmpty) {
  _addLog('Please enterUserIDandAdd type');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().addFriend(
  userID: _userIDController.text,
  remark: _friendApplicationRemarkController.text.isEmpty ? null : _friendApplicationRemarkController.text,
  friendGroup: _addFriendWithGroupController.text.isEmpty ? null : _addFriendWithGroupController.text,
  addWording: _addWordingController.text.isEmpty ? null : _addWordingController.text,
  addSource: _addSourceController.text.isEmpty ? null : _addSourceController.text,
  addType: FriendTypeEnum.values[int.parse(_addTypeController.text)],
  );
  _addLog('Add friendsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Add friendfailed: $e');
  }
  }

  // Delete friend
  Future<void> _deleteFromFriendList() async {
  if (_userIDListController.text.isEmpty || _deleteTypeController.text.isEmpty) {
  _addLog('Please enterUser ID listandDelete type');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().deleteFromFriendList(
  userIDList: _userIDListController.text.split(','),
  deleteType: FriendTypeEnum.values[int.parse(_deleteTypeController.text)],
  );
  _addLog('Delete friendsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Delete friendfailed: $e');
  }
  }

  // Check friend relation of specified user
  Future<void> _checkFriend() async {
  if (_userIDListController.text.isEmpty || _checkTypeController.text.isEmpty) {
  _addLog('Please enterUser ID listandCheck type');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().checkFriend(
  userIDList: _userIDListController.text.split(','),
  checkType: FriendTypeEnum.values[int.parse(_checkTypeController.text)],
  );
  _addLog('Check friend relationsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Check friend relationfailed: $e');
  }
  }

  // Get friend application list
  Future<void> _getFriendApplicationList() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getFriendApplicationList();
  _addLog('Get friend application listsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get friend application listfailed: $e');
  }
  }

  // Accept friend application
  Future<void> _acceptFriendApplication() async {
  if (_userIDController.text.isEmpty || _responseTypeController.text.isEmpty || _applicationTypeController.text.isEmpty) {
  _addLog('Please enterUserID, Response type and andApply type');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().acceptFriendApplication(
  responseType: FriendResponseTypeEnum.values[int.parse(_responseTypeController.text)],
  type: FriendApplicationTypeEnum.values[int.parse(_applicationTypeController.text)],
  userID: _userIDController.text,
  );
  _addLog('Accept friend applicationsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Accept friend applicationfailed: $e');
  }
  }

  // Reject friend application
  Future<void> _refuseFriendApplication() async {
  if (_userIDController.text.isEmpty || _applicationTypeController.text.isEmpty) {
  _addLog('Please enterUserIDand apply type');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().refuseFriendApplication(
  type: FriendApplicationTypeEnum.values[int.parse(_applicationTypeController.text)],
  userID: _userIDController.text,
  );
  _addLog('Reject friend applicationsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Reject friend applicationfailed: $e');
  }
  }

  // Delete friend application
  Future<void> _deleteFriendApplication() async {
  if (_userIDController.text.isEmpty || _applicationTypeController.text.isEmpty) {
  _addLog('Please enterUserIDand apply type');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().deleteFriendApplication(
  type: FriendApplicationTypeEnum.values[int.parse(_applicationTypeController.text)],
  userID: _userIDController.text,
  );
  _addLog('Delete friend applicationsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Delete friend applicationfailed: $e');
  }
  }

  // Set friend application as read
  Future<void> _setFriendApplicationRead() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().setFriendApplicationRead();
  _addLog('Set friend application as readsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Set friend application as readfailed: $e');
  }
  }

  // Add user to blacklist
  Future<void> _addToBlackList() async {
  if (_userIDListController.text.isEmpty) {
  _addLog('Please enterUser ID list，Separated by commas');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().addToBlackList(
  userIDList: _userIDListController.text.split(','),
  );
  _addLog('Add user to blacklistsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Add user to blacklistfailed: $e');
  }
  }

  // Remove user from blacklist
  Future<void> _deleteFromBlackList() async {
  if (_userIDListController.text.isEmpty) {
  _addLog('Please enterUser ID list，Separated by commas');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().deleteFromBlackList(
  userIDList: _userIDListController.text.split(','),
  );
  _addLog('Remove user from blacklist: ${result.toJson()}');
  } catch (e) {
  _addLog('Remove user from blacklistfailed: $e');
  }
  }

  // Get blacklist
  Future<void> _getBlackList() async {
  try {
  V2TimValueCallback<List<V2TimFriendInfo>> result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getBlackList();
  if (result.code == 0) {
  String friendLog = '';
  for (V2TimFriendInfo friendInfo in result.data!) {
  friendLog += '${friendInfo.toLogString()}\n';
  }
  _addLog('Get blacklist: $friendLog');
  } else {
  _addLog('Get blacklistfailed，code: ${result.code}, desc: ${result.desc}');
  }
  } catch (e) {
  _addLog('Get blacklistfailed: $e');
  }
  }

  // Create friend group
  Future<void> _createFriendGroup() async {
  if (_groupNameController.text.isEmpty) {
  _addLog('Please enterGroup name');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().createFriendGroup(
  groupName: _groupNameController.text,
  userIDList: _userIDListController.text.isEmpty ? null : _userIDListController.text.split(','),
  );
  _addLog('Create friend groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Create friend groupfailed: $e');
  }
  }

  // Get group info
  Future<void> _getFriendGroups() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getFriendGroups(
  groupNameList: _groupNameController.text.isEmpty ? null : [_groupNameController.text],
  );
  _addLog('Get group infosuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get group infofailed: $e');
  }
  }

  // Delete friend group
  Future<void> _deleteFriendGroup() async {
  if (_groupNameController.text.isEmpty) {
  _addLog('Please enterGroup name');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().deleteFriendGroup(
  groupNameList: [_groupNameController.text],
  );
  _addLog('Delete friend groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Delete friend groupfailed: $e');
  }
  }

  // Modify friend group name
  Future<void> _renameFriendGroup() async {
  if (_oldNameController.text.isEmpty || _newNameController.text.isEmpty) {
  _addLog('Please enterOld group nameandNew group name');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().renameFriendGroup(
  oldName: _oldNameController.text,
  newName: _newNameController.text,
  );
  _addLog('Modify friend group namesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Modify friend group namefailed: $e');
  }
  }

  // Add friend to a friend group
  Future<void> _addFriendsToFriendGroup() async {
  if (_groupNameController.text.isEmpty || _userIDListController.text.isEmpty) {
  _addLog('Please enterGroup nameandUser ID list');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().addFriendsToFriendGroup(
  groupName: _groupNameController.text,
  userIDList: _userIDListController.text.split(','),
  );
  _addLog('Add friend to a friend groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Add friend to a friend groupfailed: $e');
  }
  }

  // Remove friend from friend group
  Future<void> _deleteFriendsFromFriendGroup() async {
  if (_groupNameController.text.isEmpty || _userIDListController.text.isEmpty) {
  _addLog('Please enterGroup nameandUser ID list');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().deleteFriendsFromFriendGroup(
  groupName: _groupNameController.text,
  userIDList: _userIDListController.text.split(','),
  );
  _addLog('Remove friend from friend groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Remove friend from friend groupfailed: $e');
  }
  }

  // Search friend
  Future<void> _searchFriends() async {
  V2TimFriendSearchParam searchParam = V2TimFriendSearchParam(
  keywordList: [_searchFriendController.text],
  isSearchUserID: isSearchUserID,
  isSearchNickName: isSearchNickName,
  isSearchRemark: isSearchRemark,
  );

  V2TimValueCallback<List<V2TimFriendInfoResult>> searchFriendsRes =
  await TencentImSDKPlugin.v2TIMManager
  .getFriendshipManager()
  .searchFriends(searchParam: searchParam);

  if (searchFriendsRes.code == 0) {
  String friendLog = '';
  for (V2TimFriendInfoResult friendInfoResult in searchFriendsRes.data!) {
  friendLog += '${friendInfoResult.toJson()}\n\n';
  }
  _addLog('Search friend: $friendLog');
  } else {
  _addLog('Search friendfailed，code: ${searchFriendsRes.code}, desc: ${searchFriendsRes.desc}');
  }
  }

  // Subscribe official account
  Future<void> _subscribeOfficialAccount() async {
  if (_officialAccountIDController.text.isEmpty) {
  _addLog('Please enterOfficial accountID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().subscribeOfficialAccount(
  officialAccountID: _officialAccountIDController.text,
  );
  _addLog('Subscribe official accountsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Subscribe official accountfailed: $e');
  }
  }

  // Unsubscribe official account
  Future<void> _unsubscribeOfficialAccount() async {
  if (_officialAccountIDController.text.isEmpty) {
  _addLog('Please enterOfficial accountID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().unsubscribeOfficialAccount(
  officialAccountID: _officialAccountIDController.text,
  );
  _addLog('Unsubscribe official accountsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Unsubscribe official accountfailed: $e');
  }
  }

  // Get official account list
  Future<void> _getOfficialAccountsInfo() async {
  if (_userIDListController.text.isEmpty) {
  _addLog('Please enterOfficial accountIDlist，Separated by commas');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getOfficialAccountsInfo(
  officialAccountIDList: [],
  );
  _addLog('Get official account listsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get official account listfailed: $e');
  }
  }

  // Follow user
  Future<void> _followUser() async {
  if (_followUserListController.text.isEmpty) {
  _addLog('Please enterFollowIDlist，Separated by commas');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().followUser(
  userIDList: _followUserListController.text.split(','),
  );
  _addLog('Follow user: ${result.toJson()}');
  } catch (e) {
  _addLog('Follow userfailed: $e');
  }
  }

  // Unfollow user
  Future<void> _unfollowUser() async {
  if (_followUserListController.text.isEmpty) {
  _addLog('Please enterFollowIDlist，Separated by commas');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().unfollowUser(
  userIDList: _followUserListController.text.split(','),
  );
  _addLog('Unfollow user: ${result.toJson()}');
  } catch (e) {
  _addLog('Unfollow userfailed: $e');
  }
  }

  // Get my following list
  Future<void> _getMyFollowingList() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getMyFollowingList(
  nextCursor: '',
  );
  _addLog('Get my following list: ${result.toJson()}');
  } catch (e) {
  _addLog('Get my following listfailed: $e');
  }
  }

  // Get my follower list
  Future<void> _getMyFollowersList() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getMyFollowersList(
  nextCursor: '',
  );
  _addLog('Get my follower listsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get my follower listfailed: $e');
  }
  }

  // Get my mutual following list
  Future<void> _getMutualFollowersList() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getMutualFollowersList(
  nextCursor: '',
  );
  _addLog('Get my mutual following listsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get my mutual following listfailed: $e');
  }
  }

  // Get follow of specified user/Followers/Mutual following count info
  Future<void> _getUserFollowInfo() async {
  if (_userIDListController.text.isEmpty) {
  _addLog('Please enterUser ID list，Separated by commas');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getUserFollowInfo(
  userIDList: _userIDListController.text.split(','),
  );
  _addLog('Get follow of specified user/Followers/Mutual following count infosuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get follow of specified user/Followers/Mutual following count infofailed: $e');
  }
  }

  // Check follow type of specified user
  Future<void> _checkFollowType() async {
  if (_userIDListController.text.isEmpty) {
  _addLog('Please enterUser ID list，Separated by commas');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().checkFollowType(
  userIDList: _userIDListController.text.split(','),
  );
  _addLog('Check follow type of specified usersuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Check follow type of specified userfailed: $e');
  }
  }

  @override
  Widget build(BuildContext context) {
  final inputFields = [
  // UserIDandFriendID
  Row(
  children: [
  // UserID
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('UserID:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _userIDController,
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

  // FriendIDlistandFriend remark
  Row(
  children: [
  // FriendIDlist
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('FriendIDlist:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _userIDListController,
  style: const TextStyle(fontSize: 13),
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
  const SizedBox(width: 8),
  // Friend remark
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Friend remark:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _friendRemarkController,
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

  // Friend groupandFriend custom info
  Row(
  children: [
  // Friend group
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Add friend with group:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _addFriendWithGroupController,
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
  // Friend custom info
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Friend custom info:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _friendCustomInfoController,
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

  // Friend applicationIDandFriend application remark
  Row(
  children: [
  // Friend applicationID
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Friend applicationID:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _friendApplicationIDController,
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
  // Friend application remark
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Friend application remark:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _friendApplicationRemarkController,
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

  Row(
  children: [
  // Friend application message
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Friend application message:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _addWordingController,
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
  hintText: 'Friend group name',
  ),
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(height: 4),

  // Old and new group input
  Row(
  children: [
  // Old group name
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Old group name:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _oldNameController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  hintText: 'Group name to modify',
  ),
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 8),
  // New group name
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('New group name:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _newNameController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  hintText: 'Modified group name',
  ),
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(height: 4),

  // Search friend keyword input
  Row(
  children: [
  // Search friend keyword
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Search friend keyword:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _searchFriendController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  hintText: 'Input search keyword',
  ),
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(height: 4),

  // Official accountIDandFollow userIDlist
  Row(
  children: [
  // Official accountIDlist
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Official accountID:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _officialAccountIDController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  hintText: 'Official accountID',
  ),
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 8),
  // Follow userIDlist
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Follow userIDlist:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _userIDListController,
  style: const TextStyle(fontSize: 13),
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
  ];

  final buttons = [
  _buildDynamicButton('Get friend list', _getFriendList),
  _buildDynamicButton('Get specified friend profile', _getFriendsInfo),
  _buildDynamicButton('Set specified friend profile', _setFriendInfo),
  _buildDynamicButton('Add friend', _addFriend),
  _buildDynamicButton('Delete friend', _deleteFromFriendList),
  _buildDynamicButton('Check friend relation', _checkFriend),
  _buildDynamicButton('Get friend application list', _getFriendApplicationList),
  _buildDynamicButton('Accept friend application', _acceptFriendApplication),
  _buildDynamicButton('Reject friend application', _refuseFriendApplication),
  _buildDynamicButton('Delete friend application', _deleteFriendApplication),
  _buildDynamicButton('Set friend application as read', _setFriendApplicationRead),
  _buildDynamicButton('Add user to blacklist', _addToBlackList),
  _buildDynamicButton('Remove user from blacklist', _deleteFromBlackList),
  _buildDynamicButton('Get blacklist', _getBlackList),
  _buildDynamicButton('Create friend group', _createFriendGroup),
  _buildDynamicButton('Get group info', _getFriendGroups),
  _buildDynamicButton('Delete friend group', _deleteFriendGroup),
  _buildDynamicButton('Modify friend group name', _renameFriendGroup),
  _buildDynamicButton('Add friend to a friend group', _addFriendsToFriendGroup),
  _buildDynamicButton('Remove friend from friend group', _deleteFriendsFromFriendGroup),
  _buildDynamicButton('Search friend', _searchFriends),
  _buildDynamicButton('Subscribe official account', _subscribeOfficialAccount),
  _buildDynamicButton('Unsubscribe official account', _unsubscribeOfficialAccount),
  _buildDynamicButton('Get official account list', _getOfficialAccountsInfo),
  _buildDynamicButton('Follow user', _followUser),
  _buildDynamicButton('Unfollow user', _unfollowUser),
  _buildDynamicButton('Get my following list', _getMyFollowingList),
  _buildDynamicButton('Get my follower list', _getMyFollowersList),
  _buildDynamicButton('Get my mutual following list', _getMutualFollowersList),
  _buildDynamicButton('Get follow of specified user/Followers/Mutual following count info', _getUserFollowInfo),
  _buildDynamicButton('Check follow type of specified user', _checkFollowType),
  ];

  return BaseAPITest(
  title: 'Friendship management',
  inputFields: inputFields,
  buttons: buttons,
  onClearLog: _clearLog,
  );
  }

  Widget _buildDynamicButton(String text, VoidCallback onPressed) {
  return Container(
  margin: const EdgeInsets.only(bottom: 1.0),
  child: ElevatedButton(
  onPressed: onPressed,
  style: ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
  minimumSize: Size(text.length * 6.0 + 12.0, 30.0),
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  visualDensity: VisualDensity.compact,
  textStyle: const TextStyle(fontSize: 12.0),
  foregroundColor: Colors.white,
  backgroundColor: Colors.blue,
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(4.0),
  ),
  ),
  child: Text(text),
  ),
  );
  }

  @override
  void dispose() {
  _userIDController.dispose();
  _addFriendWithGroupController.dispose();
  _addWordingController.dispose();
  _addSourceController.dispose();
  _addTypeController.dispose();
  _userIDListController.dispose();
  _deleteTypeController.dispose();
  _checkTypeController.dispose();
  _responseTypeController.dispose();
  _applicationTypeController.dispose();
  _groupNameController.dispose();
  _oldNameController.dispose();
  _newNameController.dispose();
  _officialAccountIDController.dispose();
  _searchKeywordController.dispose();
  _searchFriendController.dispose();
  _friendCustomInfoController.dispose();
  _friendApplicationRemarkController.dispose();
  _friendRemarkController.dispose();
  _friendApplicationIDController.dispose();
  _followUserListController.dispose();
  super.dispose();
  }
} 