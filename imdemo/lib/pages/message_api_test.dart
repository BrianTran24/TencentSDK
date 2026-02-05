import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/enum/get_group_message_read_member_list_filter.dart';
import 'package:tencent_cloud_chat_sdk/enum/history_msg_get_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/image_types.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_priority_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/receive_message_opt_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/v2_tim_keyword_list_match_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_image.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_image.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_extension.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message_extension.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_list_result.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message_list_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_search_param.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message_search_param.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_search_result.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message_search_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_search_result_item.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message_search_result_item.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart'
  if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sdk_example/utils/log_manager.dart';
import '../utils/utils.dart';
import 'base_api_test.dart';

class MessageAPITest extends StatefulWidget {
  const MessageAPITest({Key? key}) : super(key: key);

  @override
  State<MessageAPITest> createState() => _MessageAPITestState();
}

class _MessageAPITestState extends State<MessageAPITest> {
  final TextEditingController _receiverIDController = TextEditingController();
  final TextEditingController _groupIDController = TextEditingController();
  final TextEditingController _messageContentController = TextEditingController();
  final TextEditingController _customDataController = TextEditingController();
  final TextEditingController _messageTypeController = TextEditingController();
  final TextEditingController _conversationIDController = TextEditingController();
  // Parameters for pulling historical messages
  final TextEditingController _countHistoryController = TextEditingController(text: '20');
  final TextEditingController _lastMsgIDHistoryController = TextEditingController();
  final TextEditingController _lastMsgSeqHistoryController = TextEditingController();
  final TextEditingController _messageTypeListHistoryController = TextEditingController();
  final TextEditingController _messageSeqListHistoryController = TextEditingController();
  final TextEditingController _timeBeginHistoryController = TextEditingController();
  final TextEditingController _timePeriodHistoryController = TextEditingController();

  final TextEditingController _faceIndexController = TextEditingController();
  final TextEditingController _faceDataController = TextEditingController();
  final TextEditingController _locationDescController = TextEditingController();
  final TextEditingController _locationLongitudeController = TextEditingController();
  final TextEditingController _locationLatitudeController = TextEditingController();

  // Media message related controllers
  final TextEditingController _videoDurationController = TextEditingController();
  final TextEditingController _soundDurationController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();

  // Merged and forwarded message related controllers
  final TextEditingController _mergerMsgIDListController = TextEditingController();
  final TextEditingController _forwardMsgIDListController = TextEditingController();

  // @Message related controllers
  final TextEditingController _atUserIDListController = TextEditingController();
  final TextEditingController _atTextController = TextEditingController();

  // Local custom data and integer related controllers
  final TextEditingController _localCustomDataController = TextEditingController();
  final TextEditingController _localCustomIntController = TextEditingController();

  // Search text controller
  final TextEditingController _searchMessageController1 = TextEditingController();
  final TextEditingController _searchMessageController2 = TextEditingController();

  // Store retrieved message list
  List<V2TimMessage> _messageList = [];

  // Using global log manager and listener manager
  final LogManager _logManager = LogManager();

  // Message receive option
  ReceiveMsgOptEnum _receiveMessageOpt = ReceiveMsgOptEnum.V2TIM_RECEIVE_MESSAGE;

  @override
  void initState() {
  super.initState();
  // Initialize global listeners
  _receiverIDController.text = 'teacher13';
  _groupIDController.text = 'public15';
  _messageContentController.text = 'testMessage';
  _customDataController.text = 'Custom data';
  _faceIndexController.text = '1';
  _faceDataController.text = '[Smile]';
  _locationDescController.text = 'Shenzhen Tencent Binhai Building';
  _locationLongitudeController.text = '113.943488';
  _locationLatitudeController.text = '22.546057';
  }

  // Helper method for adding logs
  void _addLog(String log) {
  _logManager.updateLogText(log);
  }

  // Clear log
  void _clearLog() {
  _logManager.clearAllLogs();
  }

