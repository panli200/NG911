import 'package:flutter/material.dart';

class HowToUseButton extends StatelessWidget {
  final Color tileColor;
  final String pageTitle;
  final void Function() onTileTap;

  const HowToUseButton ({
    Key? key,
    required this.tileColor,
    required this.pageTitle,
    required this.onTileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTileTap,
      child: Container( 
        child:
          Image.asset("assets/images/HowToUsePlaceholder.png",
            height: 40,
            width: 40,
          ),
      )
    );
  }
}

class MedicalScenarioButton extends StatelessWidget {
  final Color tileColor;
  final String pageTitle;
  final void Function() onTileTap;

  const MedicalScenarioButton ({
    Key? key,
    required this.tileColor,
    required this.pageTitle,
    required this.onTileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTileTap,
      child: Container( 
          height: 50,
          width: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          color: Colors.grey,
          child: Text('Medical Emergency Call')
      )
    );
  }
}

class ConnectPsapUI extends StatelessWidget implements PreferredSizeWidget{

  final Widget? title;
  final List<Widget>? actions;
  final bool? centerTitle;

  const ConnectPsapUI({
    Key? key,
    @required this.title,
    @required this.actions,
    //@required this.leading, 
    @required this.centerTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: Color(0xff272c35),
            width: 1.4,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        //leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight+10);
}