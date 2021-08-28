import './widgets/carouselSelect.dart';
import './widgets/basic_card.dart';
import './widgets/simpleMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class GoogleAssistant extends StatefulWidget {
  GoogleAssistant({Key? key}) : super(key: key);

  @override
  _GoogleAssistant createState() => new _GoogleAssistant();
}

class _GoogleAssistant extends State<GoogleAssistant> {
  final List<dynamic> _messages = <dynamic>[];
  final TextEditingController _textController = TextEditingController();
  late BuildContext buildContext;
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send,color: Colors.blue,),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  dynamic getWidgetMessage(message) {
    TypeMessage ms = TypeMessage(message);
    if (ms.platform == "ACTIONS_ON_GOOGLE") {
      if (ms.type == "simpleResponses") {
        return new SimpleMessage(
          text: message['simpleResponses']['simpleResponses'][0]
          ['textToSpeech'],
          name: "Ondo",
          type: false,
        );
      }
      if (ms.type == "basicCard") {
        return BasicCardWidget(card: new BasicCardDialogflow(message));
      }
      if (ms.type == "carouselSelect") {
        return new CarouselSelectWidget(
            carouselSelect: CarouselSelect(message),
            clickItem: (info) {
              print(info); // Item Click print List Keys
            });
      }
    }
    return null;
  }

  void response(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
    await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow =
    Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    if (response.getMessage() != null && response.getMessage() != "") {
      SimpleMessage message = new SimpleMessage(
        text: response.getMessage(),
        name: "Ondo",
        type: false,
      );
      setState(() {
        _messages.insert(0, message);
      });
    } else {
      List<dynamic> messages = response.getListMessage();
      for (var i = 0; i < messages.length; i++) {
        dynamic message = getWidgetMessage(messages[i]);
        if (message != null) {
          setState(() {
            _messages.insert(0, message);
          });
        }
      }
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    SimpleMessage message = new SimpleMessage(
      text: text,
      name: "Me",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    response(text);
  }

  @override
  Widget build(BuildContext context) {
    this.buildContext=context;
    return Scaffold(
      backgroundColor: Color(0xf4f4f4f4f4),
      appBar: AppBar(
        title: Text("Ondo"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )),
        Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}