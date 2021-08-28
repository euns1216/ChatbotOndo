import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogflow/v2/message.dart';
import 'package:url_launcher/url_launcher.dart';

class BasicCardWidget extends StatelessWidget {
  BasicCardWidget({required this.card});

  final BasicCardDialogflow card;

  List<Widget> generateButton() {
    List<Widget> buttons = [];
    if(this.card.buttons == null) return buttons;
    for (var i = 0; i < this.card.buttons.length; i++) {
      print(this.card.buttons[i]);
      buttons.add(new SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              if(this.card.buttons[i]['openUriAction'] != null){
                openUri(this.card.buttons[i]['openUriAction']['uri']);
              }
            },
            child: Container(
              color: Colors.white,
              child: Text(this.card.buttons[i]['title'],
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          )
        )
      );
    }
    return buttons;
  }

  // add dependency url_launcher: ^6.0.9 in pubspec.yaml file
  void openUri(String _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Image.network(this.card.image.imageUri),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    this.card.title,
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    this.card.subtitle,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(this.card.formattedText),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: generateButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}