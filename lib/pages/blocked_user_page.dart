import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BlockedUserPage extends StatelessWidget {
  BlockedUserPage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // show unlock box
  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Unlock User"),
              content: const Text("Are you sure you want to unlock this user?"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text("Unblock"),
                  onPressed: () {
                    _chatService.unblockUser(userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User unblocked successfully"),
                      ),
                    );
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    String userId = _authService.getCurrentUser()!.uid;

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text("BLOCKED USERS"),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.grey,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.primary,
            )),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _chatService.getBlockedUsersStream(userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final blockedUsers = snapshot.data ?? [];

            if (blockedUsers.isEmpty) {
              return const Center(child: Text("No blocked users"));
            }

            return ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                final user = blockedUsers[index];
                return UserTile(
                  text: user["email"],
                  onTap: () => _showUnblockBox(context, user["uid"]),
                );
              },
            );
          },
        ));
  }
}
