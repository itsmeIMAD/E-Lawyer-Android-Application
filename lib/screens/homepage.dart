import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/menu_item.dart';
import '/menudrawer.dart';
import 'docpage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController refController = TextEditingController();
  TextEditingController clientController = TextEditingController();
  TextEditingController oppController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController courtController = TextEditingController();
  TextEditingController judgeController = TextEditingController();
  TextEditingController factsController = TextEditingController();

  _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: label, hintStyle: TextStyle(color: Colors.grey)),
    );
  }

  updatecase(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Cases").doc(item);
    Map<String, dynamic> cases = {
      "ref": refController.text,
      "clientName": clientController.text,
      "oppName": oppController.text,
      "type": typeController.text,
      "status": statusController.text,
      "court": courtController.text,
      "judge": judgeController.text,
      "facts": factsController.text,
    };
    documentReference.update(cases).whenComplete(() {
      print("$refController updated");
    });
  }

  createcase() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Cases").doc(refController.text);
    Map<String, String> cases = {
      "ref": refController.text,
      "clientName": clientController.text,
      "oppName": oppController.text,
      "type": typeController.text,
      "status": statusController.text,
      "court": courtController.text,
      "judge": judgeController.text,
      "facts": factsController.text,
    };
    documentReference.set(cases).whenComplete(() {
      print("$refController created");
    });
  }

  deletecase(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Cases").doc(item);

    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }

  N(DocumentSnapshot acase) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailPage(acase: acase)));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: NavigationDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.0),
          child: AppBar(
            backgroundColor: Colors.grey,
            title: Center(
              child: Container(
                width: 2000,
                margin: new EdgeInsets.only(top: 7.0),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29.5),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: TextField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey))),
              ),
            ),
            actions: <Widget>[
              PopupMenuButton<String>(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return Constants.choices.map((String choice) {
                      return PopupMenuItem<String>(
                          value: choice, child: Text(choice));
                    }).toList();
                  })
            ],
          ),
        ),
        body: Stack(children: <Widget>[
          Container(
            height: size.height * .80,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Cases")
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshots.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot documentSnapshot =
                                  snapshots.data!.docs[index];
                              return Dismissible(
                                key: UniqueKey(),
                                background: buildSwipeLeft(),
                                secondaryBackground: buildSwipeRight(),
                                onDismissed: (direction) {
                                  switch (direction) {
                                    case DismissDirection.endToStart:
                                      setState(() {
                                        deletecase(documentSnapshot["ref"]);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(new SnackBar(
                                                content:
                                                    new Text("Case deleted")));
                                      });
                                      break;
                                    case DismissDirection.startToEnd:
                                      refController.text =
                                          documentSnapshot["ref"];
                                      clientController.text =
                                          documentSnapshot["clientName"];
                                      oppController.text =
                                          documentSnapshot["oppName"];
                                      typeController.text =
                                          documentSnapshot["type"];
                                      statusController.text =
                                          documentSnapshot["status"];
                                      courtController.text =
                                          documentSnapshot["court"];
                                      judgeController.text =
                                          documentSnapshot["judge"];
                                      factsController.text =
                                          documentSnapshot["facts"];

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              title: Text("Update this case"),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    _buildTextField(
                                                        refController,
                                                        'Case reference'),
                                                    _buildTextField(
                                                        clientController,
                                                        'Client fullname'),
                                                    _buildTextField(
                                                        oppController,
                                                        'Opposant fullname'),
                                                    _buildTextField(
                                                        typeController, 'Type'),
                                                    _buildTextField(
                                                        statusController,
                                                        'Status'),
                                                    _buildTextField(
                                                        courtController,
                                                        'Court'),
                                                    _buildTextField(
                                                        judgeController,
                                                        'Judge'),
                                                    _buildTextField(
                                                        factsController,
                                                        'Facts'),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        updatecase(
                                                            documentSnapshot[
                                                                "ref"]);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(new SnackBar(
                                                                content: new Text(
                                                                    "Case updated")));
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("update"))
                                              ],
                                            );
                                          });
                                      break;

                                    default:
                                      break;
                                  }
                                },
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.all(8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: ListTile(
                                    title: Text(
                                        "Ref Case : ${documentSnapshot["ref"]}"),
                                    subtitle: Text(
                                        "Client Name : ${documentSnapshot["clientName"]}"),
                                    trailing: Icon(
                                      Icons.folder,
                                      color: Colors.amber,
                                    ),
                                    onTap: () => N(documentSnapshot),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )),
                ],
              ),
            ),
          ),
        ]));
  }

  Widget buildSwipeLeft() => Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.amber,
        child: Icon(
          Icons.update,
          color: Colors.white,
          size: 25,
        ),
      );
  Widget buildSwipeRight() => Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.amber,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 25,
        ),
      );

  choiceAction(String choice) {
    if (choice == Constants.settings) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text("Add a case"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(refController, 'Case reference'),
                    _buildTextField(clientController, 'Client fullname'),
                    _buildTextField(oppController, 'Opposant fullname'),
                    _buildTextField(typeController, 'Type'),
                    _buildTextField(statusController, 'Status'),
                    _buildTextField(courtController, 'Court'),
                    _buildTextField(judgeController, 'Judge'),
                    _buildTextField(factsController, 'Facts'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      createcase();

                      Navigator.of(context).pop();
                    },
                    child: Text("Add"))
              ],
            );
          });
    }
  }
}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot acase;
  DetailPage({required this.acase});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            left: 5,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          Positioned(
              top: 70,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.acase["clientName"],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ],
              )),
          Positioned(
              top: 110,
              left: 22,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.acase["ref"],
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              )),
          Positioned(
            bottom: 0,
            child: Container(
                width: width,
                height: height * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Opposant:',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.acase["oppName"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Type:',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.acase["type"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Status:',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.acase["status"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Court:',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.acase["court"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Judge:',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.acase["judge"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Facts:',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.acase["facts"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: openDoc,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 100,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              color: Colors.grey),
                          child: Text(
                            "Documents",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ]),
                )),
          ),
        ],
      ),
    );
  }

  void openDoc() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Doc()));
  }
}
