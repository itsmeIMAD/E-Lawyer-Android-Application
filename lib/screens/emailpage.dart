import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  final controllerTo = TextEditingController();
  final controllerSubject = TextEditingController();
  final controllerMessage = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("send an email"),
          centerTitle: true,
          backgroundColor: Colors.grey,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Image.asset('asset/image/gmailicon.png'))
          ],
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  buildTextField(title: 'To', controller: controllerTo),
                  const SizedBox(height: 20),
                  buildTextField(
                      title: 'Subject', controller: controllerSubject),
                  const SizedBox(height: 20),
                  buildTextField(
                      title: 'Message',
                      controller: controllerMessage,
                      maxLines: 8),
                  SizedBox(height: 60),
                  Align(
                    alignment: Alignment(0.8, 0.95),
                    child: FloatingActionButton(
                        backgroundColor: Colors.grey,
                        onPressed: () => launchEmail(
                              toEmail: controllerTo.text,
                              subject: controllerSubject.text,
                              message: controllerMessage.text,
                            ),
                        child: Icon(Icons.send)),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future launchEmail({
    required String toEmail,
    required String subject,
    required String message,
  }) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget buildTextField({
    required String title,
    required TextEditingController controller,
    int maxLines = 1,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLines: maxLines,
            controller: controller,
            decoration:
                InputDecoration(border: OutlineInputBorder(), hintText: title),
          )
        ],
      );
}
