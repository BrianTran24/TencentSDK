import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk_example/utils/log_manager.dart';

// Common style constants
class APITestStyle {
  // Input field style constants
  static const double INPUT_HEIGHT = 30.0;           // Input field height
  static const double INPUT_FONT_SIZE = 13.0;        // Input field font size
  static const double INPUT_LABEL_FONT_SIZE = 12.0;  // Input field label font size
  static const EdgeInsets INPUT_PADDING = EdgeInsets.symmetric(horizontal: 8, vertical: 8); // Input field padding
  
  // Button style constants
  static const double BUTTON_HORIZONTAL_PADDING = 5.0;   // Button horizontal padding
  static const double BUTTON_VERTICAL_PADDING = 3.0;     // Button vertical padding
  static const double BUTTON_MIN_HEIGHT = 30.0;          // Button minimum height
  static const double BUTTON_FONT_SIZE = 12.0;           // Button font size
  static const double BUTTON_BORDER_RADIUS = 4.0;        // Button border radius
  static const double BUTTON_CHAR_WIDTH = 6.0;           // Estimated width per character
  static const double BUTTON_EXTRA_WIDTH = 12.0;         // Button extra width
  static const Color BUTTON_TEXT_COLOR = Colors.white;   // Button text color
  static const Color BUTTON_BG_COLOR = Colors.blue;      // Button background color
  
  // Layout constants
  static const double HORIZONTAL_SPACING = 8.0;         // Horizontal spacing
  static const double VERTICAL_SPACING = 4.0;           // Vertical spacing
  static const double LABEL_WIDTH = 80.0;               // Label width
  
  // Log area style constants
  static const double LOG_AREA_HEIGHT = 180.0;           // Log area height
  static const double LOG_LABEL_FONT_SIZE = 13.0;        // Log label font size
  static const double LOG_CONTENT_FONT_SIZE = 10.0;      // Log content font size
  static const Color LOG_LABEL_COLOR = Colors.black;     // Log label color
  static const Color LOG_CONTENT_COLOR = Colors.black54; // Log content color
  static const Color LOG_AREA_BG_COLOR = Color(0xFFE8F0F8); // Log area background color
}

// Common button component
class APITestButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? backgroundColor;
  final Color? textColor;

  const APITestButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonWidth = width ?? (text.length * APITestStyle.BUTTON_CHAR_WIDTH + APITestStyle.BUTTON_EXTRA_WIDTH);

    return Container(
      margin: const EdgeInsets.only(bottom: 1.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: APITestStyle.BUTTON_HORIZONTAL_PADDING,
            vertical: APITestStyle.BUTTON_VERTICAL_PADDING,
          ),
          minimumSize: Size(buttonWidth, height ?? APITestStyle.BUTTON_MIN_HEIGHT),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          textStyle: TextStyle(
            fontSize: fontSize ?? APITestStyle.BUTTON_FONT_SIZE,
          ),
          foregroundColor: textColor ?? APITestStyle.BUTTON_TEXT_COLOR,
          backgroundColor: backgroundColor ?? APITestStyle.BUTTON_BG_COLOR,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(APITestStyle.BUTTON_BORDER_RADIUS),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}

// Base API test page component
class BaseAPITest extends StatefulWidget {
  final String title;
  final List<Widget> inputFields;
  final List<Widget> buttons;
  final VoidCallback onClearLog;

  const BaseAPITest({
    Key? key,
    required this.title,
    required this.inputFields,
    required this.buttons,
    required this.onClearLog,
  }) : super(key: key);

  @override
  State<BaseAPITest> createState() => _BaseAPITestState();
}

