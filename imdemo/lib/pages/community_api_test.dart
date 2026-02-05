import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_role_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_create_group_member_info.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_create_group_member_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_permission_group_info.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_permission_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_topic_info.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_topic_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_topic_info_result.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_topic_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sdk_example/utils/log_manager.dart';
import 'base_api_test.dart';

class CommunityAPITest extends StatefulWidget {
  const CommunityAPITest({Key? key}) : super(key: key);

  @override
  State<CommunityAPITest> createState() => _CommunityAPITestState();
}

class _CommunityAPITestState extends State<CommunityAPITest> {
  final TextEditingController _groupIDController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _userIDListController = TextEditingController();
  final TextEditingController _groupFaceURLController = TextEditingController();
  final TextEditingController _topicIDController = TextEditingController();
  final TextEditingController _topicNameController = TextEditingController();
  final TextEditingController _topicCustomDataController = TextEditingController();
  final TextEditingController _permissionGroupIDController = TextEditingController();
  final TextEditingController _permissionGroupNameController = TextEditingController();
  final TextEditingController _permissionGroupDescriptionController = TextEditingController();
  final TextEditingController _permissionGroupCustomDataController = TextEditingController();
  final TextEditingController _nextCursorController = TextEditingController(text: '0');
  final TextEditingController _countController = TextEditingController(text: '20');
  final TextEditingController _topicPermissionController = TextEditingController(text: '1');

  // Using global log manager and listener manager
  final LogManager _logManager = LogManager();

  @override
  void initState() {
  super.initState();
  _topicNameController.text = 'Topic name test';
  }

  // Helper method for adding logs
  void _addLog(String text) {
  _logManager.updateLogText(text);
  }

  // Update community log
  void _updateCommunityLog(String text) {
  _logManager.updateCommunityLog(text);
  }

  // Clear log
  void _clearLog() {
  _logManager.clearAllLogs();
  }

  // Create community
  Future<void> _createCommunity() async {
  if (_groupNameController.text.isEmpty) {
  _addLog('Please enterGroup name');
  return;
  }
  try {
  final info = V2TimGroupInfo(
  groupID: _groupIDController.text,
  groupType: GroupType.Community,
  isSupportTopic: true,
  groupName: _groupNameController.text,
  faceUrl: _groupFaceURLController.text.isEmpty ? null : _groupFaceURLController.text,
  );

  List<V2TimCreateGroupMemberInfo> memberList = _userIDListController.text.isEmpty ? [] :
  _userIDListController.text.split(',').map((e) =>
  V2TimCreateGroupMemberInfo(
  userID: e,
  role: GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER.index,
  )
  ).toList();

  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().createCommunity(
  info: info,
  memberList: memberList,
  );
  _addLog('Create community: ${result.toJson()}');
  } catch (e) {
  _addLog('Create communityfailed: $e');
  }
  }

  // Get joined community list
  Future<void> _getJoinedCommunityList() async {
  try {
  V2TimValueCallback<List<V2TimGroupInfo>> result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().getJoinedCommunityList();
  if (result.code == 0) {
  String groupInfoLog = '';
  for (V2TimGroupInfo groupInfo in result.data!) {
  groupInfoLog += '${groupInfo.toLogString()}\n\n';
  }
  _addLog('Get joined community list: $groupInfoLog');
  } else {
  _addLog('Get joined community listfailed, code: ${result.code}, desc: ${result.desc}');
  }
  } catch (e) {
  _addLog('Get joined community listfailed: $e');
  }
  }

  // Create topic
  Future<void> _createTopicInCommunity() async {
  if (_groupIDController.text.isEmpty || _topicNameController.text.isEmpty) {
  _addLog('Please enterGroupIDandTopic name');
  return;
  }
  try {
  final topicInfo = V2TimTopicInfo(
  topicName: _topicNameController.text,
  customString: _topicCustomDataController.text.isEmpty ? null : _topicCustomDataController.text,
  );

  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().createTopicInCommunity(
  groupID: _groupIDController.text,
  topicInfo: topicInfo,
  );
  _addLog('Create topicsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Create topicfailed: $e');
  }
  }

  // Delete topic
  Future<void> _deleteTopicFromCommunity() async {
  if (_groupIDController.text.isEmpty || _topicIDController.text.isEmpty) {
  _addLog('Please enterGroupIDandTopicID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().deleteTopicFromCommunity(
  groupID: _groupIDController.text,
  topicIDList: [_topicIDController.text],
  );
  _addLog('Delete topicsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Delete topicfailed: $e');
  }
  }

