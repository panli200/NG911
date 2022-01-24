import 'package:auto_route/auto_route.dart';
import 'package:sos_app/sos.dart';
import 'package:sos_app/sos_extended_pages/how_to_use_app_page.dart';
import 'package:sos_app/sos_extended_pages/call.dart';
import 'package:sos_app/sos_extended_pages/connect_psap_page.dart';
import 'package:sos_app/sos_extended_pages/sos_home_page.dart';
import 'package:sos_app/activities_extended_pages/activities.dart';
import 'package:sos_app/activities_extended_pages/activity_detail.dart';
import 'package:sos_app/profile_extended_pages/profile.dart';
import 'package:sos_app/Initial.dart';
import 'package:sos_app/SignUp.dart';


@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [

    AutoRoute(page: EmptyRouterPage, initial: true,
        children: [
          AutoRoute(
            path: '',
            page: InitializerWidgetPage,
          ),
          AutoRoute(
            path: '',
            page: SignUpPage,
          ),
          AutoRoute(
              path: '',
              name: "HomeRouter",
              page: SosPage,
              children: [
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
                      path: ':howToUseID',
                      page: HowToUsePage,  // FUTURE EXTENDED/POP-UP PAGES FOR SOS PAGE
                    ),
                    AutoRoute(
                      path: '',
                      page: CallPage,  // FUTURE EXTENDED/POP-UP PAGES FOR SOS PAGE
                    ),
                    AutoRoute(
                      path: ':connectPsapPageID',
                      page: ConnectPsapPage,  // FUTURE EXTENDED/POP-UP PAGES FOR SOS PAGE
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
                  path: 'activities_extended_pages',
                  name: 'ActivitiesRouter',
                  page: EmptyRouterPage,

                  // FUTURE EXTENDED/POP-UP PAGES FOR Activities PAGE
                  children: [
                    AutoRoute(
                      path: '',
                      page: ActivitiesPage,
                    ),
                    AutoRoute(
                      path: '',
                      page: ActivityDetailPage,
                    ),
                  ],
                )
              ]
          ),

        ]),
  ],
)
class $AppRouter {}