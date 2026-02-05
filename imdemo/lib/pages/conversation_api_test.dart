import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_filter.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_conversation_filter.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sdk_example/utils/log_manager.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/v2_tim_conversation_marktype.dart';
import 'base_api_test.dart';

class ConversationAPITest extends StatefulWidget {
  const ConversationAPITest({Key? key}) : super(key: key);

  @override
  State<ConversationAPITest> createState() => _ConversationAPITestState();
}

class _ConversationAPITestState extends State<ConversationAPITest> {
  final TextEditingController _conversationIDController = TextEditingController();
  final TextEditingController _nextSeqController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _draftTextController = TextEditingController();
  final TextEditingController _markTypeController = TextEditingController();
  final TextEditingController _enableMarkController = TextEditingController();
  final TextEditingController _conversationIDListController = TextEditingController();
  final TextEditingController _customDataController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _oldNameController = TextEditingController();
  final TextEditingController _newNameController = TextEditingController();
  final TextEditingController _isPinnedController = TextEditingController();
  final TextEditingController _clearMessageController = TextEditingController();
  final TextEditingController _filterTypeController = TextEditingController();
  final TextEditingController _filterConversationTypeController = TextEditingController();
  final TextEditingController _filterEnableMarkController = TextEditingController();
  final TextEditingController _cleanTimestampController = TextEditingController();
  final TextEditingController _cleanSequenceController = TextEditingController();

  // BooleanStatus
  bool _clearMessageValue = false;
  bool _enableMarkValue = false;
  bool _isPinnedValue = false;
  bool _filterHasUnreadCountValue = false;
  bool _hasGroupAtInfoValue = false;

  // Using global log manager
  final LogManager _logManager = LogManager();

  int _selectedConversationType = ConversationType.CONVERSATION_TYPE_INVALID;
  int _selectedMarkType = 0;
  // Used to store selected filter mark types
  final Set<int> _selectedFilterMarkTypes = <int>{};

  final Map<int, String> _conversationTypeMap = {
  ConversationType.CONVERSATION_TYPE_INVALID: 'Illegal type',
  ConversationType.V2TIM_C2C: 'Private chat',
  ConversationType.V2TIM_GROUP: 'Group chat',
  };

  final Map<int, String> _markTypeMap = {
  0: 'No mark',
  V2TimConversationMarkType.V2TIM_CONVERSATION_MARK_TYPE_STAR: 'Star conversation',
  V2TimConversationMarkType.V2TIM_CONVERSATION_MARK_TYPE_UNREAD: 'Mark conversation as unread',
  V2TimConversationMarkType.V2TIM_CONVERSATION_MARK_TYPE_FOLD: 'Collapse conversation',
  V2TimConversationMarkType.V2TIM_CONVERSATION_MARK_TYPE_HIDE: 'Hide conversation',
  0x1 << 33 : 'Custom mark',
  };

  @override
  void initState() {
  super.initState();

  _conversationIDController.text = 'c2c_teacher13';
  _conversationIDListController.text = 'c2c_teacher13,c2c_teacher15';
  _customDataController.text = 'custom data test';
  _groupNameController.text = 'flutterGROUP';
  _oldNameController.text = 'flutterGROUP';
  _newNameController.text = 'flutterGROUP2';
  }

  // Helper method for adding logs
  void _addLog(String log) {
  _logManager.updateLogText(log);
  }

  // Clear log
  void _clearLog() {
  _logManager.clearAllLogs();
  }

