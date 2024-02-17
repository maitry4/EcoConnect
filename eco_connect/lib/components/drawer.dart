import 'package:eco_connect/components/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;

  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut,
    });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Header
              const DrawerHeader(
                child: Icon(Icons.person,
                color:Colors.white,
                size: 64,
                ),
              ),

              // Home
              MyListTile(
                icon: Icons.home,
                text: "H O M E",
                onTap: () => Navigator.pop(context)
              ),

              // Profile
              MyListTile(
                icon: Icons.person,
                text: "P R O F I L E",
                onTap: onProfileTap,
              ),
                ],
          ),

          // Logout
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.logout,
              text: "L O G O U T",
              onTap: onSignOut,
            ),
          ),


        ]
        ),
    );
  }
}