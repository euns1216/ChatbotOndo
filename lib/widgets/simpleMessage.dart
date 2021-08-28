import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SimpleMessage extends StatelessWidget {
  SimpleMessage({required this.text, required this.name, required this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          child: Icon(Icons.android),
          backgroundColor: Colors.transparent,
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                child: Text(text, style: TextStyle(color: Colors.black),),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                child: Text(text, style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(child: Text(this.name[0])),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}