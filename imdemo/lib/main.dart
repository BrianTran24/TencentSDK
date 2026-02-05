// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk_example/pages/api_test_page.dart';
import 'package:tencent_cloud_chat_sdk_example/utils/log_manager.dart';
import 'package:tencent_cloud_chat_sdk_example/utils/listener_manager.dart';

void main() {
  // Pre-initialize global listener manager
  final listenerManager = ListenerManager();
  listenerManager.initialize();
  
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => LogManager()),
      Provider<ListenerManager>.value(value: listenerManager),
    ], child: const MaterialApp(home: APITestPage())),
  );
}

