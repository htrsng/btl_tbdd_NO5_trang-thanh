import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'User';
  int _age = 25;
  bool _darkMode = false;
  String _gender = 'Nữ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile info
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.green,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(labelText: 'Tên'),
            onChanged: (val) => setState(() => _name = val),
            controller: TextEditingController(text: _name),
          ),
          ListTile(
            title: const Text('Tuổi'),
            trailing: Text('$_age'),
            onTap: () => _showAgePicker(),
          ),
          ListTile(
            title: const Text('Giới tính'),
            trailing: Text(_gender),
            onTap: () => _showGenderDialog(),
          ),
          const Divider(),
          // Settings
          SwitchListTile(
            title: const Text('Chế độ tối'),
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
          ),
          ListTile(
            title: const Text('Đánh giá app'),
            leading: const Icon(Icons.star),
            onTap: () => print('Mở store review'),
          ),
          ListTile(
            title: const Text('Đăng xuất'),
            leading: const Icon(Icons.logout),
            onTap: () => print('Logout'),
          ),
        ],
      ),
    );
  }

  void _showAgePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tuổi'),
        content: TextField(
          keyboardType: TextInputType.number,
          onChanged: (val) => setState(() => _age = int.tryParse(val) ?? _age),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showGenderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Giới tính'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Nam', 'Nữ', 'Khác']
              .map(
                (g) => RadioListTile<String>(
                  title: Text(g),
                  value: g,
                  groupValue: _gender,
                  onChanged: (val) {
                    setState(() => _gender = val ?? '');
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
