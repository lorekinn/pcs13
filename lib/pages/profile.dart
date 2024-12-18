import 'package:app1/components/auth_service.dart';
import 'package:flutter/material.dart';
import 'chat_list_page.dart';
import 'edit_profile_page.dart';
import 'orderhistorypage.dart';
import 'chat_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _fullName = 'Mikhaylov Denis';
  String _phone = '+7 123 456 7890';
  String _avatarUrl = 'https://via.placeholder.com/150';

  final authService = AuthService();

  void logout() async {
    await authService.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _editProfile(String fullName, String phone, String avatarUrl) {
    setState(() {
      _fullName = fullName;
      _phone = phone;
      _avatarUrl = avatarUrl;
    });
  }

  void _onMenuSelected(String value) {
    if (value == 'edit') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfilePage(
            fullName: _fullName,
            phone: _phone,
            avatarUrl: _avatarUrl,
            onSave: _editProfile,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();
    final currentUserUid = authService.getCurrentUserUid();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Профиль',
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onSelected: _onMenuSelected,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Редактировать профиль'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(_avatarUrl),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fullName,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currentEmail.toString(),
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _phone,
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderHistoryPage(),
                    ),
                  );
                },
                child: const Text('История заказов'),
              ),
              if (currentUserUid == "qSVrgQjZaXfxRTRu5ksjmtMX6oH2")
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatListPage(sellerUid: "qSVrgQjZaXfxRTRu5ksjmtMX6oH2"),
                      ),
                    );
                  },
                  child: const Text('Мои чаты'),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatPage(sellerUid: "qSVrgQjZaXfxRTRu5ksjmtMX6oH2"),
                      ),
                    );
                  },
                  child: const Text('Чат с продавцом'),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Выйти',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
