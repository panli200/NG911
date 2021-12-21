import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/data/application_data.dart';
import 'package:sos_app/widgets.dart';
import 'package:sos_app/routes/router.gr.dart';

class ConnectPsapPage extends StatefulWidget {
  final int connectPsapPageID;

  ConnectPsapPage({
    Key? key,
    @PathParam() required this.connectPsapPageID,
  }) : super(key: key);

  @override
  _ConnectPsapPageState createState() => _ConnectPsapPageState();
}

class _ConnectPsapPageState extends State<ConnectPsapPage> {

  TextEditingController textFieldController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();

  bool isWriting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    sendMessage() {
      var text = textFieldController.text;

      textFieldController.text = "";
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: textFieldFocus,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: Color(0xff272c35),
                  ),
                ),

                isWriting
                  ? Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 15,
                        ),
                      onPressed: () => sendMessage(),
                  ))
                : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }
}