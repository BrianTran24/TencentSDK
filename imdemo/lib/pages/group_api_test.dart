import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_add_opt_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_application_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_filter_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_role_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_member.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info_result.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_member_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_search_param.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_member_search_param.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_search_param.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_search_param.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_search_result.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_search_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sdk_example/utils/log_manager.dart';
import 'base_api_test.dart';

class GroupAPITest extends StatefulWidget {
  const GroupAPITest({Key? key}) : super(key: key);

  @override
  State<GroupAPITest> createState() => _GroupAPITestState();
}

class _GroupAPITestState extends State<GroupAPITest> {
  final TextEditingController _groupIDController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupTypeController = TextEditingController();
  final TextEditingController _userIDListController = TextEditingController();
  final TextEditingController _groupIntroductionController = TextEditingController();
  final TextEditingController _groupNotificationController = TextEditingController();
  final TextEditingController _groupFaceURLController = TextEditingController();
  final TextEditingController _notificationController = TextEditingController();
  final TextEditingController _introductionController = TextEditingController();
  final TextEditingController _faceUrlController = TextEditingController();
  final TextEditingController _isAllMutedController = TextEditingController();
  final TextEditingController _isSupportTopicController = TextEditingController();
  final TextEditingController _addOptController = TextEditingController();
  final TextEditingController _approveOptController = TextEditingController();
  final TextEditingController _isEnablePermissionGroupController = TextEditingController();
  final TextEditingController _defaultPermissionsController = TextEditingController();
  final TextEditingController _nextSeqController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _offsetController = TextEditingController();
  final TextEditingController _nameCardController = TextEditingController();
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _fromUserController = TextEditingController();
  final TextEditingController _toUserController = TextEditingController();
  final TextEditingController _addTimeController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  bool _isSearchGroupID = true;
  bool _isSearchGroupName = true;
  bool _isSearchMemberUserID = true;
  bool _isSearchMemberNickName = true;
  bool _isSearchMemberRemark = true;
  bool _isSearchMemberNameCard = true;

  // Using global log manager
  final LogManager _logManager = LogManager();

  @override
  void initState() {
  super.initState();
  _groupIDController.text = 'public15';
  _groupNameController.text = 'Group test name';
  _nameCardController.text = 'Group name cardModifytest';
  }

  // Helper method for adding logs
  void _addLog(String log) {
  _logManager.updateLogText(log);
  }

  // Clear log
  void _clearLog() {
  _logManager.clearAllLogs();
  }

