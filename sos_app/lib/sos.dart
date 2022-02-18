import 'package:auto_route/auto_route.dart';
import 'package:sos_app/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class SosPage extends StatelessWidget {

  const SosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      appBarBuilder: (_, tabsRouter) => AppBar(
        title: Text(tabsRouter.current.name),
        centerTitle: true,
        leading: const AutoBackButton(),
      ),
      routes: const [
        SOS(),
        Profile(),
        Activities(),
      ],

      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(

          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,

          items: [
            BottomNavigationBarItem(
              icon: Icon(FlutterRemix.alarm_warning_line),
              label: 'SOS',
              backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(FlutterRemix.profile_line),
              label: 'Profile',
              backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(FlutterRemix.folder_history_line),
              label: 'Logs',
              backgroundColor: Colors.blue
            ),
          ],
        );
      }
    );
  }
}