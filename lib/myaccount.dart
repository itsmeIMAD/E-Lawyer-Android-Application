import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(height: 50),
          Positioned(
            top: 20,
            left: 5,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          Center(
            child: Text(
              'Email : ${user!.email.toString()}',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