class _BaseAPITestState extends State<BaseAPITest> {
  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen to LogManager changes
    return Consumer<LogManager>(
      builder: (context, logManager, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              TextButton(
                onPressed: widget.onClearLog,
                child: const Text('Clear log'),
              ),
            ],
          ),
          body: Column(
            children: [
              // 日志区域
              Container(
                height: APITestStyle.LOG_AREA_HEIGHT,
                color: APITestStyle.LOG_AREA_BG_COLOR,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Operation log: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: APITestStyle.LOG_LABEL_FONT_SIZE,
                                color: APITestStyle.LOG_LABEL_COLOR,
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                logManager.logText,
                                style: const TextStyle(
                                  fontSize: APITestStyle.LOG_CONTENT_FONT_SIZE,
                                  color: APITestStyle.LOG_CONTENT_COLOR,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 4),
                        Row(
                          children: [
                            const Text('SDK callback: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: APITestStyle.LOG_LABEL_FONT_SIZE,
                                color: APITestStyle.LOG_LABEL_COLOR,
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                logManager.timSDKLog,
                                style: const TextStyle(
                                  fontSize: APITestStyle.LOG_CONTENT_FONT_SIZE,
                                  color: APITestStyle.LOG_CONTENT_COLOR,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 4),
                        Row(
                          children: [
                            const Text('Simple message: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: APITestStyle.LOG_LABEL_FONT_SIZE,
                                color: APITestStyle.LOG_LABEL_COLOR,
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                logManager.simpleMsgLog,
                                style: const TextStyle(
                                  fontSize: APITestStyle.LOG_CONTENT_FONT_SIZE,
                                  color: APITestStyle.LOG_CONTENT_COLOR,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 4),
                        Row(
                          children: [
                            const Text('Advanced message: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: APITestStyle.LOG_LABEL_FONT_SIZE,
                                color: APITestStyle.LOG_LABEL_COLOR,
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                logManager.advMsgLog,
                                style: const TextStyle(
                                  fontSize: APITestStyle.LOG_CONTENT_FONT_SIZE,
                                  color: APITestStyle.LOG_CONTENT_COLOR,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 4),
                        Row(
                          children: [
                            const Text('Group callback: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: APITestStyle.LOG_LABEL_FONT_SIZE,
                                color: APITestStyle.LOG_LABEL_COLOR,
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                logManager.groupLog,
                                style: const TextStyle(
                                  fontSize: APITestStyle.LOG_CONTENT_FONT_SIZE,
                                  color: APITestStyle.LOG_CONTENT_COLOR,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 4),
                        Row(
                          children: [
                            const Text('Conversation callback: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: APITestStyle.LOG_LABEL_FONT_SIZE,
                                color: APITestStyle.LOG_LABEL_COLOR,
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                logManager.conversationLog,
                                style: const TextStyle(
                                  fontSize: APITestStyle.LOG_CONTENT_FONT_SIZE,
                                  color: APITestStyle.LOG_CONTENT_COLOR,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 4),
                        Row(
                          children: [
                            const Text('Friend callback: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: APITestStyle.LOG_LABEL_FONT_SIZE,
                                color: APITestStyle.LOG_LABEL_COLOR,
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                logManager.friendshipLog,
                                style: const TextStyle(
                                  fontSize: APITestStyle.LOG_CONTENT_FONT_SIZE,
                                  color: APITestStyle.LOG_CONTENT_COLOR,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 4),
                        Row(
                          children: [
                            const Text('Community callback: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: APITestStyle.LOG_LABEL_FONT_SIZE,
                                color: APITestStyle.LOG_LABEL_COLOR,
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                logManager.communityLog,
                                style: const TextStyle(
                                  fontSize: APITestStyle.LOG_CONTENT_FONT_SIZE,
                                  color: APITestStyle.LOG_CONTENT_COLOR,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Input and button area
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Input fields
                        ...widget.inputFields.map((field) => Padding(
                          padding: const EdgeInsets.only(bottom: APITestStyle.VERTICAL_SPACING),
                          child: field,
                        )).toList(),
                        
                        // Button area
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: APITestStyle.HORIZONTAL_SPACING,
                          runSpacing: APITestStyle.VERTICAL_SPACING,
                          children: widget.buttons,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 