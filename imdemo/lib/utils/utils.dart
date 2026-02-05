import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message.dart';

class Utils {
  static String getMessageContent(V2TimMessage message) {
    String m = "";
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
      m = "text ${message.textElem?.text}";
    }
    // Handle custom message
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
      m = "custom ${message.customElem?.data}";
    }
    // Handle image message
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
      m = "image ${message.imageElem?.path}";
    }
    // Handle video message
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
      m = "video ${message.videoElem?.videoPath}";
    }
    // Handle audio message
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND) {
      m = "sound ${message.soundElem?.url}";
    }
    // Handle file message
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_FILE) {
      m = "file ${message.fileElem?.url}";
    }
    // Handle location message
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_LOCATION) {
      m = "location";
    }
    // Handle face message
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_FACE) {
      m = "face";
    }
    // Handle group tips message
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS) {
      m = "group tips";
    }
    // Handle merger message
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_MERGER) {
      m = "merger";
    }
    return m;
  }
}
