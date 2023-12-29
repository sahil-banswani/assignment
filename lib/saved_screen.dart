import 'package:flutter/material.dart';
import 'package:sample_project/api_services.dart';
import 'package:sample_project/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedUsersScreen extends StatefulWidget {
  const SavedUsersScreen({super.key});

  @override
  _SavedUsersScreenState createState() => _SavedUsersScreenState();
}

class _SavedUsersScreenState extends State<SavedUsersScreen> {
  Future<List<User>>? _savedUsersFuture ;

  @override
  void initState() {
    super.initState();
    _loadSavedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Users'),
      ),
      body: FutureBuilder<List<User>>(
        future: _savedUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  _loadSavedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserIds = prefs.getStringList('selectedUserIds') ?? [];
  }
}