  // GetConversationlist
  Future<void> _getConversationList() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .getConversationList(
  nextSeq: _nextSeqController.text.isEmpty ? "0" : _nextSeqController.text,
  count: int.tryParse(_countController.text) ?? 20,
  );
  if (result.code == 0) {
  V2TimConversationResult conversationResult = result.data!;
  _addLog('GetConversationlistsuccess: nextSeq:${conversationResult.nextSeq}, isFinished:${conversationResult.isFinished}');
  for (var conversation in conversationResult.conversationList!) {
  _addLog('Conversation: ${conversation?.toJson()}\n');
  }
  } else {
  _addLog('GetConversationlistfailed, code:${result.code}|desc:${result.desc}');
  }
  } catch (e) {
  _addLog('GetConversationlistfailed: $e');
  }
  }

  // GetConversationlist(No formatting)
  Future<void> _getConversationListWithoutFormat() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .getConversationListWithoutFormat(
  nextSeq: _nextSeqController.text.isEmpty ? "0" : _nextSeqController.text,
  count: int.tryParse(_countController.text) ?? 20,
  );
  _addLog('GetConversationlist(No formatting)success: $result');
  } catch (e) {
  _addLog('GetConversationlist(No formatting)failed: $e');
  }
  }

  // GetConversation info
  Future<void> _getConversationInfo() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .getConversation(
  conversationID: _conversationIDController.text,
  );
  _addLog('GetConversation infosuccess: ${result.toLogString()}');
  } catch (e) {
  _addLog('GetConversation infofailed: $e');
  }
  }

  // SetConversation draft
  Future<void> _setConversationDraft() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .setConversationDraft(
  conversationID: _conversationIDController.text,
  draftText: _draftTextController.text,
  );
  _addLog('SetConversation draftsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('SetConversation draftfailed: $e');
  }
  }

  // DeleteConversation
  Future<void> _deleteConversation() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .deleteConversation(
  conversationID: _conversationIDController.text,
  );
  _addLog('DeleteConversationsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('DeleteConversationfailed: $e');
  }
  }

  // DeleteConversationlist
  Future<void> _deleteConversationList() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .deleteConversationList(
  conversationIDList: _conversationIDListController.text.split(','),
  clearMessage: _clearMessageValue,
  );
  _addLog('DeleteConversationlistsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('DeleteConversationlistfailed: $e');
  }
  }

  // Mark conversation
  Future<void> _markConversation() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .markConversation(
  conversationIDList: [_conversationIDController.text],
  markType: _selectedMarkType,
  enableMark: _enableMarkValue,
  );
  _addLog('Mark conversation: ${result.toJson()}');
  } catch (e) {
  _addLog('Mark conversationfailed: $e');
  }
  }

  // GetConversationlist
  Future<void> _getConversationListByID() async {
  try {
  V2TimValueCallback<List<V2TimConversation>> result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .getConversationListByConversationIds(
  conversationIDList: _conversationIDListController.text.split(','),
  );
  if (result.code == 0) {
  List<V2TimConversation>? list = result.data ?? [];
  String conversationListLog = '';
  for (V2TimConversation conversation in list)  {
  conversationListLog += '${conversation.toLogString()}\n\n';
  }

  _addLog('GetConversationlistsuccess: \n$conversationListLog');
  } else {
  _addLog('GetConversationlistfailed, code:${result.code}|desc:${result.desc}');
  }
  } catch (e) {
  _addLog('GetConversationlistfailed: $e');
  }
  }

  // SetConversationCustom data
  Future<void> _setConversationCustomData() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .setConversationCustomData(
  customData: _customDataController.text,
  conversationIDList: _conversationIDListController.text.split(','),
  );
  _addLog('SetConversationCustom datasuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('SetConversationCustom datafailed: $e');
  }
  }

  // Pin conversation
  Future<void> _pinConversation() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .pinConversation(
  conversationID: _conversationIDController.text,
  isPinned: _isPinnedValue,
  );
  _addLog('Pin conversation($_isPinnedValue)success: ${result.toJson()}');
  } catch (e) {
  _addLog('Pin conversationfailed: $e');
  }
  }

  // GetTotal unread conversations
  Future<void> _getTotalUnreadMessageCount() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .getTotalUnreadMessageCount();
  if (result.code == 0) {
  _addLog('GetTotal unread conversations: ${result.data}');
  } else {
  _addLog('GetTotal unread conversationsfailed, code:${result.code}|desc:${result.desc}');
  }
  } catch (e) {
  _addLog('GetTotal unread conversationsfailed: $e');
  }
  }

  // CreateConversation group
  Future<void> _createConversationGroup() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .createConversationGroup(
  groupName: _groupNameController.text,
  conversationIDList: _conversationIDListController.text.split(','),
  );
  _addLog('CreateConversation groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('CreateConversation groupfailed: $e');
  }
  }

  // GetConversation grouplist
  Future<void> _getConversationGroupList() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .getConversationGroupList();
  if (result.code == 0) {
  _addLog('GetConversation grouplist: ${result.data}');
  } else {
  _addLog('GetConversation grouplistfailed, code:${result.code}|desc:${result.desc}');
  }
  } catch (e) {
  _addLog('GetConversation grouplistfailed: $e');
  }
  }

  // DeleteConversation group
  Future<void> _deleteConversationGroup() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .deleteConversationGroup(
  groupName: _groupNameController.text,
  );
  _addLog('DeleteConversation groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('DeleteConversation groupfailed: $e');
  }
  }

  // RenameConversation group
  Future<void> _renameConversationGroup() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .renameConversationGroup(
  oldName: _oldNameController.text,
  newName: _newNameController.text,
  );
  _addLog('RenameConversation groupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('RenameConversation groupfailed: $e');
  }
  }

  // AddConversationtoGroup
  Future<void> _addConversationsToGroup() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .addConversationsToGroup(
  groupName: _groupNameController.text,
  conversationIDList: _conversationIDListController.text.split(','),
  );
  _addLog('AddConversationtoGroupsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('AddConversationtoGroupfailed: $e');
  }
  }

  // Remove from groupConversation
  Future<void> _deleteConversationsFromGroup() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .deleteConversationsFromGroup(
  groupName: _groupNameController.text,
  conversationIDList: _conversationIDListController.text.split(','),
  );
  _addLog('Remove from groupConversationsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Remove from groupConversationfailed: $e');
  }
  }

  // GetUnread message count
  Future<void> _getUnreadMessageCountByFilter() async {
  try {
  final filter = V2TimConversationFilter(
  conversationType: _selectedConversationType,
  conversationGroup: _groupNameController.text,
  markType: _getCompositeMarkType(),
  hasUnreadCount: _filterHasUnreadCountValue,
  hasGroupAtInfo: _hasGroupAtInfoValue,
  );
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .getUnreadMessageCountByFilter(filter: filter);
  _addLog('GetUnread message countsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('GetUnread message countfailed: $e');
  }
  }

  // SubscribeUnread message count
  Future<void> _subscribeUnreadMessageCountByFilter() async {
  try {
  final filter = V2TimConversationFilter(
  conversationType: _selectedConversationType,
  conversationGroup: _groupNameController.text,
  markType: _getCompositeMarkType(),
  hasUnreadCount: _filterHasUnreadCountValue,
  hasGroupAtInfo: _hasGroupAtInfoValue,
  );
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .subscribeUnreadMessageCountByFilter(filter: filter);
  _addLog('SubscribeUnread message countsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('SubscribeUnread message countfailed: $e');
  }
  }

  // UnsubscribeUnread message count
  Future<void> _unsubscribeUnreadMessageCountByFilter() async {
  try {
  final filter = V2TimConversationFilter(
  conversationType: _selectedConversationType,
  conversationGroup: _groupNameController.text,
  markType: _getCompositeMarkType(),
  hasUnreadCount: _filterHasUnreadCountValue,
  hasGroupAtInfo: _hasGroupAtInfoValue,
  );
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .unsubscribeUnreadMessageCountByFilter(filter: filter);
  _addLog('UnsubscribeUnread message countsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('UnsubscribeUnread message countfailed: $e');
  }
  }

  // Clear conversation unread count
  Future<void> _cleanConversationUnreadMessageCount() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .cleanConversationUnreadMessageCount(
  conversationID: _conversationIDController.text,
  cleanTimestamp: int.tryParse(_cleanTimestampController.text) ?? 0,
  cleanSequence: int.tryParse(_cleanSequenceController.text) ?? 0,
  );
  _addLog('Clear conversation unread countsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Clear conversation unread countfailed: $e');
  }
  }

  // GetFilter Conversationlist
  Future<void> _getConversationListByFilter() async {
  try {
  final filter = V2TimConversationFilter(
  conversationType: _selectedConversationType,
  conversationGroup: _groupNameController.text,
  markType: _getCompositeMarkType(),
  hasUnreadCount: _filterHasUnreadCountValue,
  hasGroupAtInfo: _hasGroupAtInfoValue,
  );
  final result = await TencentImSDKPlugin.v2TIMManager
  .getConversationManager()
  .getConversationListByFilter(
  filter: filter,
  nextSeq: _nextSeqController.text.isEmpty ? 0 : int.parse(_nextSeqController.text),
  count: int.tryParse(_countController.text) ?? 20,
  );
  if (result.code == 0) {
  V2TimConversationResult conversationResult = result.data!;
  _addLog('GetConversationlistsuccess: nextSeq:${conversationResult.nextSeq}, isFinished:${conversationResult.isFinished}');
  for (var conversation in conversationResult.conversationList!) {
  _addLog('Conversation: ${conversation?.toJson()}\n');
  }
  } else {
  _addLog('GetConversationlistfailed, code:${result.code}|desc:${result.desc}');
  }
  } catch (e) {
  _addLog('GetConversationlistfailed: $e');
  }
  }

  // calculateCompositeMark type
  int? _getCompositeMarkType() {
  if (_selectedFilterMarkTypes.isEmpty) {
  return null;
  }

  // If selected"No mark"，then returnnull
  if (_selectedFilterMarkTypes.contains(0)) {
  return null;
  }

  // calculateCompositeMark type（Bitwise OR）
  int result = 0;
  for (int markType in _selectedFilterMarkTypes) {
  result |= markType;
  }
  return result;
  }

  @override
  Widget build(BuildContext context) {
  final inputFields = [
  // ConversationIDSeparate line，Because it may be long
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('ConversationID', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _conversationIDController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterConversationID',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  ),
  ),
  ],
  ),
  // ConversationIDlistSeparate line，Because it may be long
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('ConversationIDlist', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _conversationIDListController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterConversationIDlist(Separated by commas)',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  ),
  ),
  ],
  ),
  // Pagination cursorandGet countOn one line
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Pagination cursor', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _nextSeqController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Default0',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 16),
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Get count', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _countController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Default20',
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
  // Conversation typeandMark type+WhetherMarkOn one line
  Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Conversation type', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: DropdownButtonFormField<int>(
  value: _selectedConversationType,
  decoration: const InputDecoration(
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  items: _conversationTypeMap.entries.map((entry) {
  return DropdownMenuItem<int>(
  value: entry.key,
  child: Text(entry.value, style: const TextStyle(fontSize: 11)),
  );
  }).toList(),
  onChanged: (int? value) {
  setState(() {
  _selectedConversationType = value ?? ConversationType.CONVERSATION_TYPE_INVALID;
  });
  },
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 8),
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Mark type', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: DropdownButtonFormField<int>(
  value: _selectedMarkType,
  decoration: const InputDecoration(
  contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
  border: OutlineInputBorder(),
  ),
  items: _markTypeMap.entries.map((entry) {
  return DropdownMenuItem<int>(
  value: entry.key,
  child: Text(entry.value, style: const TextStyle(fontSize: 10)),
  );
  }).toList(),
  onChanged: (int? value) {
  setState(() {
  _selectedMarkType = value ?? 0;
  });
  },
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 16),
  Expanded(
  child: CheckboxListTile(
  title: const Text('WhetherMark', style: TextStyle(fontSize: 12)),
  value: _enableMarkValue,
  contentPadding: const EdgeInsets.only(left: 0),
  onChanged: (bool? value) {
  setState(() {
  _enableMarkValue = value ?? false;
  });
  },
  ),
  ),
  ],
  ),
  // FilterMark typeOn one line
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('FilterMark type（Multiple selection）', style: TextStyle(fontSize: 12)),
  Wrap(
  spacing: 8.0,
  children: _markTypeMap.entries.map((entry) {
  return FilterChip(
  label: Text(entry.value, style: const TextStyle(fontSize: 11)),
  selected: _selectedFilterMarkTypes.contains(entry.key),
  onSelected: (bool selected) {
  setState(() {
  if (selected) {
  _selectedFilterMarkTypes.add(entry.key);
  } else {
  _selectedFilterMarkTypes.remove(entry.key);
  }
  });
  },
  );
  }).toList(),
  ),
  ],
  ),
  // WhetherFilterIncludeUnread ConversationandWhetherInclude@InfoOn one line
  Row(
  children: [
  Expanded(
  child: CheckboxListTile(
  title: const Text('Whether to filter conversations with unread count', style: TextStyle(fontSize: 12)),
  value: _filterHasUnreadCountValue,
  contentPadding: const EdgeInsets.only(left: 0),
  onChanged: (bool? value) {
  setState(() {
  _filterHasUnreadCountValue = value ?? false;
  });
  },
  ),
  ),
  Expanded(
  child: CheckboxListTile(
  title: const Text('WhetherInclude@Info', style: TextStyle(fontSize: 12)),
  value: _hasGroupAtInfoValue,
  contentPadding: const EdgeInsets.only(left: 0),
  onChanged: (bool? value) {
  setState(() {
  _hasGroupAtInfoValue = value ?? false;
  });
  },
  ),
  ),
  ],
  ),
  // Draft contentandCustom dataOn one line
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Draft content', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _draftTextController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterDraft content',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 16),
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Custom data', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _customDataController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterCustom data',
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
  // WhetherPinandWhetherClear messagesOn one line
  Row(
  children: [
  Expanded(
  child: CheckboxListTile(
  title: const Text('WhetherPin', style: TextStyle(fontSize: 12)),
  value: _isPinnedValue,
  contentPadding: const EdgeInsets.only(left: 0),
  onChanged: (bool? value) {
  setState(() {
  _isPinnedValue = value ?? false;
  });
  },
  ),
  ),
  Expanded(
  child: CheckboxListTile(
  title: const Text('WhetherClear messages', style: TextStyle(fontSize: 12)),
  value: _clearMessageValue,
  contentPadding: const EdgeInsets.only(left: 6),
  onChanged: (bool? value) {
  setState(() {
  _clearMessageValue = value ?? false;
  });
  },
  ),
  ),
  ],
  ),
  // Group nameandOriginal group nameOn one line
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Group name', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _groupNameController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterGroup name',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 16),
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Original group name', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _oldNameController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterOriginal group name',
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
  // New group nameandConversation typeOn one line
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('New group name', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _newNameController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterNew group name',
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
  // Parameters for clearing conversation unread count
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Clear timestamp', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _cleanTimestampController,
  style: const TextStyle(fontSize: 11),
  decoration: const InputDecoration(
  hintText: 'Please enterClear timestamp',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  ),
  ),
  ],
  ),
  ),
  const SizedBox(width: 16),
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Clear sequence number', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _cleanSequenceController,
  style: const TextStyle(fontSize: 11),
  decoration: const InputDecoration(
  hintText: 'Please enterClear sequence number',
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
  APITestButton(text: 'GetConversationlist', onPressed: _getConversationList),
  APITestButton(text: 'GetFilter Conversationlist', onPressed: _getConversationListByFilter),
  APITestButton(text: 'GetConversationlist(No formatting)', onPressed: _getConversationListWithoutFormat),
  APITestButton(text: 'GetConversation info', onPressed: _getConversationInfo),
  APITestButton(text: 'SetConversation draft', onPressed: _setConversationDraft),
  APITestButton(text: 'DeleteConversation', onPressed: _deleteConversation),
  APITestButton(text: 'DeleteConversationlist', onPressed: _deleteConversationList),
  APITestButton(text: 'Mark conversation', onPressed: _markConversation),
  APITestButton(text: 'GetspecifiedConversationlist', onPressed: _getConversationListByID),
  APITestButton(text: 'SetCustom data', onPressed: _setConversationCustomData),
  APITestButton(text: 'Pin conversation', onPressed: _pinConversation),
  APITestButton(text: 'GetTotal unread conversations', onPressed: _getTotalUnreadMessageCount),
  APITestButton(text: 'CreateConversation group', onPressed: _createConversationGroup),
  APITestButton(text: 'GetConversation grouplist', onPressed: _getConversationGroupList),
  APITestButton(text: 'DeleteConversation group', onPressed: _deleteConversationGroup),
  APITestButton(text: 'RenameConversation group', onPressed: _renameConversationGroup),
  APITestButton(text: 'AddConversationtoGroup', onPressed: _addConversationsToGroup),
  APITestButton(text: 'Remove from groupConversation', onPressed: _deleteConversationsFromGroup),
  APITestButton(text: 'GetUnread message count', onPressed: _getUnreadMessageCountByFilter),
  APITestButton(text: 'SubscribeUnread message count', onPressed: _subscribeUnreadMessageCountByFilter),
  APITestButton(text: 'UnsubscribeUnread message count', onPressed: _unsubscribeUnreadMessageCountByFilter),
  APITestButton(text: 'Clear conversation unread count', onPressed: _cleanConversationUnreadMessageCount),
  ];

  return BaseAPITest(
  title: 'Conversation management',
  inputFields: inputFields,
  buttons: buttons,
  onClearLog: _clearLog,
  );
  }

  @override
  void dispose() {
  _conversationIDController.dispose();
  _nextSeqController.dispose();
  _countController.dispose();
  _draftTextController.dispose();
  _markTypeController.dispose();
  _enableMarkController.dispose();
  _conversationIDListController.dispose();
  _customDataController.dispose();
  _groupNameController.dispose();
  _oldNameController.dispose();
  _newNameController.dispose();
  _isPinnedController.dispose();
  _clearMessageController.dispose();
  _filterTypeController.dispose();
  _filterConversationTypeController.dispose();
  _filterEnableMarkController.dispose();
  _cleanTimestampController.dispose();
  _cleanSequenceController.dispose();
  super.dispose();
  }
}