  // SendText message
  Future<void> _sendTextMessage() async {
  if (_messageContentController.text.isEmpty) {
  _addLog('Please enterMessage content');
  return;
  }
  if (_receiverIDController.text.isEmpty && _groupIDController.text.isEmpty) {
  _addLog('Please enterReceiverIDorGroupID');
  return;
  }
  try {
  // Create firstText message
  V2TimValueCallback<V2TimMsgCreateInfoResult> createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createTextMessage(
  text: _messageContentController.text,
  );

  if (createResult.code != 0) {
  _addLog('CreateText messagefailed: ${createResult.toLogString()}');
  return;
  }

  V2TimMessage? createMessage = createResult.data?.messageInfo!;
  createMessage!.needReadReceipt = true;
  createMessage.isSupportMessageExtension = true;

  // uikit-v2 Will set message status to sending，Test it. Set by business layer status Do not pass to underlying layer.
  // createMessage.status = MessageStatus.V2TIM_MSG_STATUS_SENDING;

  // Send created message
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
  message: createMessage!,
  onSyncMsgID: (String msgID) {
  _addLog('sendMessage onSyncMsgID: $msgID');
  },
  receiver: _receiverIDController.text,
  groupID: _groupIDController.text,
  priority: MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
  onlineUserOnly: false,
  offlinePushInfo: null,
  cloudCustomData: 'Cloud custom data from api',
  );
  if (result.code == 0) {
  _addLog('SendText messagesuccess: ${result.toLogString()}\n');
  } else {
  _addLog('SendText messagefailed: ${result.toLogString()}\n');
  }
  } catch (e) {
  _addLog('SendText messagefailed: $e\n');
  }
  }

  // SendCustom message
  Future<void> _sendCustomMessage() async {
  if (_customDataController.text.isEmpty) {
  _addLog('Please enterCustom data');
  return;
  }
  if (_receiverIDController.text.isEmpty && _groupIDController.text.isEmpty) {
  _addLog('Please enterReceiverIDorGroupID');
  return;
  }
  try {
  // Create firstCustom message
  final createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createCustomMessage(
  data: _customDataController.text,
  desc: 'Custom message',
  extension: '',
  );

  if (createResult.code != 0) {
  _addLog('CreateCustom messagefailed: ${createResult.toLogString()}');
  return;
  }

  // Send created message
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
  id: createResult.data?.id ?? '',
  receiver: _receiverIDController.text,
  groupID: _groupIDController.text,
  priority: MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
  needReadReceipt: true,
  isSupportMessageExtension: true,
  );
  _addLog('SendCustom messagesuccess: ${result.toLogString()}');
  } catch (e) {
  _addLog('SendCustom messagefailed: $e');
  }
  }

  // SendEmoji message
  Future<void> _sendFaceMessage() async {
  if (_faceIndexController.text.isEmpty || _faceDataController.text.isEmpty) {
  _addLog('Please enterEmoji indexandEmoji data');
  return;
  }
  if (_receiverIDController.text.isEmpty && _groupIDController.text.isEmpty) {
  _addLog('Please enterReceiverIDorGroupID');
  return;
  }
  try {
  // Create firstEmoji message
  final createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createFaceMessage(
  index: int.parse(_faceIndexController.text),
  data: _faceDataController.text,
  );

  if (createResult.code != 0) {
  _addLog('CreateEmoji messagefailed: ${createResult.toLogString()}');
  return;
  }

  // Send created message
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
  id: createResult.data?.id ?? '',
  receiver: _receiverIDController.text,
  groupID: _groupIDController.text,
  priority: MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
  needReadReceipt: true,
  isSupportMessageExtension: true,
  );
  _addLog('SendEmoji messagesuccess: ${result.toLogString()}');
  } catch (e) {
  _addLog('SendEmoji messagefailed: $e');
  }
  }

  // SendLocation message
  Future<void> _sendLocationMessage() async {
  if (_locationDescController.text.isEmpty ||
  _locationLongitudeController.text.isEmpty ||
  _locationLatitudeController.text.isEmpty) {
  _addLog('Please enterLocation description, LongitudeandLatitude');
  return;
  }
  if (_receiverIDController.text.isEmpty && _groupIDController.text.isEmpty) {
  _addLog('Please enterReceiverIDorGroupID');
  return;
  }
  try {
  // Create firstLocation message
  final createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createLocationMessage(
  desc: _locationDescController.text,
  longitude: double.parse(_locationLongitudeController.text),
  latitude: double.parse(_locationLatitudeController.text),
  );

  if (createResult.code != 0) {
  _addLog('CreateLocation messagefailed: ${createResult.toLogString()}');
  return;
  }

  // Send created message
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
  id: createResult.data?.id ?? '',
  receiver: _receiverIDController.text,
  groupID: _groupIDController.text,
  priority: MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
  needReadReceipt: true,
  isSupportMessageExtension: true,
  );
  _addLog('SendLocation messagesuccess: ${result.toLogString()}');
  } catch (e) {
  _addLog('SendLocation messagefailed: $e');
  }
  }

  // Get message history
  Future<void> _getGroupMessageHistory() async {
  if (_countHistoryController.text.isEmpty) {
  _addLog('Please enterGetMessagecount');
  return;
  }

  V2TimMessage? lastMessage;
  if (_messageList.isNotEmpty) {
  lastMessage = _messageList.last;
  }

  V2TimValueCallback<List<V2TimMessage>> resultTest = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getGroupHistoryMessageList(
  groupID: _groupIDController.text.isEmpty ? "" : _groupIDController.text,
  count: 1);
  if (resultTest.code == 0) {
  _addLog('Get group historical messagessuccess');
  } else {
  _addLog('Get group historical messagesfailed, code: ${resultTest.code}, desc: ${resultTest.desc}');
  }

  try {
  V2TimValueCallback<V2TimMessageListResult> result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getHistoryMessageListV2(
  getType: HistoryMsgGetTypeEnum.V2TIM_GET_CLOUD_OLDER_MSG,
  userID: "",
  groupID: _groupIDController.text.isEmpty ? null : _groupIDController.text,
  lastMsgSeq: _lastMsgSeqHistoryController.text.isEmpty ? -1 : int.parse(_lastMsgSeqHistoryController.text),
  count: int.parse(_countHistoryController.text),
  lastMsg: lastMessage,
  messageTypeList: _messageTypeListHistoryController.text.isEmpty ? null :
  _messageTypeListHistoryController.text.split(',').map((e) => int.parse(e)).toList(),
  messageSeqList: _messageSeqListHistoryController.text.isEmpty ? null :
  _messageSeqListHistoryController.text.split(',').map((e) => int.parse(e)).toList(),
  timeBegin: _timeBeginHistoryController.text.isEmpty ? null : int.parse(_timeBeginHistoryController.text),
  timePeriod: _timePeriodHistoryController.text.isEmpty ? null : int.parse(_timePeriodHistoryController.text),
  );
  if (result.code == 0) {
  _messageList = result.data?.messageList ?? [];
  String messageListLog = '';
  for (V2TimMessage msg in _messageList) {
  messageListLog += '${msg.toLogString()}|content:${Utils.getMessageContent(msg)}\n\n';
  }
  _addLog('Get message history: $messageListLog');
  } else {
  _addLog('Get message historyfailed, code: ${result.code}, desc: ${result.desc}');
  }
  } catch (e) {
  _addLog('Get message historyfailed: $e');
  }
  }

  // Get message history
  Future<void> _getC2CMessageHistory() async {
  if (_countHistoryController.text.isEmpty) {
  _addLog('Please enterGetMessagecount');
  return;
  }

  V2TimMessage? lastMessage;
  if (_messageList.isNotEmpty) {
  lastMessage = _messageList.last;
  }

  V2TimValueCallback<List<V2TimMessage>> resultTest = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getC2CHistoryMessageList(
  userID: _receiverIDController.text.isEmpty ? "" : _receiverIDController.text,
  count: 1);
  if (resultTest.code == 0) {
  _addLog('Get C2C Historical messagesuccess');
  } else {
  _addLog('Get C2C Historical messagefailed, code: ${resultTest.code}, desc: ${resultTest.desc}');
  }

  try {
  V2TimValueCallback<V2TimMessageListResult> result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getHistoryMessageListV2(
  getType: HistoryMsgGetTypeEnum.V2TIM_GET_CLOUD_OLDER_MSG,
  userID: _receiverIDController.text.isEmpty ? null : _receiverIDController.text,
  groupID: "",
  lastMsgSeq: _lastMsgSeqHistoryController.text.isEmpty ? -1 : int.parse(_lastMsgSeqHistoryController.text),
  count: int.parse(_countHistoryController.text),
  lastMsg: lastMessage,
  messageTypeList: _messageTypeListHistoryController.text.isEmpty ? null :
  _messageTypeListHistoryController.text.split(',').map((e) => int.parse(e)).toList(),
  messageSeqList: _messageSeqListHistoryController.text.isEmpty ? null :
  _messageSeqListHistoryController.text.split(',').map((e) => int.parse(e)).toList(),
  timeBegin: _timeBeginHistoryController.text.isEmpty ? null : int.parse(_timeBeginHistoryController.text),
  timePeriod: _timePeriodHistoryController.text.isEmpty ? null : int.parse(_timePeriodHistoryController.text),
  );
  if (result.code == 0) {
  _messageList = result.data?.messageList ?? [];
  String messageListLog = '';
  for (V2TimMessage msg in _messageList) {
  messageListLog += '${msg.toLogString()}|content:${Utils.getMessageContent(msg)}\n\n';
  }
  _addLog('Get message history: $messageListLog');
  } else {
  _addLog('Get message historyfailed, code: ${result.code}, desc: ${result.desc}');
  }
  } catch (e) {
  _addLog('Get message historyfailed: $e');
  }
  }

  // RecallMessage
  Future<void> _revokeMessage() async {
  V2TimMessage? lastMessage;
  if (_messageList.isNotEmpty) {
  lastMessage = _messageList.first;
  } else {
  _addLog('Please get historical messages first，willRecallLatest message');
  return;
  }

  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().revokeMessage(
  message: lastMessage,
  );

  _addLog('RecallMessage: ${result.toLogString()}');
  } catch (e) {
  _addLog('RecallMessagefailed: $e');
  }
  }

  // SendImage message
  Future<void> _sendImageMessage() async {
  if (_receiverIDController.text.isEmpty && _groupIDController.text.isEmpty) {
  _addLog('Please enterReceiverIDorGroupID');
  return;
  }
  try {
  // Create firstImage message
  final createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createImageMessage(
  imagePath: '/storage/emulated/0/test.png',
  );

  if (createResult.code != 0) {
  _addLog('CreateImage messagefailed: ${createResult.toLogString()}');
  return;
  }

  // Send created message
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
  id: createResult.data?.id ?? '',
  receiver: _receiverIDController.text,
  groupID: _groupIDController.text,
  priority: MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
  needReadReceipt: true,
  isSupportMessageExtension: true,
  );
  if (result.code == 0) {
  _addLog('SendImage messagesuccess，msgID: ${result.data?.msgID}');
  } else {
  _addLog('SendImage messagefailed，code: ${result.code}, desc: ${result.desc}');
  }

  } catch (e) {
  _addLog('SendImage messagefailed: $e');
  }
  }

  // SendVideo message
  Future<void> _sendVideoMessage() async {
  if (_receiverIDController.text.isEmpty && _groupIDController.text.isEmpty) {
  _addLog('Please enterReceiverIDorGroupID');
  return;
  }
  try {
  // Create firstVideo message
  final createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createVideoMessage(
  videoFilePath: '/storage/emulated/0/test.mp4',
  snapshotPath: '/storage/emulated/0/test-snapshot.png',
  duration: int.parse(_videoDurationController.text),
  type: "mp4",
  );

  if (createResult.code != 0) {
  _addLog('CreateVideo messagefailed: ${createResult.toJson()}');
  return;
  }

  // Send created message
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
  id: createResult.data?.id ?? '',
  receiver: _receiverIDController.text,
  groupID: _groupIDController.text,
  priority: MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
  needReadReceipt: true,
  isSupportMessageExtension: true,
  );
  _addLog('SendVideo messagesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('SendVideo messagefailed: $e');
  }
  }

  // SendVoice message
  Future<void> _sendSoundMessage() async {
  if (_receiverIDController.text.isEmpty && _groupIDController.text.isEmpty) {
  _addLog('Please enterReceiverIDorGroupID');
  return;
  }
  try {
  // Create firstVoice message
  final createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createSoundMessage(
  soundPath: '/storage/emulated/0/test.mp3',
  duration: int.parse(_soundDurationController.text),
  );

  if (createResult.code != 0) {
  _addLog('CreateVoice messagefailed: ${createResult.toJson()}');
  return;
  }

  // Send created message
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
  id: createResult.data?.id ?? '',
  receiver: _receiverIDController.text,
  groupID: _groupIDController.text,
  priority: MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
  needReadReceipt: true,
  isSupportMessageExtension: true,
  );
  _addLog('SendVoice messagesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('SendVoice messagefailed: $e');
  }
  }

  // SendFile message
  Future<void> _sendFileMessage() async {
  if (_receiverIDController.text.isEmpty && _groupIDController.text.isEmpty) {
  _addLog('Please enterReceiverIDorGroupID');
  return;
  }
  if (_fileNameController.text.isEmpty) {
  _addLog('Please enterFile name');
  return;
  }
  try {
  // Create firstFile message
  final createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createFileMessage(
  filePath: '/storage/emulated/0/test.mp3',
  fileName: _fileNameController.text,
  );

  if (createResult.code != 0) {
  _addLog('CreateFile messagefailed: ${createResult.toJson()}');
  return;
  }

  // Send created message
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
  id: createResult.data?.id ?? '',
  receiver: _receiverIDController.text,
  groupID: _groupIDController.text,
  priority: MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
  needReadReceipt: true,
  isSupportMessageExtension: true,
  );
  _addLog('SendFile messagesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('SendFile messagefailed: $e');
  }
  }

  // SendMerged message
  Future<void> _sendMergerMessage() async {
  if (_receiverIDController.text.isEmpty && _groupIDController.text.isEmpty) {
  _addLog('Please enterReceiverIDorGroupID');
  return;
  }
  if (_messageList.length < 2) {
  _addLog('Please get at least two message history first');
  return;
  }
  try {
  // Create firstMerged message
  final createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createMergerMessage(
  messageList: [_messageList[0], _messageList[1]], // Use the first two messages
  title: 'Merged message title',
  abstractList: ['Summary1', 'Summary2'],
  compatibleText: "Merged message",
  );

  if (createResult.code != 0) {
  _addLog('CreateMerged messagefailed: ${createResult.toJson()}');
  return;
  }

  V2TimMessage? createMessage = createResult.data?.messageInfo!;
  createMessage!.needReadReceipt = true;
  createMessage.isSupportMessageExtension = true;

  // Send created message
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
  message: createMessage!,
  onSyncMsgID: (String msgID) {
  _addLog('sendMessage onSyncMsgID: $msgID');
  },
  receiver: _receiverIDController.text,
  groupID: _groupIDController.text,
  );
  _addLog('SendMerged messagesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('SendMerged messagefailed: $e');
  }
  }

  // SendForwarded message
  Future<void> _sendForwardMessage() async {
  if (_receiverIDController.text.isEmpty && _groupIDController.text.isEmpty) {
  _addLog('Please enterReceiverIDorGroupID');
  return;
  }
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  // Create firstForwarded message
  final createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createForwardMessage(
  message: _messageList[0], // Use the first message
  );

  if (createResult.code != 0) {
  _addLog('CreateForwarded messagefailed: ${createResult.toJson()}');
  return;
  }

  V2TimMessage? createMessage = createResult.data?.messageInfo!;
  createMessage!.needReadReceipt = true;
  createMessage.isSupportMessageExtension = true;

  // Send created message
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
  message: createResult.data?.messageInfo,
  onSyncMsgID: (String msgID) {
  _addLog('sendMessage onSyncMsgID: $msgID');
  },
  receiver: _receiverIDController.text,
  groupID: _groupIDController.text,
  );

  if (result.code == 0) {
  _addLog('SendForwarded messagesuccess: ${result.toLogString()}');
  } else {
  _addLog('SendForwarded messagefailed: ${result.toLogString()}');
  }
  } catch (e) {
  _addLog('SendForwarded messagefailed: $e');
  }
  }

  // Send@Message
  Future<void> _sendTextAtMessage() async {
  if (_receiverIDController.text.isEmpty && _groupIDController.text.isEmpty) {
  _addLog('Please enterReceiverIDorGroupID');
  return;
  }
  if (_atTextController.text.isEmpty) {
  _addLog('Please enter@Message content');
  return;
  }
  if (_atUserIDListController.text.isEmpty) {
  _addLog('Please enter@User ID list');
  return;
  }
  try {
  // Create first@Message
  final createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createTextAtMessage(
  text: _atTextController.text,
  atUserList: _atUserIDListController.text.split(','),
  );

  if (createResult.code != 0) {
  _addLog('Create@Messagefailed: ${createResult.toJson()}');
  return;
  }

  // Send created message
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
  id: createResult.data?.id ?? '',
  receiver: _receiverIDController.text,
  groupID: _groupIDController.text,
  priority: MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
  needReadReceipt: true,
  isSupportMessageExtension: true,
  );
  _addLog('Send@Messagesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Send@Messagefailed: $e');
  }
  }

  // Download merged message
  Future<void> _downloadMergerMessage() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().downloadMergerMessage(
  msgID: _messageList[0].msgID ?? "",
  );
  _addLog('Download merged message: ${result.toJson()}');
  } catch (e) {
  _addLog('Download merged messagefailed: $e');
  }
  }

  // SetC2CMessage receive option
  Future<void> _setC2CReceiveMessageOpt() async {
  if (_receiverIDController.text.isEmpty) {
  _addLog('Please enterUserID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().setC2CReceiveMessageOpt(
  userIDList: [_receiverIDController.text],
  opt: _receiveMessageOpt,
  );
  _addLog('SetC2CMessage receive option: ${result.toJson()}');
  } catch (e) {
  _addLog('SetC2CMessage receive optionfailed: $e');
  }
  }

  // GetC2CMessage receive option
  Future<void> _getC2CReceiveMessageOpt() async {
  if (_receiverIDController.text.isEmpty) {
  _addLog('Please enterUserID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getC2CReceiveMessageOpt(
  userIDList: [_receiverIDController.text],
  );
  _addLog('GetC2CMessage receive option: ${result.toJson()}');
  } catch (e) {
  _addLog('GetC2CMessage receive optionfailed: $e');
  }
  }

  // Set group message receive option
  Future<void> _setGroupReceiveMessageOpt() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().setGroupReceiveMessageOpt(
  groupID: _groupIDController.text,
  opt: _receiveMessageOpt,
  );
  _addLog('Set group message receive option: ${result.toJson()}');
  } catch (e) {
  _addLog('Set group message receive optionfailed: $e');
  }
  }

  // Set global message receive option
  Future<void> _setAllReceiveMessageOpt() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().setAllReceiveMessageOpt(
  opt: _receiveMessageOpt.index,
  startHour: 0,  // Default from0Click start
  startMinute: 0,
  startSecond: 0,
  duration: 24 * 60 * 60,  // Default duration24hours
  );
  _addLog('Set global message receive option: ${result.toJson()}');
  } catch (e) {
  _addLog('Set global message receive optionfailed: $e');
  }
  }

  // Set global message receive option（With timestamp）
  Future<void> _setAllReceiveMessageOptWithTimestamp() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().setAllReceiveMessageOptWithTimestamp(
  opt: _receiveMessageOpt.index,
  startTimeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
  duration: 24 * 60 * 60,  // Default duration24hours
  );
  _addLog('Set global message receive option(With timestamp): ${result.toJson()}');
  } catch (e) {
  _addLog('Set global message receive option(With timestamp)failed: $e');
  }
  }

  // GetGlobal message receive option
  Future<void> _getAllReceiveMessageOpt() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getAllReceiveMessageOpt();
  _addLog('GetGlobal message receive option: ${result.toJson()}');
  } catch (e) {
  _addLog('GetGlobal message receive optionfailed: $e');
  }
  }

  // Set local custom data
  Future<void> _setLocalCustomData() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  if (_localCustomDataController.text.isEmpty) {
  _addLog('Please enterLocal custom data');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().setLocalCustomData(
  msgID: _messageList[0].msgID ?? "",
  localCustomData: _localCustomDataController.text,
  );
  _addLog('Set local custom data: ${result.toJson()}');
  } catch (e) {
  _addLog('Set local custom datafailed: $e');
  }
  }

  // Set local custom int
  Future<void> _setLocalCustomInt() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  if (_localCustomIntController.text.isEmpty) {
  _addLog('Please enterLocal custom int');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().setLocalCustomInt(
  msgID: _messageList[0].msgID ?? "",
  localCustomInt: int.parse(_localCustomIntController.text),
  );
  _addLog('Set local custom int: ${result.toJson()}');
  } catch (e) {
  _addLog('Set local custom intfailed: $e');
  }
  }

  // MarkC2CMessage read
  Future<void> _markC2CMessageAsRead() async {
  if (_receiverIDController.text.isEmpty) {
  _addLog('Please enterUserID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().markC2CMessageAsRead(
  userID: _receiverIDController.text,
  );
  _addLog('MarkC2CMessage read: ${result.toJson()}');
  } catch (e) {
  _addLog('MarkC2CMessage readfailed: $e');
  }
  }

  // Mark group messages as read
  Future<void> _markGroupMessageAsRead() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().markGroupMessageAsRead(
  groupID: _groupIDController.text,
  );
  _addLog('Mark group messages as read: ${result.toJson()}');
  } catch (e) {
  _addLog('Mark group messages as readfailed: $e');
  }
  }

  // Mark all messages as read
  Future<void> _markAllMessageAsRead() async {
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().markAllMessageAsRead();
  _addLog('Mark all messages as read: ${result.toJson()}');
  } catch (e) {
  _addLog('Mark all messages as readfailed: $e');
  }
  }

  // Delete from local storageMessage
  Future<void> _deleteMessageFromLocalStorage() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().deleteMessageFromLocalStorage(
  message: _messageList[0],
  );
  _addLog('Delete from local storageMessage: ${result.toJson()}, msgID: ${_messageList[0].msgID}');
  } catch (e) {
  _addLog('Delete from local storageMessagefailed: $e');
  }
  }

  // DeleteMessage
  Future<void> _deleteMessages() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().deleteMessages(
  messageList: [_messageList[0]],
  );
  _addLog('DeleteMessagesuccess: ${result.toJson()}, msgID: ${_messageList[0].msgID}');
  } catch (e) {
  _addLog('DeleteMessagefailed: $e');
  }
  }

  // Add a message to group message list
  Future<void> _insertGroupMessageToLocalStorage() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  if (_messageContentController.text.isEmpty) {
  _addLog('Please enterMessage content');
  return;
  }
  try {
  // Create firstText message
  final createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createTextMessage(
  text: _messageContentController.text,
  );

  if (createResult.code != 0) {
  _addLog('CreateText messagefailed: ${createResult.toJson()}');
  return;
  }

  final loginUserResult = await TencentImSDKPlugin.v2TIMManager.getLoginUser();

  // InserttoLocal storage
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().insertGroupMessageToLocalStorageV2(
  groupID: _groupIDController.text,
  senderID: loginUserResult.data ?? '',
  message: createResult.data?.messageInfo,
  );
  _addLog('ToGroupMessagelistinAddMessagesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('ToGroupMessagelistinAddMessagefailed: $e');
  }
  }

  // ToC2CAdd a message to message list
  Future<void> _insertC2CMessageToLocalStorage() async {
  if (_receiverIDController.text.isEmpty) {
  _addLog('Please enterUserID');
  return;
  }
  if (_messageContentController.text.isEmpty) {
  _addLog('Please enterMessage content');
  return;
  }
  try {
  // Create firstText message
  final createResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createTextMessage(
  text: _messageContentController.text,
  );

  if (createResult.code != 0) {
  _addLog('CreateText messagefailed: ${createResult.toJson()}');
  return;
  }

  final loginUserResult = await TencentImSDKPlugin.v2TIMManager.getLoginUser();

  // InserttoLocal storage
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().insertC2CMessageToLocalStorageV2(
  userID: _receiverIDController.text,
  senderID: loginUserResult.data ?? '',
  message: createResult.data?.messageInfo,
  );
  _addLog('ToC2CMessagelistinAddMessagesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('ToC2CMessagelistinAddMessagefailed: $e');
  }
  }

  // Clear local and cloud messages of private chat
  Future<void> _clearC2CHistoryMessage() async {
  if (_receiverIDController.text.isEmpty) {
  _addLog('Please enterUserID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().clearC2CHistoryMessage(
  userID: _receiverIDController.text,
  );
  _addLog('Clear local and cloud messages of private chatsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Clear local and cloud messages of private chatfailed: $e');
  }
  }

  // Clear local and cloud messages of group chat
  Future<void> _clearGroupHistoryMessage() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().clearGroupHistoryMessage(
  groupID: _groupIDController.text,
  );
  _addLog('Clear local and cloud messages of group chatsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Clear local and cloud messages of group chatfailed: $e');
  }
  }

  // SearchLocal message
  Future<void> _searchLocalMessages() async {
  if (_searchMessageController1.text.isEmpty && _searchMessageController2.text.isEmpty) {
  _addLog('Please enterSearchcontent');
  return;
  }

  List<String> searchKeywordList = [];
  String keyword1 = _searchMessageController1.text;
  String keyword2 = _searchMessageController2.text;
  if (keyword1.isNotEmpty) {
  searchKeywordList.add(keyword1);
  }

  if (keyword2.isNotEmpty) {
  searchKeywordList.add(keyword2);
  }

  String? conversationID;
  if (_groupIDController.text.isNotEmpty) {
  conversationID = "group_${_groupIDController.text}";
  } else if (_receiverIDController.text.isNotEmpty) {
  conversationID = "c2c_${_receiverIDController.text}";
  }

  try {
  final searchParam = V2TimMessageSearchParam(
  keywordList: searchKeywordList,
  conversationID: conversationID,
  type: V2TIMKeywordListMatchType.KEYWORD_LIST_MATCH_TYPE_OR,
  messageTypeList: [MessageElemType.V2TIM_ELEM_TYPE_TEXT],
  searchTimePosition: 0,
  searchTimePeriod: 24 * 60 * 60, // 24hours
  pageSize: 20,
  pageIndex: 0,
  );
  V2TimValueCallback<V2TimMessageSearchResult> result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().searchLocalMessages(
  searchParam: searchParam,
  );

  if (result.code == 0) {
  String searchResultLog = "";
  int totalCount = result.data?.totalCount ?? 0;
  String searchCursor = result.data?.searchCursor ?? "";
  String searchResultItemList = "";
  for (V2TimMessageSearchResultItem resultItem in result.data?.messageSearchResultItems ?? []) {
  searchResultItemList += "conversationID:${resultItem.conversationID}, messageCount:${resultItem.messageCount ?? 0}, messageList--->\n";
  for (V2TimMessage v2timMessage in resultItem.messageList ?? []) {
  searchResultItemList += "${v2timMessage.toLogString()}|content:${Utils.getMessageContent(v2timMessage)}\n\n";
  }
  }

  searchResultLog = "totalCount:$totalCount, searchCursor:$searchCursor, searchItemList:$searchResultItemList";
  _addLog('SearchLocal message: $searchResultLog');
  } else {
  _addLog('SearchLocal messagefailed: ${result.toJson()}');
  }
  } catch (e) {
  _addLog('SearchLocal messagefailed: $e');
  }
  }

  // SearchCloud message
  Future<void> _searchCloudMessages() async {
  if (_searchMessageController1.text.isEmpty && _searchMessageController2.text.isEmpty) {
  _addLog('Please enterSearchcontent');
  return;
  }

  List<String> searchKeywordList = [];
  String keyword1 = _searchMessageController1.text;
  String keyword2 = _searchMessageController2.text;
  if (keyword1.isNotEmpty) {
  searchKeywordList.add(keyword1);
  }

  if (keyword2.isNotEmpty) {
  searchKeywordList.add(keyword2);
  }

  String? conversationID;
  if (_groupIDController.text.isNotEmpty) {
  conversationID = "group_${_groupIDController.text}";
  } else if (_receiverIDController.text.isNotEmpty) {
  conversationID = "c2c_${_receiverIDController.text}";
  }

  try {
  final searchParam = V2TimMessageSearchParam(
  keywordList: searchKeywordList,
  conversationID: conversationID,
  type: V2TIMKeywordListMatchType.KEYWORD_LIST_MATCH_TYPE_OR,
  messageTypeList: [MessageElemType.V2TIM_ELEM_TYPE_TEXT],
  searchTimePosition: 0,
  searchTimePeriod: 30 * 24 * 60 * 60, // 24hours
  searchCount: 10,
  );
  V2TimValueCallback<V2TimMessageSearchResult> result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().searchCloudMessages(
  searchParam: searchParam,
  );

  if (result.code == 0) {
  String searchResultLog = "";
  int totalCount = result.data?.totalCount ?? 0;
  String searchCursor = result.data?.searchCursor ?? "";
  String searchResultItemList = "";
  for (V2TimMessageSearchResultItem resultItem in result.data?.messageSearchResultItems ?? []) {
  searchResultItemList += "conversationID:${resultItem.conversationID}, messageCount:${resultItem.messageCount ?? 0}, messageList--->\n";
  for (V2TimMessage v2timMessage in resultItem.messageList ?? []) {
  searchResultItemList += "${v2timMessage.toLogString()}|content:${Utils.getMessageContent(v2timMessage)}\n\n";
  }
  }

  searchResultLog = "totalCount:$totalCount, searchCursor:$searchCursor, searchItemList:$searchResultItemList";
  _addLog('SearchCloud message: $searchResultLog');
  } else {
  _addLog('SearchCloud messagefailed: ${result.toJson()}');
  }
  } catch (e) {
  _addLog('SearchCloud messagefailed: $e');
  }
  }

  // Send message read receipt
  Future<void> _sendMessageReadReceipts() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessageReadReceipts(
  messageIDList: [_messageList[0].msgID ?? ""],
  );
  _addLog('Send message read receiptsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Send message read receiptfailed: $e');
  }
  }

  // Get message read receipt
  Future<void> _getMessageReadReceipts() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageReadReceipts(
  messageIDList: [_messageList[0].msgID ?? ""],
  );
  _addLog('Get message read receiptsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get message read receiptfailed: $e');
  }
  }

  // Get group message read member list
  Future<void> _getGroupMessageReadMemberList() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getGroupMessageReadMemberList(
  messageID: _messageList[0].msgID ?? "",
  filter: GetGroupMessageReadMemberListFilter.V2TIM_GROUP_MESSAGE_READ_MEMBERS_FILTER_READ,
  nextSeq: 0,
  count: 100,
  );
  _addLog('Get group message read member listsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get group message read member listfailed: $e');
  }
  }

  // Based on messageID QueryspecifiedConversationin Local message
  Future<void> _findMessages() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().findMessages(
  messageIDList: [_messageList[0].msgID ?? ""],
  );
  _addLog('QueryLocal messagesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('QueryLocal messagefailed: $e');
  }
  }

  // Set message extension
  Future<void> _setMessageExtensions() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final extensions = [
  V2TimMessageExtension(
  extensionKey: "key1",
  extensionValue: "value1",
  ),
  ];
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().setMessageExtensions(
  msgID: _messageList[0].msgID ?? "",
  extensions: extensions,
  );
  _addLog('Set message extension: ${result.toJson()}');
  } catch (e) {
  _addLog('Set message extensionfailed: $e');
  }
  }

  // Get message extension
  Future<void> _getMessageExtensions() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageExtensions(
  msgID: _messageList[0].msgID ?? "",
  );
  _addLog('Get message extension: ${result.toJson()}');
  } catch (e) {
  _addLog('Get message extensionfailed: $e');
  }
  }

  // DeleteMessage extension
  Future<void> _deleteMessageExtensions() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().deleteMessageExtensions(
  msgID: _messageList[0].msgID ?? "",
  keys: ["key1"],
  );
  _addLog('DeleteMessage extension: ${result.toJson()}');
  } catch (e) {
  _addLog('DeleteMessage extensionfailed: $e');
  }
  }

  // Message change
  Future<void> _modifyMessage() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final message = _messageList[0];
  message.cloudCustomData = "modified data";
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().modifyMessage(
  message: message,
  );
  _addLog('Message change: ${result.toJson()}');
  } catch (e) {
  _addLog('Message changefailed: $e');
  }
  }

  // Get multimedia messageURL
  Future<void> _getMessageOnlineUrl() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageOnlineUrl(
  msgID: _messageList[0].msgID ?? "",
  );
  _addLog('Get multimedia messageURLsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get multimedia messageURLfailed: $e');
  }
  }

  // Download multimedia message
  Future<void> _downloadMessage() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }

  int imageType = V2TIM_IMAGE_TYPE.V2TIM_IMAGE_TYPE_ORIGIN;
  bool isSnapshot = false;
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().downloadMessage(
  msgID: _messageList[0].msgID ?? "",
  messageType: MessageElemType.V2TIM_ELEM_TYPE_IMAGE,
  imageType: imageType,
  isSnapshot: isSnapshot,
  onDownloadFinished: (V2TimMessage message) {
  if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
  for (V2TimImage? image in message.imageElem?.imageList ?? []) {
  if (image == null) {
  continue;
  }

  if (imageType == V2TIM_IMAGE_TYPE.V2TIM_IMAGE_TYPE_ORIGIN ||
  imageType == V2TIM_IMAGE_TYPE.V2TIM_IMAGE_TYPE_THUMB ||
  imageType == V2TIM_IMAGE_TYPE.V2TIM_IMAGE_TYPE_LARGE) {
  _addLog('onDownloadFinished: ${image.localUrl}');
  break;
  } else {
  print("onDownloadFinished, imageType: $imageType error");
  break;
  }
  }
  } else if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_FILE) {
  _addLog('onDownloadFinished: ${message.fileElem?.localUrl}');
  } else if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND) {
  _addLog('onDownloadFinished: ${message.soundElem?.localUrl}');
  } else if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
  if (isSnapshot) {
  _addLog('onDownloadFinished: ${message.videoElem?.localSnapshotUrl}');
  } else {
  _addLog('onDownloadFinished: ${message.videoElem?.localVideoUrl}');
  }
  }
  }
  );
  _addLog('Download multimedia messagesuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Download multimedia messagefailed: $e');
  }
  }

  // Translate text
  Future<void> _translateText() async {
  if (_messageContentController.text.isEmpty) {
  _addLog('Please entertext to translate');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().translateText(
  texts: [_messageContentController.text],
  targetLanguage: "en",
  sourceLanguage: "zh",
  );
  _addLog('Translate text: ${result.toJson()}');
  } catch (e) {
  _addLog('Translate textfailed: $e');
  }
  }

  // AddMessage reaction
  Future<void> _addMessageReaction() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().addMessageReaction(
  msgID: _messageList[0].msgID ?? "",
  reactionID: "👍", // Use default emoji as reaction
  );
  _addLog('AddMessage reaction: ${result.toJson()}');
  } catch (e) {
  _addLog('AddMessage reactionfailed: $e');
  }
  }

  // RemoveMessage reaction
  Future<void> _removeMessageReaction() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().removeMessageReaction(
  msgID: _messageList[0].msgID ?? "",
  reactionID: "👍", // Use default emoji as reaction
  );
  _addLog('RemoveMessage reaction: ${result.toJson()}');
  } catch (e) {
  _addLog('RemoveMessage reactionfailed: $e');
  }
  }

  // Get message reactions
  Future<void> _getMessageReactions() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageReactions(
  msgIDList: [_messageList[0].msgID ?? ""],
  maxUserCountPerReaction: 10,
  );
  _addLog('Get message reactions: ${result.toJson()}');
  } catch (e) {
  _addLog('Get message reactionsfailed: $e');
  }
  }

  // Get all user list of message reactions
  Future<void> _getAllUserListOfMessageReaction() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getAllUserListOfMessageReaction(
  msgID: _messageList[0].msgID ?? "",
  reactionID: "👍", // Use default emoji as reaction
  nextSeq: 0,
  count: 10,
  );
  _addLog('Get all user list of message reactionssuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get all user list of message reactionsfailed: $e');
  }
  }

  // Voice to text
  Future<void> _convertVoiceToText() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().convertVoiceToText(
  msgID: _messageList[0].msgID ?? "",
  language: "zh", // Default use Chinese
  );
  _addLog('Voice to textsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Voice to textfailed: $e');
  }
  }

  // Pin group message
  Future<void> _pinGroupMessage() async {
  if (_messageList.isEmpty) {
  _addLog('Please get message history first');
  return;
  }
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().pinGroupMessage(
  msgID: _messageList[0].msgID ?? "",
  groupID: _groupIDController.text,
  isPinned: true, // Default pinned
  );
  _addLog('Pin group message: ${result.toJson()}');
  } catch (e) {
  _addLog('Pin group messagefailed: $e');
  }
  }

  // Get pinned group message list
  Future<void> _getPinnedGroupMessageList() async {
  if (_groupIDController.text.isEmpty) {
  _addLog('Please enterGroupID');
  return;
  }
  try {
  final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getPinnedGroupMessageList(
  groupID: _groupIDController.text,
  );
  _addLog('Get pinned group message listsuccess: ${result.toJson()}');
  } catch (e) {
  _addLog('Get pinned group message listfailed: $e');
  }
  }

  @override
  Widget build(BuildContext context) {
  final inputFields = [
  // ReceiverIDandGroupIDInput box
  Row(
  children: [
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
  hintText: 'Please enterReceiverID',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
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
  const Text('GroupID:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _groupIDController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterGroupID',
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

  // Message contentandMessageIDInput box
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Message content:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _messageContentController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterMessage content',
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

  // Custom dataandConversationIDInput box
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Custom data:', style: TextStyle(fontSize: 12)),
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
  const SizedBox(width: 8),
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('ConversationID:', style: TextStyle(fontSize: 12)),
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
  ),
  ],
  ),
  const SizedBox(height: 4),

  // Emoji indexandEmoji dataInput box
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Emoji index:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _faceIndexController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterEmoji index',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
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
  const Text('Emoji data:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _faceDataController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterEmoji data',
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

  // Location descriptionandLongitudeInput box
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Location description:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _locationDescController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterLocation description',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
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
  const Text('Longitude:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _locationLongitudeController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterLongitude',
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

  // LatitudeandGet countInput box
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Latitude:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _locationLatitudeController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterLatitude',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
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
  const Text('Get count:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _countHistoryController,
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
  const SizedBox(height: 4),

  // Last sequence numberandMessage typeInput box
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Last sequence number:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _lastMsgSeqHistoryController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterLast message sequence number(Optional)',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
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
  const Text('Message type:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _messageTypeListHistoryController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterMessage typelist，Separated by commas(Optional)',
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

  // Sequence number listandStart timeInput box
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Sequence number list:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _messageSeqListHistoryController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterMessage sequence numberlist，Separated by commas(Optional)',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
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
  const Text('Start time:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _timeBeginHistoryController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterStart timetimestamp(Optional)',
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

  // Time rangeandVideo durationInput box
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Time range:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _timePeriodHistoryController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterTime range(Optional)',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
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
  const Text('Video duration:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _videoDurationController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterVideo duration(seconds)',
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

  // Voice durationandFile nameInput box
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Voice duration:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _soundDurationController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterVoice duration(seconds)',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
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
  const Text('File name:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _fileNameController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterFile name',
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

  // Local custom dataandLocal custom intInput box
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Local custom data:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _localCustomDataController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterLocal custom data',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
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
  const Text('Local custom int:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _localCustomIntController,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enterLocal custom int',
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

  // Message receive optiondropdown
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Message receive option:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: DropdownButtonFormField<ReceiveMsgOptEnum>(
  value: _receiveMessageOpt,
  decoration: const InputDecoration(
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
  items: ReceiveMsgOptEnum.values.map((ReceiveMsgOptEnum opt) {
  return DropdownMenuItem<ReceiveMsgOptEnum>(
  value: opt,
  child: Text(
  opt == ReceiveMsgOptEnum.V2TIM_RECEIVE_MESSAGE ? 'Receive messages' :
  opt == ReceiveMsgOptEnum.V2TIM_NOT_RECEIVE_MESSAGE ? 'Do not receive messages' :
  opt == ReceiveMsgOptEnum.V2TIM_RECEIVE_NOT_NOTIFY_MESSAGE ? 'Receive but no notification' :
  opt == ReceiveMsgOptEnum.V2TIM_RECEIVE_NOT_NOTIFY_MESSAGE_EXCEPT_AT ? 'Receive but no notification(except@Message)' :
  'Do not receive messages(except@Message)',
  style: const TextStyle(fontSize: 11),
  ),
  );
  }).toList(),
  onChanged: (ReceiveMsgOptEnum? newValue) {
  if (newValue != null) {
  setState(() {
  _receiveMessageOpt = newValue;
  });
  }
  },
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(height: 4),

  // Search text
  Row(
  children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text('Search text1:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _searchMessageController1,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enter',
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  border: OutlineInputBorder(),
  ),
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
  const Text('Search text2:', style: TextStyle(fontSize: 12)),
  SizedBox(
  height: 30,
  child: TextField(
  controller: _searchMessageController2,
  style: const TextStyle(fontSize: 13),
  decoration: const InputDecoration(
  hintText: 'Please enter',
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
  // Send message button
  _buildDynamicButton('SendText message', _sendTextMessage),
  _buildDynamicButton('SendCustom message', _sendCustomMessage),
  _buildDynamicButton('SendEmoji message', _sendFaceMessage),
  _buildDynamicButton('SendImage message', _sendImageMessage),
  _buildDynamicButton('SendVideo message', _sendVideoMessage),
  _buildDynamicButton('SendVoice message', _sendSoundMessage),
  _buildDynamicButton('SendFile message', _sendFileMessage),
  _buildDynamicButton('SendLocation message', _sendLocationMessage),
  _buildDynamicButton('SendMerged message', _sendMergerMessage),
  _buildDynamicButton('SendForwarded message', _sendForwardMessage),
  _buildDynamicButton('Send@Message', _sendTextAtMessage),
  _buildDynamicButton('Get group historical messages', _getGroupMessageHistory),
  _buildDynamicButton('Get private chat historical messages', _getC2CMessageHistory),
  _buildDynamicButton('RecallMessage', _revokeMessage),
  _buildDynamicButton('Download merged message', _downloadMergerMessage),
  _buildDynamicButton('SetC2CMessage receive option', _setC2CReceiveMessageOpt),
  _buildDynamicButton('GetC2CMessage receive option', _getC2CReceiveMessageOpt),
  _buildDynamicButton('Set group message receive option', _setGroupReceiveMessageOpt),
  _buildDynamicButton('Set global message receive option', _setAllReceiveMessageOpt),
  _buildDynamicButton('Set global message receive option(With timestamp)', _setAllReceiveMessageOptWithTimestamp),
  _buildDynamicButton('GetGlobal message receive option', _getAllReceiveMessageOpt),
  _buildDynamicButton('Set local custom data', _setLocalCustomData),
  _buildDynamicButton('Set local custom int', _setLocalCustomInt),
  _buildDynamicButton('MarkC2CMessage read', _markC2CMessageAsRead),
  _buildDynamicButton('Mark group messages as read', _markGroupMessageAsRead),
  _buildDynamicButton('Mark all messages as read', _markAllMessageAsRead),
  _buildDynamicButton('Delete from local storageMessage', _deleteMessageFromLocalStorage),
  _buildDynamicButton('DeleteMessage', _deleteMessages),
  _buildDynamicButton('Insert local group message', _insertGroupMessageToLocalStorage),
  _buildDynamicButton('Insert localC2CMessage', _insertC2CMessageToLocalStorage),
  _buildDynamicButton('Clear local and cloud messages of private chat', _clearC2CHistoryMessage),
  _buildDynamicButton('Clear local and cloud messages of group chat', _clearGroupHistoryMessage),
  _buildDynamicButton('SearchLocal message', _searchLocalMessages),
  _buildDynamicButton('SearchCloud message', _searchCloudMessages),
  _buildDynamicButton('Send message read receipt', _sendMessageReadReceipts),
  _buildDynamicButton('Get message read receipt', _getMessageReadReceipts),
  _buildDynamicButton('Get group message read member list', _getGroupMessageReadMemberList),
  _buildDynamicButton('QueryLocal message', _findMessages),
  _buildDynamicButton('Set message extension', _setMessageExtensions),
  _buildDynamicButton('Get message extension', _getMessageExtensions),
  _buildDynamicButton('DeleteMessage extension', _deleteMessageExtensions),
  _buildDynamicButton('Message change', _modifyMessage),
  _buildDynamicButton('Get multimedia messageURL', _getMessageOnlineUrl),
  _buildDynamicButton('Download multimedia message', _downloadMessage),
  _buildDynamicButton('AddMessage reaction', _addMessageReaction),
  _buildDynamicButton('RemoveMessage reaction', _removeMessageReaction),
  _buildDynamicButton('Get message reactions', _getMessageReactions),
  _buildDynamicButton('Get all user list of message reactions', _getAllUserListOfMessageReaction),
  _buildDynamicButton('Translate text', _translateText),
  _buildDynamicButton('Voice to text', _convertVoiceToText),
  _buildDynamicButton('Pin group message', _pinGroupMessage),
  _buildDynamicButton('Get pinned group message list', _getPinnedGroupMessageList),
  ];

  return BaseAPITest(
  title: 'Message management',
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
  _receiverIDController.dispose();
  _groupIDController.dispose();
  _messageContentController.dispose();
  _customDataController.dispose();
  _messageTypeController.dispose();
  _conversationIDController.dispose();
  _countHistoryController.dispose();
  _lastMsgIDHistoryController.dispose();
  _lastMsgSeqHistoryController.dispose();
  _messageTypeListHistoryController.dispose();
  _messageSeqListHistoryController.dispose();
  _timeBeginHistoryController.dispose();
  _timePeriodHistoryController.dispose();

  // Release newly added controllers
  _faceIndexController.dispose();
  _faceDataController.dispose();
  _locationDescController.dispose();
  _locationLongitudeController.dispose();
  _locationLatitudeController.dispose();

  // Release media message related controllers
  _videoDurationController.dispose();
  _soundDurationController.dispose();
  _fileNameController.dispose();

  // Release merged and forwarded message related controllers
  _mergerMsgIDListController.dispose();
  _forwardMsgIDListController.dispose();

  // Release@Message related controllers
  _atUserIDListController.dispose();
  _atTextController.dispose();

  // ReleaseLocal custom data and integer related controllers
  _localCustomDataController.dispose();
  _localCustomIntController.dispose();

  // Search text controller
  _searchMessageController1.dispose();
  _searchMessageController2.dispose();

  super.dispose();
  }
} 