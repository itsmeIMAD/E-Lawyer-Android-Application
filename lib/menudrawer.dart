import 'package:flutter/material.dart';

import 'package:sign_in/authenticate/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'myaccount.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[300],
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 48,
            ),
            buildMenuItem(
                text: 'My account',
                icon: Icons.account_box,
                onClicked: () => selectedItem(context, 0)),
            SizedBox(
              height: 16,
            ),
            buildMenuItem(
                text: 'Logout',
                icon: Icons.logout,
                onClicked: () => selectedItem(context, 1))
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required String text,
      required IconData icon,
      required VoidCallback onClicked}) {
    final color = Colors.black;
    return ListTile(
      onTap: onClicked,
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyAccount(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SignIn(),
        ));
        setState(() async {
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Logged Out'),
            duration: const Duration(seconds: 2),
          ));
        });
        break;
    }
  }
}
