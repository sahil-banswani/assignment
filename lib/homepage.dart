import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:sample_project/api_services.dart';
import 'package:sample_project/model.dart';
import 'package:sample_project/saved_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<User>> _usersFuture;
  final _selectedUsers = <User>{};

  void initState() {
    super.initState();
    _usersFuture = ApiService().fetchData();
    _loadSelectedUsers(); // Retrieve saved data initially
  }

  _loadSelectedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserIds = prefs.getStringList('selectedUserIds') ?? [];
    final savedUsers = _usersFuture.then(
        (users) => users.where((user) => savedUserIds.contains(user.name)));
    // setState(() {
    //   _selectedUsers.addAll(savedUsers);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton.outlined(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SavedUsersScreen()));
              },
              icon: const Icon(Iconsax.save_add))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          final selectedUserIds = _selectedUsers
              .map((user) => user.name)
              .toList(); // Assuming a unique ID for each user
          prefs.setStringList('selectedUserIds', selectedUserIds);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected users saved!')),
          );
        },
        child: const Icon(Icons.save),
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: Checkbox(
                    value: _selectedUsers.contains(user),
                    onChanged: (selected) {
                      setState(() {
                        if (selected!) {
                          _selectedUsers.add(user);
                        } else {
                          _selectedUsers.remove(user);
                        }
                      });
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
