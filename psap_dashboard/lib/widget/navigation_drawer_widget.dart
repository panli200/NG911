import 'package:flutter/material.dart';
import 'package:psap_dashboard/login_page.dart';
import 'package:psap_dashboard/pages/maps_home_page.dart';
import 'package:psap_dashboard/pages/overview_home_page.dart';
import 'package:psap_dashboard/pages/settings_home_page.dart';
import 'package:psap_dashboard/pages/user_data_page.dart';
import 'package:flutter_remix/flutter_remix.dart';

class NavigationDrawerWidget extends StatefulWidget {
  final name;

  const NavigationDrawerWidget({Key? key, required this.name})
      : super(key: key);
  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  String uNAME = '';
  void getUSer() {
    setState(() {
      uNAME = widget.name;
    });
  }

  @override
  void initState() {
    getUSer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final name = uNAME;
    const email = '';
    const urlImage =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHHO-97UOCydLCAK9jpUBrpXyMqdp5JQnlgA&usqp=CAU';

    return Drawer(
      child: Material(
        color: Colors.blue,
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () {},
            ),

            const Divider(height: 5, thickness: 3, color: Colors.black12),
            
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Emergencies',
                    icon: FlutterRemix.alarm_warning_line,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Overview',
                    icon: FlutterRemix.bar_chart_box_line,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Settings',
                    icon: FlutterRemix.settings_3_line,
                    onClicked: () => selectedItem(context, 2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Divider(height: 5, thickness: 3, color: Colors.black12),

            const SizedBox(height: 16),

            Row
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> 
              [
                const Text('Log out ', style: TextStyle(color: Colors.white)),
                IconButton
                (
                  icon: const Icon(FlutterRemix.logout_box_line),
                  color: Colors.red,
                  splashColor: Colors.white,
                  onPressed: () 
                  {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
                  },
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MapsHomePage(name: uNAME),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OverviewHomePage(name: uNAME),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SettingsHomePage(name: uNAME),
        ));
        break;
    }
  }
}