  // Modify topic info
  Future<void> _setTopicInfo() async {
  if (_groupIDController.text.isEmpty || _topicIDController.text.isEmpty) {
  _addLog('Please enterGroupID, TopicIDandTopic name');
  return;
  }
  try {
  final topicInfo = V2TimTopicInfo(
  topicID: _topicIDController.text,
  topicName: _topicNameController.text,
  customString: _topicCustomDataController.text.isEmpty ? null : _topicCustomDataController.text,
  );

  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().setTopicInfo(
  topicInfo: topicInfo,
  );
  _addLog('Modify topic infosuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Modify topic infofailed: $e');
  }
  }

  // Get topic list
  Future<void> _getTopicInfoList() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupIDandTopicID');
  return;
  }
  try {
  V2TimValueCallback<List<V2TimTopicInfoResult>> result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().getTopicInfoList(
  groupID: _groupIDController.text,
  topicIDList: [],
  // topicIDList: _topicIDController.text.isEmpty ? [] : _topicIDController.text.split(','),
  );

  if (result.code == 0) {
  String topicLog = '';
  for (V2TimTopicInfoResult topicInfoResult in result.data!) {
  topicLog += '${topicInfoResult.toJson()}\n\n';
  }
  _addLog('Get topic list: $topicLog');
  } else {
  _addLog('Get topic listfailed, code: ${result.code}, desc: ${result.desc}');
  }
  } catch (e) {
  _addLog('Get topic listfailed: $e');
  }
  }

  // Create permission group
  Future<void> _createPermissionGroupInCommunity() async {
  if (_groupIDController.text.isEmpty || _permissionGroupNameController.text.isEmpty) {
  _addLog('Please enterGroupIDandPermission group name');
  return;
  }
  try {
  final info = V2TimPermissionGroupInfo(
  groupID: _groupIDController.text,
  permissionGroupID: _permissionGroupIDController.text,
  permissionGroupName: _permissionGroupNameController.text,
  customData: _permissionGroupCustomDataController.text.isEmpty ? null : _permissionGroupCustomDataController.text,
  groupPermission: 0,
  );

  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().createPermissionGroupInCommunity(
  info: info,
  );
  _addLog('Create permission groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Create permission groupfailed: $e');
  }
  }

  // Delete permission group
  Future<void> _deletePermissionGroupFromCommunity() async {
  if (_groupIDController.text.isEmpty || _permissionGroupIDController.text.isEmpty) {
  _addLog('Please enterGroupIDandPermission groupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().deletePermissionGroupFromCommunity(
  groupID: _groupIDController.text,
  permissionGroupIDList: [_permissionGroupIDController.text],
  );
  _addLog('Delete permission groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Delete permission groupfailed: $e');
  }
  }

  // Modify permission group info
  Future<void> _modifyPermissionGroupInfoInCommunity() async {
  if (_groupIDController.text.isEmpty || _permissionGroupIDController.text.isEmpty || _permissionGroupNameController.text.isEmpty) {
  _addLog('Please enterGroupID, Permission groupIDandPermission group name');
  return;
  }
  try {
  final info = V2TimPermissionGroupInfo(
  groupID: _groupIDController.text,
  permissionGroupID: _permissionGroupIDController.text,
  permissionGroupName: _permissionGroupNameController.text,
  customData: _permissionGroupCustomDataController.text.isEmpty ? null : _permissionGroupCustomDataController.text,
  groupPermission: 0,
  memberCount: 0,
  );

  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().modifyPermissionGroupInfoInCommunity(
  info: info,
  );
  _addLog('Modify permission group infosuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Modify permission group infofailed: $e');
  }
  }

  // Get joined permission group list
  Future<void> _getJoinedPermissionGroupListInCommunity() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().getJoinedPermissionGroupListInCommunity(
  groupID: _groupIDController.text,
  );
  _addLog('Get joined permission group listsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get joined permission group listfailed: $e');
  }
  }

  // Get permission group list
  Future<void> _getPermissionGroupListInCommunity() async {
  if (_groupIDController.text.isEmpty || _permissionGroupIDController.text.isEmpty) {
  _addLog('Please enterGroupIDandPermission groupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().getPermissionGroupListInCommunity(
  groupID: _groupIDController.text,
  permissionGroupIDList: [_permissionGroupIDController.text],
  );
  _addLog('Get permission group listsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get permission group listfailed: $e');
  }
  }

  // Add member to permission group
  Future<void> _addCommunityMembersToPermissionGroup() async {
  if (_groupIDController.text.isEmpty || _permissionGroupIDController.text.isEmpty || _userIDListController.text.isEmpty) {
  _addLog('Please enterGroupID, Permission groupIDandUser ID list');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().addCommunityMembersToPermissionGroup(
  groupID: _groupIDController.text,
  permissionGroupID: _permissionGroupIDController.text,
  memberList: _userIDListController.text.split(','),
  );
  _addLog('Add member to permission groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Add member to permission groupfailed: $e');
  }
  }

  // Remove member from permission group
  Future<void> _removeCommunityMembersFromPermissionGroup() async {
  if (_groupIDController.text.isEmpty || _permissionGroupIDController.text.isEmpty || _userIDListController.text.isEmpty) {
  _addLog('Please enterGroupID, Permission groupIDandUser ID list');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().removeCommunityMembersFromPermissionGroup(
  groupID: _groupIDController.text,
  permissionGroupID: _permissionGroupIDController.text,
  memberList: _userIDListController.text.split(','),
  );
  _addLog('Remove member from permission groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Remove member from permission groupfailed: $e');
  }
  }

  // Get member list in permission group
  Future<void> _getCommunityMemberListInPermissionGroup() async {
  if (_groupIDController.text.isEmpty || _permissionGroupIDController.text.isEmpty) {
  _addLog('Please enterGroupIDandPermission groupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().getCommunityMemberListInPermissionGroup(
  groupID: _groupIDController.text,
  permissionGroupID: _permissionGroupIDController.text,
  nextCursor: _nextCursorController.text.isEmpty ? "0" : _nextCursorController.text,
  );
  _addLog('Get member list in permission groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get member list in permission groupfailed: $e');
  }
  }

  // Add topic permission to permission group
  Future<void> _addTopicPermissionToPermissionGroup() async {
  if (_groupIDController.text.isEmpty || _permissionGroupIDController.text.isEmpty || _topicIDController.text.isEmpty) {
  _addLog('Please enterGroupID, Permission groupIDandTopicID');
  return;
  }
  try {
  // Create topic permissionMap，Contains two values for testing
  Map<String, int> topicPermissionMap = {
  _topicIDController.text: int.parse(_topicPermissionController.text),
  "${_topicIDController.text}_2": int.parse(_topicPermissionController.text) + 1,
  };

  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().addTopicPermissionToPermissionGroup(
  groupID: _groupIDController.text,
  permissionGroupID: _permissionGroupIDController.text,
  topicPermissionMap: topicPermissionMap,
  );
  _addLog('Add topic permissionsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Add topic permissionfailed: $e');
  }
  }

  // Remove topic permission from permission group
  Future<void> _deleteTopicPermissionFromPermissionGroup() async {
  if (_groupIDController.text.isEmpty || _permissionGroupIDController.text.isEmpty) {
  _addLog('Please enterGroupIDandPermission groupID');
  return;
  }

  List<String> topicIDList = [];
  if (_topicIDController.text.isNotEmpty) {
  // If no topic specifiedIDlist，then use single topicID
  topicIDList = [_topicIDController.text];
  } else {
  _addLog('Please enterTopicIDorTopicIDlist');
  return;
  }

  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().deleteTopicPermissionFromPermissionGroup(
  groupID: _groupIDController.text,
  permissionGroupID: _permissionGroupIDController.text,
  topicIDList: topicIDList,
  );
  _addLog('Delete topic permissionsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Delete topic permissionfailed: $e');
  }
  }

  // Modify topic permission in permission group
  Future<void> _modifyTopicPermissionInPermissionGroup() async {
  if (_groupIDController.text.isEmpty || _permissionGroupIDController.text.isEmpty || _topicIDController.text.isEmpty) {
  _addLog('Please enterGroupID, Permission groupIDandTopicID');
  return;
  }
  try {
  // Create topic permissionMap，Contains two values for testing
  Map<String, int> topicPermissionMap = {
  _topicIDController.text: int.parse(_topicPermissionController.text),
  "${_topicIDController.text}_2": int.parse(_topicPermissionController.text) + 1,
  };

  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().modifyTopicPermissionInPermissionGroup(
  groupID: _groupIDController.text,
  permissionGroupID: _permissionGroupIDController.text,
  topicPermissionMap: topicPermissionMap,
  );
  _addLog('Modify topic permissionsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Modify topic permissionfailed: $e');
  }
  }

  // Get topic permission in permission group
  Future<void> _getTopicPermissionInPermissionGroup() async {
  if (_groupIDController.text.isEmpty || _permissionGroupIDController.text.isEmpty) {
  _addLog('Please enterGroupIDandPermission groupID');
  return;
  }

  List<String> topicIDList = [];
  if (_topicIDController.text.isNotEmpty) {
  // If no topic specifiedIDlist，then use single topicID
  topicIDList = [_topicIDController.text];
  } else {
  _addLog('Please enterTopicIDorTopicIDlist');
  return;
  }

  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getCommunityManager().getTopicPermissionInPermissionGroup(
  groupID: _groupIDController.text,
  permissionGroupID: _permissionGroupIDController.text,
  topicIDList: topicIDList,
  );
  _addLog('Get topic permissionsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get topic permissionfailed: $e');
  }
  }

  @override
  Widget build(BuildContext context) {
  final inputFields = [
  // GroupIDandGroup name
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
  style: const TextStyle(fontSize: 11),
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
  ),
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(height: 4),

  // User ID listandGroup avatar
  Row(
  children: [
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
  // Group avatar
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Group avatar:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _groupFaceURLController,
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

  // TopicIDandTopic name
  Row(
  children: [
  // TopicID
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('TopicID:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _topicIDController,
  style: const TextStyle(fontSize: 11),
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
  // Topic name
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Topic name:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _topicNameController,
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

  // Topic custom dataandPermission groupID
  Row(
  children: [
  // Topic custom data
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Topic custom:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _topicCustomDataController,
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
  // Permission groupID
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Permission groupID:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _permissionGroupIDController,
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

  // Permission group nameandPermission group description
  Row(
  children: [
  // Permission group name
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Permission group name:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _permissionGroupNameController,
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
  // Permission group description
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Permission group description:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _permissionGroupDescriptionController,
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

  // Permission group custom dataandNext page cursor
  Row(
  children: [
  // Permission group custom data
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Permission group custom:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _permissionGroupCustomDataController,
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
  // Next page cursor
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Next page cursor:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _nextCursorController,
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

  // Get countandTopic permission
  Row(
  children: [
  // Get count
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Get count:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _countController,
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
  // Topic permission
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Topic permission value:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _topicPermissionController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  hintText: 'Default to1',
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
  _buildDynamicButton('Create community', _createCommunity),
  _buildDynamicButton('Get joined community list', _getJoinedCommunityList),
  _buildDynamicButton('Create topic', _createTopicInCommunity),
  _buildDynamicButton('Delete topic', _deleteTopicFromCommunity),
  _buildDynamicButton('Modify topic info', _setTopicInfo),
  _buildDynamicButton('Get topic list', _getTopicInfoList),
  _buildDynamicButton('Create permission group', _createPermissionGroupInCommunity),
  _buildDynamicButton('Delete permission group', _deletePermissionGroupFromCommunity),
  _buildDynamicButton('Modify permission group info', _modifyPermissionGroupInfoInCommunity),
  _buildDynamicButton('Get joined permission group list', _getJoinedPermissionGroupListInCommunity),
  _buildDynamicButton('Get permission group list', _getPermissionGroupListInCommunity),
  _buildDynamicButton('Add member to permission group', _addCommunityMembersToPermissionGroup),
  _buildDynamicButton('Remove member from permission group', _removeCommunityMembersFromPermissionGroup),
  _buildDynamicButton('Get member list in permission group', _getCommunityMemberListInPermissionGroup),
  _buildDynamicButton('Add topic permission', _addTopicPermissionToPermissionGroup),
  _buildDynamicButton('Delete topic permission', _deleteTopicPermissionFromPermissionGroup),
  _buildDynamicButton('Modify topic permission', _modifyTopicPermissionInPermissionGroup),
  _buildDynamicButton('Get topic permission', _getTopicPermissionInPermissionGroup),
  ];

  return BaseAPITest(
  title: 'Community management',
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
  _groupIDController.dispose();
  _groupNameController.dispose();
  _userIDListController.dispose();
  _groupFaceURLController.dispose();
  _topicIDController.dispose();
  _topicNameController.dispose();
  _topicCustomDataController.dispose();
  _permissionGroupIDController.dispose();
  _permissionGroupNameController.dispose();
  _permissionGroupDescriptionController.dispose();
  _permissionGroupCustomDataController.dispose();
  _nextCursorController.dispose();
  _countController.dispose();
  _topicPermissionController.dispose();
  super.dispose();
  }
} 