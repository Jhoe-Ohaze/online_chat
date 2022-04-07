import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/Backend/database.dart';
import 'package:online_chat/Backend/user_auth.dart';

import 'Widgets/Composer/message_composer.dart';
import 'Widgets/Messages/message_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        UserAuth.currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Simple Online Chat'),
        actions: [
          UserAuth.currentUser != null
              ? IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Logging Out'),
                                SizedBox(height: 20.0),
                                CircularProgressIndicator(),
                                SizedBox(height: 10.0)
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    await UserAuth.logOut();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: Container(
        color: Database.colorScheme.primary.withOpacity(0.1),
        child: (UserAuth.currentUser == null
            ? Center(
                child: ElevatedButton(
                  child: const Text('Sign In with Google'),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Logging In'),
                                SizedBox(height: 20.0),
                                CircularProgressIndicator(),
                                SizedBox(height: 10.0)
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    await UserAuth.logInWithGoogle();
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.of(context).pop();
                  },
                ),
              )
            : Column(
                children: const <Widget>[
                  Expanded(child: MessageList()),
                  SizedBox(height: 5),
                  MessageComposer(),
                ],
              )),
      ),
    );
  }
}
