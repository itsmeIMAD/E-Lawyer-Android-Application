import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Doc extends StatefulWidget {
  @override
  _DocState createState() => _DocState();
}

class _DocState extends State<Doc> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Attachments'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(child: Text('Firebase Init Error'));
          }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Flexible(
                    child: _buildBody(context),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey,
          onPressed: _takeImage,
          child: Icon(Icons.upload)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<firebase_storage.ListResult>(
      stream: Stream.fromFuture(
          firebase_storage.FirebaseStorage.instance.ref('images').listAll()),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!.items.isEmpty)
            return Text(
              " Add an  attachment",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            );
          return _buildList(context, snapshot.data!);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildList(
      BuildContext context, firebase_storage.ListResult snapshot) {
    return ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.items
            .map((data) => _buildListItem(context, data))
            .toList());
  }

  Widget _buildListItem(BuildContext context, firebase_storage.Reference data) {
    return FutureBuilder(
        future: data.getDownloadURL(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) return Container();
          return Padding(
            key: ValueKey(data.name),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ListTile(
                title: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => View(url: snapshot.data!)));
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            IconButton(
                                color: Colors.grey,
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Do you want to delete this image?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "No",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )),
                                            TextButton(
                                                onPressed: () async {
                                                  await firebase_storage
                                                      .FirebaseStorage.instance
                                                      .ref(data.fullPath)
                                                      .delete();
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                child: Text("Yes"))
                                          ],
                                        );
                                      });
                                }),
                          ],
                        ),
                      ),
                      Image.network(snapshot.data!),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future _takeImage() async {
    // Get image from gallery.
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final File imageFile = File(pickedFile!.path);
    _uploadImageToFirebase(imageFile);
  }

  Future<void> _uploadImageToFirebase(File imageFile) async {
    try {
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      String imageLocation = 'images/image$randomNumber.jpg';

      // Upload image to firebase.
      await firebase_storage.FirebaseStorage.instance
          .ref(imageLocation)
          .putFile(imageFile);
      setState(() {});
    } on FirebaseException catch (e) {
      print(e.code);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.code),
            );
          });
    } catch (e) {
      print(e);
    }
  }
}

class View extends StatelessWidget {
  final url;
  View({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Positioned(
          top: 20,
          left: 5,
          child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        SizedBox(height: 10),
        Align(
          alignment: Alignment.bottomCenter,
          child: Hero(
            tag: url,
            child: Image.network(
              url,
              height: 570,
              width: 700,
            ),
          ),
        ),
      ]),
    );
  }
}
