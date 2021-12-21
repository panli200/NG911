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

  List<EmergencySMS> messages = [
    EmergencySMS(messageContent: "911, What's the Emergency (Medical, Police, Fire)", messageType: "receiver"),
    EmergencySMS(messageContent: "Medical. A person slipped on ice and hurt her back", messageType: "sender"),
    EmergencySMS(messageContent: "Where are you and the person in need of an ambulance?", messageType: "receiver"),
    EmergencySMS(messageContent: "1234 Bugs Dr.", messageType: "sender"),
    EmergencySMS(messageContent: "Okay, help is on the way", messageType: "receiver"),
  ];

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
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: 
              Row(
                children: <Widget>[

                  SizedBox(width: 12,), // Spacing Visuals

                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      shape: BoxShape.circle
                    ),
                  ),

                  SizedBox(width: 12,), // Spacing Visuals

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Xyz Dispatcher",style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                        SizedBox(height: 6,),
                        Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                      ],
                    ),
                  ),

                  Icon(Icons.video_call_rounded, color: Colors.black54,),

                  SizedBox(width: 12,), // Spacing Visuals

                  Icon(Icons.phone, color: Colors.black54,),
                ],
              ),
          ),
        ),
      ),
      
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10,bottom: 10),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.blue[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(messages[index].messageContent!, style: TextStyle(fontSize: 15),),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){},
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}