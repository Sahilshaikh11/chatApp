import 'package:chat_app/services/chat/chat_services.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
  });

  // show options
  void _showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            children: [
              //report button
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  _reportMessage(context, messageId, userId);
                },
              ),

              // block button
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block'),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context, userId);
                },
              ),

              // cancel button
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ));
        });
  }

  // report message
  void _reportMessage(BuildContext context, String messageId, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Report Message'),
              content:
                  const Text('Are you sure you want to report this message?'),
              actions: [
                TextButton(
                  onPressed: () {
                    // cancel message
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // report message
                    ChatService().reportUser(messageId, userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Message reported successfully!'),
                      ),
                    );
                  },
                  child: const Text('Report'),
                ),
              ],
            ));
  }

  // block user
  void _blockUser(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Block User'),
              content:
                  const Text('Are you sure you want to block this message?'),
              actions: [
                TextButton(
                  onPressed: () {
                    // cancel message
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // block
                    ChatService().blockUser(userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User Blocked successfully!'),
                      ),
                    );
                  },
                  child: const Text('Block'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // light vs dark mode for chat bubble
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          // show options
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser
              ? (isDarkMode ? Colors.green.shade800 : Colors.green.shade500)
              : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Text(
          message,
          style: TextStyle(
              color: isCurrentUser
                  ? Colors.white
                  : (isDarkMode ? Colors.white : Colors.black)),
        ),
      ),
    );
  }
}
