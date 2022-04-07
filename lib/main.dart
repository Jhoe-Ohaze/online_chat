import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/Backend/database.dart';
import 'chat_page.dart';
import 'firebase_options.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const OnlineChat());
}

class OnlineChat extends StatelessWidget 
{
  const OnlineChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      title: 'Simple Online Chat',
      theme: Database.themeData,
      home: const ChatPage(),
    );
  }
}