  // CreateGroup
  Future<void> _createGroup() async {
  if (_groupIDController.text.isEmpty || _groupTypeController.text.isEmpty || _groupNameController.text.isEmpty) {
  _addLog('Please enterGroupID, Group typeandGroup name');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().createGroup(
  groupID: _groupIDController.text,
  groupType: _groupTypeController.text,
  groupName: _groupNameController.text,
  notification: _notificationController.text.isEmpty ? null : _notificationController.text,
  introduction: _introductionController.text.isEmpty ? null : _introductionController.text,
  faceUrl: _faceUrlController.text.isEmpty ? null : _faceUrlController.text,
  isAllMuted: _isAllMutedController.text == 'true',
  isSupportTopic: _isSupportTopicController.text == 'true',
  addOpt: GroupAddOptTypeEnum.values[int.parse(_addOptController.text)],
  memberList: _userIDListController.text.isEmpty ? null : _userIDListController.text.split(',').map((e) => V2TimGroupMember(userID: e, role: GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER)).toList(),
  approveOpt: GroupAddOptTypeEnum.values[int.parse(_approveOptController.text)],
  isEnablePermissionGroup: _isEnablePermissionGroupController.text == 'true',
  defaultPermissions: _defaultPermissionsController.text.isEmpty ? null : int.parse(_defaultPermissionsController.text),
  );
  _addLog('CreateGroupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('CreateGroupfailed: $e');
  }
  }

  // Initialize group attribute
  Future<void> _initGroupAttributes() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().initGroupAttributes(
  groupID: _groupIDController.text,
  attributes: {
  'key1': 'value1',
  'key2': 'value2',
  },
  );
  _addLog('Initialize group attribute: ${result.toJson()}');
  } catch (e) {
  _addLog('Initialize group attributefailed: $e');
  }
  }

  // Set group attribute
  Future<void> _setGroupAttributes() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().setGroupAttributes(
  groupID: _groupIDController.text,
  attributes: {
  'key1': 'value1',
  'key2': 'value2',
  },
  );
  _addLog('Set group attribute: ${result.toJson()}');
  } catch (e) {
  _addLog('Set group attributefailed: $e');
  }
  }

  // Delete group attribute
  Future<void> _deleteGroupAttributes() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().deleteGroupAttributes(
  groupID: _groupIDController.text,
  keys: ['key1', 'key2'],
  );
  _addLog('Delete group attribute: ${result.toJson()}');
  } catch (e) {
  _addLog('Delete group attributefailed: $e');
  }
  }

  // Get group attribute
  Future<void> _getGroupAttributes() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupAttributes(
  groupID: _groupIDController.text,
  keys: ['key1', 'key2'],
  );
  _addLog('Get group attribute: ${result.toJson()}');
  } catch (e) {
  _addLog('Get group attributefailed: $e');
  }
  }

  // Get group member list
  Future<void> _getGroupMemberList() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  V2TimValueCallback<V2TimGroupMemberInfoResult> result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupMemberList(
  groupID: _groupIDController.text,
  filter: GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL,
  // filter: GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_OWNER,
  nextSeq: _nextSeqController.text.isEmpty ? "0" : _nextSeqController.text,
  count: _countController.text.isEmpty ? 30 : int.parse(_countController.text),
  offset: _offsetController.text.isEmpty ? 0 : int.parse(_offsetController.text),
  );

  if (result.code == 0) {
  String groupMemberListLog = 'nextSeq: ${result.data?.nextSeq}\n';
  for (V2TimGroupMemberFullInfo memberFullInfo in result.data?.memberInfoList ?? [])  {
  groupMemberListLog += 'memberFullInfo: ${memberFullInfo.toJson()}\n\n';
  }
  _addLog('Get group member list: $groupMemberListLog');
  } else {
  _addLog('Get group member listfailed: ${result.toJson()}');
  }
  } catch (e) {
  _addLog('Get group member listfailed: $e');
  }
  }

  // Get group member profile
  Future<void> _getGroupMembersInfo() async {
  if (_groupIDController.text.isEmpty || _userIDListController.text.isEmpty) {
  _addLog('Please enterGroupIDand member ID list');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupMembersInfo(
  groupID: _groupIDController.text,
  memberList: _userIDListController.text.split(','),
  );
  _addLog('Get group member profilesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get group member profilefailed: $e');
  }
  }

  // Modify group member profile
  Future<void> _setGroupMemberInfo() async {
  if (_groupIDController.text.isEmpty || _userIDController.text.isEmpty) {
  _addLog('Please enterGroupIDandUserID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().setGroupMemberInfo(
  groupID: _groupIDController.text,
  userID: _userIDController.text,
  nameCard: _nameCardController.text.isEmpty ? null : _nameCardController.text,
  customInfo: {'group_member_p': 'value1', 'group_member_p2': 'value2'},
  );
  _addLog('Modify group member profilesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Modify group member profilefailed: $e');
  }
  }

  // Mute group member
  Future<void> _muteGroupMember() async {
  if (_groupIDController.text.isEmpty || _userIDController.text.isEmpty || _secondsController.text.isEmpty) {
  _addLog('Please enterGroupID, UserIDandMute duration');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().muteGroupMember(
  groupID: _groupIDController.text,
  userID: _userIDController.text,
  seconds: int.parse(_secondsController.text),
  );
  _addLog('Mute group membersuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Mute group memberfailed: $e');
  }
  }

  // Invite others to join group
  Future<void> _inviteUserToGroup() async {
  if (_groupIDController.text.isEmpty || _userIDListController.text.isEmpty) {
  _addLog('Please enterGroupIDandUser ID list');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().inviteUserToGroup(
  groupID: _groupIDController.text,
  userList: _userIDListController.text.split(','),
  );
  _addLog('Invite others to join groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Invite others to join groupfailed: $e');
  }
  }

  // Kick
  Future<void> _kickGroupMember() async {
  if (_groupIDController.text.isEmpty || _userIDListController.text.isEmpty) {
  _addLog('Please enterGroupIDandUser ID list');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().kickGroupMember(
  groupID: _groupIDController.text,
  memberList: _userIDListController.text.split(','),
  reason: _reasonController.text.isEmpty ? null : _reasonController.text,
  );
  _addLog('Kick success: ${result.toJson()}');
  } catch (e) {
  _addLog('Kick failed: $e');
  }
  }

  // Set group member role
  Future<void> _setGroupMemberRole() async {
  if (_groupIDController.text.isEmpty || _userIDController.text.isEmpty || _roleController.text.isEmpty) {
  _addLog('Please enterGroupID, User ID and role');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().setGroupMemberRole(
  groupID: _groupIDController.text,
  userID: _userIDController.text,
  role: GroupMemberRoleTypeEnum.values[int.parse(_roleController.text)],
  );
  _addLog('Set group member rolesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Set group member rolefailed: $e');
  }
  }

  // Transfer group owner
  Future<void> _transferGroupOwner() async {
  if (_groupIDController.text.isEmpty || _userIDController.text.isEmpty) {
  _addLog('Please enterGroupIDandUserID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().transferGroupOwner(
  groupID: _groupIDController.text,
  userID: _userIDController.text,
  );
  _addLog('Transfer group ownersuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Transfer group ownerfailed: $e');
  }
  }

  // Mark group member
  Future<void> _markGroupMemberList() async {
  if (_groupIDController.text.isEmpty || _userIDController.text.isEmpty) {
  _addLog('Please enterGroupIDandUserID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().markGroupMemberList(
  groupID: _groupIDController.text,
  memberIDList: [_userIDController.text],
  markType: 1001,
  enableMark: true,
  );
  _addLog('Mark group membersuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Mark group memberfailed: $e');
  }
  }

  // Accept group join application
  Future<void> _acceptGroupApplication() async {
  if (_groupIDController.text.isEmpty || _fromUserController.text.isEmpty || _toUserController.text.isEmpty || _addTimeController.text.isEmpty || _typeController.text.isEmpty) {
  _addLog('Please enterGroupID, RequesterID, HandlerID, Add time and apply type');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().acceptGroupApplication(
  groupID: _groupIDController.text,
  fromUser: _fromUserController.text,
  toUser: _toUserController.text,
  addTime: int.parse(_addTimeController.text),
  type: GroupApplicationTypeEnum.values[int.parse(_typeController.text)],
  reason: _reasonController.text.isEmpty ? null : _reasonController.text,
  );
  _addLog('Accept group join applicationsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Accept group join applicationfailed: $e');
  }
  }

  // Reject group join application
  Future<void> _refuseGroupApplication() async {
  if (_groupIDController.text.isEmpty || _fromUserController.text.isEmpty || _toUserController.text.isEmpty || _addTimeController.text.isEmpty || _typeController.text.isEmpty) {
  _addLog('Please enterGroupID, RequesterID, HandlerID, Add time and apply type');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().refuseGroupApplication(
  groupID: _groupIDController.text,
  fromUser: _fromUserController.text,
  toUser: _toUserController.text,
  addTime: int.parse(_addTimeController.text),
  type: GroupApplicationTypeEnum.values[int.parse(_typeController.text)],
  reason: _reasonController.text.isEmpty ? null : _reasonController.text,
  );
  _addLog('Reject group join applicationsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Reject group join applicationfailed: $e');
  }
  }

  // Get joined group list
  Future<void> _getJoinedGroupList() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getJoinedGroupList();
  _addLog('Get joined group listsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get joined group listfailed: $e');
  }
  }

  // Get group info
  Future<void> _getGroupsInfo() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupsInfo(
  groupIDList: [_groupIDController.text],
  );
  _addLog('Get group info: ${result.toJson()}');
  } catch (e) {
  _addLog('Get group infofailed: $e');
  }
  }

  // Set group info
  Future<void> _setGroupInfo() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final info = V2TimGroupInfo(
  groupID: _groupIDController.text,
  groupType: _groupTypeController.text.isEmpty ? "Public" : _groupTypeController.text,
  groupName: _groupNameController.text,
  introduction: _groupIntroductionController.text.isEmpty ? null : _groupIntroductionController.text,
  notification: _groupNotificationController.text.isEmpty ? null : _groupNotificationController.text,
  faceUrl: _groupFaceURLController.text.isEmpty ? null : _groupFaceURLController.text,
  customInfo: {'group_test': 'value1', 'group_info': 'value2'},
  );
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().setGroupInfo(
  info: info,
  );
  _addLog('Set group info: ${result.toJson()}');
  } catch (e) {
  _addLog('Set group infofailed: $e');
  }
  }

  // Get group online count
  Future<void> _getGroupOnlineMemberCount() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupOnlineMemberCount(
  groupID: _groupIDController.text,
  );
  _addLog('Get group online count: ${result.toJson()}');
  } catch (e) {
  _addLog('Get group online countfailed: $e');
  }
  }

  // Get group application list
  Future<void> _getGroupApplicationList() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupApplicationList();
  _addLog('Get group application listsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get group application listfailed: $e');
  }
  }

  // Mark group application as read
  Future<void> _setGroupApplicationRead() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().setGroupApplicationRead();
  _addLog('Mark group application as readsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Mark group application as readfailed: $e');
  }
  }

  // Search group
  Future<void> _searchGroups() async {
  if (_groupNameController.text.isEmpty) {
  _addLog('Please enterGroup name');
  return;
  }
  try {
  final searchParam = V2TimGroupSearchParam(
  keywordList: [_groupNameController.text],
  isSearchGroupID: _isSearchGroupID,
  isSearchGroupName: _isSearchGroupName,
  );
  V2TimValueCallback<List<V2TimGroupInfo>> result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().searchGroups(
  searchParam: searchParam,
  );
  if (result.code == 0) {
  String groupLog = '';
  for (V2TimGroupInfo groupInfo in result.data ?? [])  {
  groupLog += '${groupInfo.toLogString()}\n\n';
  }
  _addLog('Search group: $groupLog');
  } else {
  _addLog('Search groupfailed，code: ${result.code} desc: ${result.desc}');
  }
  } catch (e) {
  _addLog('Search groupfailed: $e');
  }
  }

  // Search group
  Future<void> _searchCloudGroups() async {
  if (_groupNameController.text.isEmpty) {
  _addLog('Please enterGroup name');
  return;
  }
  try {
  final searchParam = V2TimGroupSearchParam(
  keywordList: [_groupNameController.text],
  keywordListMatchType: V2TimGroupSearchParam.V2TIM_KEYWORD_LIST_MATCH_TYPE_AND,
  searchCount: 20,
  searchCursor: "",
  );

  V2TimValueCallback<V2TimGroupSearchResult> result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().searchCloudGroups(
  searchParam: searchParam,
  );
  if (result.code == 0) {
  String groupLog = 'isFinished: ${result.data?.isFinished}, totalCount: ${result.data?.totalCount}, searchCursor: ${result.data?.nextCursor}\n';
  for (V2TimGroupInfo groupInfo in result.data?.groupList ?? [])  {
  groupLog += '${groupInfo.toLogString()}\n\n';
  }
  _addLog('_searchCloudGroups: $groupLog');
  } else {
  _addLog('_searchCloudGroups failed，code: ${result.code} desc: ${result.desc}');
  }
  } catch (e) {
  _addLog('_searchCloudGroups failed: $e');
  }
  }

  // Search group member
  Future<void> _searchGroupMembers() async {
  if (_groupIDController.text.isEmpty || _userIDController.text.isEmpty) {
  _addLog('Please enterGroupIDandUserID');
  return;
  }
  try {
  final searchParam = V2TimGroupMemberSearchParam(
  keywordList: [_userIDController.text],
  groupIDList: [_groupIDController.text],
  isSearchMemberUserID: _isSearchMemberUserID,
  isSearchMemberNickName: _isSearchMemberNickName,
  isSearchMemberRemark: _isSearchMemberRemark,
  isSearchMemberNameCard: _isSearchMemberNameCard,
  );
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().searchGroupMembers(
  param: searchParam,
  );
  _addLog('Search group member: ${result.data?.toLogString()}');
  } catch (e) {
  _addLog('Search group memberfailed: $e');
  }
  }

  // Search cloud group members
  Future<void> _searchCloudGroupMembers() async {
  if (_groupIDController.text.isEmpty || _userIDController.text.isEmpty) {
  _addLog('Please enterGroupIDandUserID');
  return;
  }
  try {
  final searchParam = V2TimGroupMemberSearchParam(
  keywordList: [_userIDController.text],
  groupIDList: [_groupIDController.text],
  keywordListMatchType: V2TimGroupMemberSearchParam.V2TIM_KEYWORD_LIST_MATCH_TYPE_AND,
  searchCount: 2,
  searchCursor: "",
  );
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().searchCloudGroupMembers(
  param: searchParam,
  );

  if (result.code == 0) {
  String groupLog = 'isFinished: ${result.data?.isFinished}, totalCount: ${result.data?.totalCount}, searchCursor: ${result.data?.nextCursor}\n';
  result.data?.groupMemberSearchResultItems?.forEach((groupId, memberList) {
  groupLog += 'GroupID: $groupId, Member count: ${memberList.length}, Member info: \n';
  // Iterate each member
  for (V2TimGroupMemberFullInfo member in memberList) {
  groupLog += '${member.toLogString()}\n\n';
  }
  groupLog += '\n';
  });
  _addLog('_searchCloudGroups: $groupLog');
  } else {
  _addLog('_searchCloudGroups failed，code: ${result.code} desc: ${result.desc}');
  }
  } catch (e) {
  _addLog('_searchCloudGroupMembers failed: $e');
  }
  }

  // Set group counter
  Future<void> _setGroupCounters() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().setGroupCounters(
  groupID: _groupIDController.text,
  counters: {
  'counter1': 1,
  'counter2': 2,
  },
  );
  _addLog('Set group countersuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Set group counterfailed: $e');
  }
  }

  // Get group counter
  Future<void> _getGroupCounters() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupCounters(
  groupID: _groupIDController.text,
  keys: ['counter1', 'counter2'],
  );
  _addLog('Get group countersuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get group counterfailed: $e');
  }
  }

  // Increment group counter
  Future<void> _increaseGroupCounter() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().increaseGroupCounter(
  groupID: _groupIDController.text,
  key: 'counter1',
  value: 1,
  );
  _addLog('Increment group countersuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Increment group counterfailed: $e');
  }
  }

  // Decrement group counter
  Future<void> _decreaseGroupCounter() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().decreaseGroupCounter(
  groupID: _groupIDController.text,
  key: 'counter1',
  value: 1,
  );
  _addLog('Decrement group countersuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Decrement group counterfailed: $e');
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
  ),
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(height: 4),

  // Search options
  Row(
  children: [
  Expanded(
  child: CheckboxListTile(
  title: const Text('Search groupID', style: TextStyle(fontSize: 12)),
  value: _isSearchGroupID,
  onChanged: (bool? value) {
  setState(() {
  _isSearchGroupID = value ?? true;
  });
  },
  contentPadding: EdgeInsets.zero,
  ),
  ),
  Expanded(
  child: CheckboxListTile(
  title: const Text('Search group name', style: TextStyle(fontSize: 12)),
  value: _isSearchGroupName,
  onChanged: (bool? value) {
  setState(() {
  _isSearchGroupName = value ?? true;
  });
  },
  contentPadding: EdgeInsets.zero,
  ),
  ),
  ],
  ),

  // Group member search options
  Row(
  children: [
  // Whether to search group membersID
  Expanded(
  child: CheckboxListTile(
  title: const Text('Search memberID', style: TextStyle(fontSize: 12)),
  value: _isSearchMemberUserID,
  onChanged: (bool? value) {
  setState(() {
  _isSearchMemberUserID = value ?? true;
  });
  },
  contentPadding: EdgeInsets.zero,
  dense: true,
  ),
  ),
  // Whether to search member nickname
  Expanded(
  child: CheckboxListTile(
  title: const Text('Search member nickname', style: TextStyle(fontSize: 12)),
  value: _isSearchMemberNickName,
  onChanged: (bool? value) {
  setState(() {
  _isSearchMemberNickName = value ?? true;
  });
  },
  contentPadding: EdgeInsets.zero,
  dense: true,
  ),
  ),
  ],
  ),

  // Group member search options（Continue）
  Row(
  children: [
  // Whether to search member remark
  Expanded(
  child: CheckboxListTile(
  title: const Text('Search member remark', style: TextStyle(fontSize: 12)),
  value: _isSearchMemberRemark,
  onChanged: (bool? value) {
  setState(() {
  _isSearchMemberRemark = value ?? true;
  });
  },
  contentPadding: EdgeInsets.zero,
  dense: true,
  ),
  ),
  // Whether to search member name card
  Expanded(
  child: CheckboxListTile(
  title: const Text('Search member name card', style: TextStyle(fontSize: 12)),
  value: _isSearchMemberNameCard,
  onChanged: (bool? value) {
  setState(() {
  _isSearchMemberNameCard = value ?? true;
  });
  },
  contentPadding: EdgeInsets.zero,
  dense: true,
  ),
  ),
  ],
  ),

  // Group typeandUser ID list
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
  ],
  ),
  const SizedBox(height: 4),

  // Group introductionandGroup announcement
  Row(
  children: [
  // Group introduction
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Group introduction:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _groupIntroductionController,
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
  // Group announcement
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Group announcement:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _groupNotificationController,
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

  // Group avatarandGroup member role
  Row(
  children: [
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
  const SizedBox(width: 8),
  // Group member role
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Group member role:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _roleController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  hintText: '0:Ordinary member 1:Administrator 2:Group owner',
  ),
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(height: 4),

  // Group memberIDandGroup name cardInput box
  Row(
  children: [
  // Group memberID
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Group memberID:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _userIDController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  hintText: 'Input memberID',
  ),
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 8),
  // Group name card
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Group name card:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _nameCardController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  hintText: 'Set group name card',
  ),
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(height: 4),

  // Mute durationandReasonInput box
  Row(
  children: [
  // Mute duration
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Mute duration:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _secondsController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  hintText: 'Unit:seconds',
  ),
  keyboardType: TextInputType.number,
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 8),
  // Reason
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Operation reason:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _reasonController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  hintText: 'Reason for kicking or handling application',
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
  _buildDynamicButton('CreateGroup', _createGroup),
  _buildDynamicButton('Get joined group list', _getJoinedGroupList),
  _buildDynamicButton('Get group info', _getGroupsInfo),
  _buildDynamicButton('Set group info', _setGroupInfo),
  _buildDynamicButton('Initialize group attribute', _initGroupAttributes),
  _buildDynamicButton('Set group attribute', _setGroupAttributes),
  _buildDynamicButton('Delete group attribute', _deleteGroupAttributes),
  _buildDynamicButton('Get group attribute', _getGroupAttributes),
  _buildDynamicButton('Get group member list', _getGroupMemberList),
  _buildDynamicButton('Get group member profile', _getGroupMembersInfo),
  _buildDynamicButton('Modify group member profile', _setGroupMemberInfo),
  _buildDynamicButton('Mute group member', _muteGroupMember),
  _buildDynamicButton('Invite others to join group', _inviteUserToGroup),
  _buildDynamicButton('Kick', _kickGroupMember),
  _buildDynamicButton('Set group member role', _setGroupMemberRole),
  _buildDynamicButton('Transfer group owner', _transferGroupOwner),
  _buildDynamicButton('Mark group member', _markGroupMemberList),
  _buildDynamicButton('Get group application list', _getGroupApplicationList),
  _buildDynamicButton('Accept group join application', _acceptGroupApplication),
  _buildDynamicButton('Reject group join application', _refuseGroupApplication),
  _buildDynamicButton('Get group online count', _getGroupOnlineMemberCount),
  _buildDynamicButton('Mark group application as read', _setGroupApplicationRead),
  _buildDynamicButton('Search group', _searchGroups),
  _buildDynamicButton('Search group member', _searchGroupMembers),
  _buildDynamicButton('Search cloud groups', _searchCloudGroups),
  _buildDynamicButton('Search cloud group members', _searchCloudGroupMembers),
  _buildDynamicButton('Set group counter', _setGroupCounters),
  _buildDynamicButton('Get group counter', _getGroupCounters),
  _buildDynamicButton('Increment group counter', _increaseGroupCounter),
  _buildDynamicButton('Decrement group counter', _decreaseGroupCounter),
  ];

  return BaseAPITest(
  title: 'Group management',
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
  _groupTypeController.dispose();
  _userIDListController.dispose();
  _groupIntroductionController.dispose();
  _groupNotificationController.dispose();
  _groupFaceURLController.dispose();
  _notificationController.dispose();
  _introductionController.dispose();
  _faceUrlController.dispose();
  _isAllMutedController.dispose();
  _isSupportTopicController.dispose();
  _addOptController.dispose();
  _approveOptController.dispose();
  _isEnablePermissionGroupController.dispose();
  _defaultPermissionsController.dispose();
  _nextSeqController.dispose();
  _countController.dispose();
  _offsetController.dispose();
  _nameCardController.dispose();
  _userIDController.dispose();
  _secondsController.dispose();
  _reasonController.dispose();
  _fromUserController.dispose();
  _toUserController.dispose();
  _addTimeController.dispose();
  _typeController.dispose();
  _roleController.dispose();
  super.dispose();
  }
}