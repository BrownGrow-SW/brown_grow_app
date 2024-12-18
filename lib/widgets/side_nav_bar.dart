import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brown_grow_app/models/user_model.dart';
import 'package:brown_grow_app/pages/home.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({Key? key}) : super(key: key);

  @override
  _SideNavBarState createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userName = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore using the UserModel
  void _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          UserModel userModel =
              UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

          setState(() {
            userName = userModel.name;
            userRole = userModel.role;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching user data: $e")),
        );
      }
    }
  }

  // Helper function to format the role string (e.g., "field_officer" -> "Field Officer")
  String formatRole(String role) {
    List<String> words = role.split('_');
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i].capitalizeFirstLetter();
    }
    return words.join(' ');
  }

  // Logout function
  void _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header section with user info
          UserAccountsDrawerHeader(
            accountName: Text(userName.isNotEmpty ? userName : 'Loading...'),
            accountEmail:
                Text(userRole.isNotEmpty ? formatRole(userRole) : 'Loading...'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          // Home menu item with role-based navigation
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              if (userRole == 'admin') {
                Navigator.pushNamed(context, '/admin_dashboard');
              } else if (userRole == 'field_officer') {
                Navigator.pushNamed(context, '/field_officer_dashboard');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No dashboard available for your role.'),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          // Logout item
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}

// Extension to capitalize the first letter of a string
extension StringCapitalization on String {
  String capitalizeFirstLetter() {
    if (this.isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
