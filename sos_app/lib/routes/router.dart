import 'package:auto_route/auto_route.dart';
import 'package:sos_app/sos.dart';
import 'package:sos_app/sos_extended_pages/how_to_use_app_page.dart';
import 'package:sos_app/sos_extended_pages/in_call_page.dart';
import 'package:sos_app/sos_extended_pages/sos_home_page.dart';
import 'package:sos_app/activities.dart';
import 'package:sos_app/profile_extended_pages/profile.dart';


@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(path: '/', page: SosPage, children: [
      AutoRoute(
        path: 'sos_extended_pages',
        name: 'SosRouter',
        page: EmptyRouterPage,
        
        // FUTURE PAGE ROUTING FOR SOS PAGE
        children: [
          AutoRoute(
            path: '',
            page: SosHomePage,  // FUTURE EXTENDED/POP-UP PAGES FOR SOS PAGE
          ),
          AutoRoute(
            path: '',
            page: HowToUsePage,  // FUTURE EXTENDED/POP-UP PAGES FOR SOS PAGE
          ),
          AutoRoute(
            path: '',
            page: InCallPage,  // FUTURE EXTENDED/POP-UP PAGES FOR SOS PAGE
          )
        ],
      ),
      AutoRoute(
        path: 'profile_extended_pages',
        name: 'ProfileRouter',
        page: EmptyRouterPage,

         // FUTURE EXTENDED/POP-UP PAGES FOR PROFILE PAGE
        children: [
          AutoRoute(
            path: '',
            page: ProfilePage,
          ),
        ],
        
      ),
      AutoRoute(
        path: 'activities',
        name: 'ActivitiesRouter',
        page: ActivitiesPage,
      )
    ]),
  ],
)
class $AppRouter {}