import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sign_in/screens/emailpage.dart';
import 'package:url_launcher/url_launcher.dart';

class Communication extends StatefulWidget {
  @override
  _CommunicationState createState() => _CommunicationState();
}

class _CommunicationState extends State<Communication> {
  Future<Void> _makePhonecall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw ("Couldn't lanch $url");
    }
    throw ("$url launched");
  }

  _launchURL() async {
    const url =
        'https://www.mahakim.ma/Ar/Services/SuiviAffaires_new/TPI/?Page=ServicesElectronique&TypJur=TPI';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not Launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("    Inbox"),
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.perm_phone_msg,
                color: Colors.white,
              ))
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0.8, 0.8),
            child: FloatingActionButton(
              backgroundColor: Colors.grey,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Email()));
              },
              child: Icon(Icons.mail),
            ),
          ),
          Align(
            alignment: Alignment(0.8, 0.4),
            child: FloatingActionButton(
              backgroundColor: Colors.grey,
              onPressed: () => setState(() {
                _makePhonecall('tel:');
              }),
              child: Icon(Icons.call),
            ),
          ),
          Align(
            alignment: Alignment(0.8, 0.0),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.grey,
              label: Text(
                "mahakim.ma",
                style: TextStyle(color: Colors.amber),
              ),
              onPressed: () {
                _launchURL();
              },
              icon: Icon(Icons.open_in_browser),
            ),
          ),
        ],
      ),
    );
  }
}
