// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i12;

import '../activities_extended_pages/activities.dart' as _i10;
import '../activities_extended_pages/activity_detail.dart' as _i11;
import '../Initial.dart' as _i2;
import '../profile_extended_pages/profile.dart' as _i9;
import '../SignUp.dart' as _i3;
import '../sos.dart' as _i4;
import '../sos_extended_pages/connect_psap_page.dart' as _i8;
import '../sos_extended_pages/emergency_call_popup_page.dart' as _i7;
import '../sos_extended_pages/how_to_use_app_page.dart' as _i6;
import '../sos_extended_pages/sos_home_page.dart' as _i5;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i12.GlobalKey<_i12.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    EmptyRouterRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.EmptyRouterPage());
    },
    InitializerWidgetRoute.name: (routeData) {
      final args = routeData.argsAs<InitializerWidgetRouteArgs>(
          orElse: () => const InitializerWidgetRouteArgs());
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.InitializerWidgetPage(key: args.key));
    },
    SignUpRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.SignUpPage());
    },
    HomeRouter.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.SosPage());
    },
    SosRouter.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.EmptyRouterPage());
    },
    ProfileRouter.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.EmptyRouterPage());
    },
    ActivitiesRouter.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.EmptyRouterPage());
    },
    SosHomeRoute.name: (routeData) {
      final args = routeData.argsAs<SosHomeRouteArgs>(
          orElse: () => const SosHomeRouteArgs());
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i5.SosHomePage(key: args.key));
    },
    HowToUseRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HowToUseRouteArgs>(
          orElse: () =>
              HowToUseRouteArgs(howToUseID: pathParams.getInt('howToUseID')));
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.HowToUsePage(key: args.key, howToUseID: args.howToUseID));
    },
    EmergencyCallPopUpRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EmergencyCallPopUpRouteArgs>(
          orElse: () => EmergencyCallPopUpRouteArgs(
              emergencyCallPopUpID: pathParams.getInt('emergencyCallPopUpID')));
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.EmergencyCallPopUpPage(
              key: args.key, emergencyCallPopUpID: args.emergencyCallPopUpID));
    },
    ConnectPsapRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ConnectPsapRouteArgs>(
          orElse: () => ConnectPsapRouteArgs(
              connectPsapPageID: pathParams.getInt('connectPsapPageID')));
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i8.ConnectPsapPage(
              key: args.key, connectPsapPageID: args.connectPsapPageID));
    },
    ProfileRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i9.ProfilePage());
    },
    ActivitiesRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i10.ActivitiesPage());
    },
    ActivityDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ActivityDetailRouteArgs>();
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData,
          child:
              _i11.ActivityDetailPage(key: args.key, Snapshot: args.Snapshot));
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(EmptyRouterRoute.name, path: '/', children: [
          _i1.RouteConfig(InitializerWidgetRoute.name,
              path: '', parent: EmptyRouterRoute.name),
          _i1.RouteConfig(SignUpRoute.name,
              path: '', parent: EmptyRouterRoute.name),
          _i1.RouteConfig(HomeRouter.name,
              path: '',
              parent: EmptyRouterRoute.name,
              children: [
                _i1.RouteConfig(SosRouter.name,
                    path: 'sos_extended_pages',
                    parent: HomeRouter.name,
                    children: [
                      _i1.RouteConfig(SosHomeRoute.name,
                          path: '', parent: SosRouter.name),
                      _i1.RouteConfig(HowToUseRoute.name,
                          path: ':howToUseID', parent: SosRouter.name),
                      _i1.RouteConfig(EmergencyCallPopUpRoute.name,
                          path: ':emergencyCallPopUpID',
                          parent: SosRouter.name),
                      _i1.RouteConfig(ConnectPsapRoute.name,
                          path: ':connectPsapPageID', parent: SosRouter.name)
                    ]),
                _i1.RouteConfig(ProfileRouter.name,
                    path: 'profile_extended_pages',
                    parent: HomeRouter.name,
                    children: [
                      _i1.RouteConfig(ProfileRoute.name,
                          path: '', parent: ProfileRouter.name)
                    ]),
                _i1.RouteConfig(ActivitiesRouter.name,
                    path: 'activities_extended_pages',
                    parent: HomeRouter.name,
                    children: [
                      _i1.RouteConfig(ActivitiesRoute.name,
                          path: '', parent: ActivitiesRouter.name),
                      _i1.RouteConfig(ActivityDetailRoute.name,
                          path: '', parent: ActivitiesRouter.name)
                    ])
              ])
        ])
      ];
}

/// generated route for [_i1.EmptyRouterPage]
class EmptyRouterRoute extends _i1.PageRouteInfo<void> {
  const EmptyRouterRoute({List<_i1.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'EmptyRouterRoute';
}

/// generated route for [_i2.InitializerWidgetPage]
class InitializerWidgetRoute
    extends _i1.PageRouteInfo<InitializerWidgetRouteArgs> {
  InitializerWidgetRoute({_i12.Key? key})
      : super(name, path: '', args: InitializerWidgetRouteArgs(key: key));

  static const String name = 'InitializerWidgetRoute';
}

class InitializerWidgetRouteArgs {
  const InitializerWidgetRouteArgs({this.key});

  final _i12.Key? key;

  @override
  String toString() {
    return 'InitializerWidgetRouteArgs{key: $key}';
  }
}

/// generated route for [_i3.SignUpPage]
class SignUpRoute extends _i1.PageRouteInfo<void> {
  const SignUpRoute() : super(name, path: '');

  static const String name = 'SignUpRoute';
}

/// generated route for [_i4.SosPage]
class HomeRouter extends _i1.PageRouteInfo<void> {
  const HomeRouter({List<_i1.PageRouteInfo>? children})
      : super(name, path: '', initialChildren: children);

  static const String name = 'HomeRouter';
}

/// generated route for [_i1.EmptyRouterPage]
class SosRouter extends _i1.PageRouteInfo<void> {
  const SosRouter({List<_i1.PageRouteInfo>? children})
      : super(name, path: 'sos_extended_pages', initialChildren: children);

  static const String name = 'SosRouter';
}

/// generated route for [_i1.EmptyRouterPage]
class ProfileRouter extends _i1.PageRouteInfo<void> {
  const ProfileRouter({List<_i1.PageRouteInfo>? children})
      : super(name, path: 'profile_extended_pages', initialChildren: children);

  static const String name = 'ProfileRouter';
}

/// generated route for [_i1.EmptyRouterPage]
class ActivitiesRouter extends _i1.PageRouteInfo<void> {
  const ActivitiesRouter({List<_i1.PageRouteInfo>? children})
      : super(name,
            path: 'activities_extended_pages', initialChildren: children);

  static const String name = 'ActivitiesRouter';
}

/// generated route for [_i5.SosHomePage]
class SosHomeRoute extends _i1.PageRouteInfo<SosHomeRouteArgs> {
  SosHomeRoute({_i12.Key? key})
      : super(name, path: '', args: SosHomeRouteArgs(key: key));

  static const String name = 'SosHomeRoute';
}

class SosHomeRouteArgs {
  const SosHomeRouteArgs({this.key});

  final _i12.Key? key;

  @override
  String toString() {
    return 'SosHomeRouteArgs{key: $key}';
  }
}

/// generated route for [_i6.HowToUsePage]
class HowToUseRoute extends _i1.PageRouteInfo<HowToUseRouteArgs> {
  HowToUseRoute({_i12.Key? key, required int howToUseID})
      : super(name,
            path: ':howToUseID',
            args: HowToUseRouteArgs(key: key, howToUseID: howToUseID),
            rawPathParams: {'howToUseID': howToUseID});

  static const String name = 'HowToUseRoute';
}

class HowToUseRouteArgs {
  const HowToUseRouteArgs({this.key, required this.howToUseID});

  final _i12.Key? key;

  final int howToUseID;

  @override
  String toString() {
    return 'HowToUseRouteArgs{key: $key, howToUseID: $howToUseID}';
  }
}

/// generated route for [_i7.EmergencyCallPopUpPage]
class EmergencyCallPopUpRoute
    extends _i1.PageRouteInfo<EmergencyCallPopUpRouteArgs> {
  EmergencyCallPopUpRoute({_i12.Key? key, required int emergencyCallPopUpID})
      : super(name,
            path: ':emergencyCallPopUpID',
            args: EmergencyCallPopUpRouteArgs(
                key: key, emergencyCallPopUpID: emergencyCallPopUpID),
            rawPathParams: {'emergencyCallPopUpID': emergencyCallPopUpID});

  static const String name = 'EmergencyCallPopUpRoute';
}

class EmergencyCallPopUpRouteArgs {
  const EmergencyCallPopUpRouteArgs(
      {this.key, required this.emergencyCallPopUpID});

  final _i12.Key? key;

  final int emergencyCallPopUpID;

  @override
  String toString() {
    return 'EmergencyCallPopUpRouteArgs{key: $key, emergencyCallPopUpID: $emergencyCallPopUpID}';
  }
}

/// generated route for [_i8.ConnectPsapPage]
class ConnectPsapRoute extends _i1.PageRouteInfo<ConnectPsapRouteArgs> {
  ConnectPsapRoute({_i12.Key? key, required int connectPsapPageID})
      : super(name,
            path: ':connectPsapPageID',
            args: ConnectPsapRouteArgs(
                key: key, connectPsapPageID: connectPsapPageID),
            rawPathParams: {'connectPsapPageID': connectPsapPageID});

  static const String name = 'ConnectPsapRoute';
}

class ConnectPsapRouteArgs {
  const ConnectPsapRouteArgs({this.key, required this.connectPsapPageID});

  final _i12.Key? key;

  final int connectPsapPageID;

  @override
  String toString() {
    return 'ConnectPsapRouteArgs{key: $key, connectPsapPageID: $connectPsapPageID}';
  }
}

/// generated route for [_i9.ProfilePage]
class ProfileRoute extends _i1.PageRouteInfo<void> {
  const ProfileRoute() : super(name, path: '');

  static const String name = 'ProfileRoute';
}

/// generated route for [_i10.ActivitiesPage]
class ActivitiesRoute extends _i1.PageRouteInfo<void> {
  const ActivitiesRoute() : super(name, path: '');

  static const String name = 'ActivitiesRoute';
}

/// generated route for [_i11.ActivityDetailPage]
class ActivityDetailRoute extends _i1.PageRouteInfo<ActivityDetailRouteArgs> {
  ActivityDetailRoute({_i12.Key? key, required dynamic Snapshot})
      : super(name,
            path: '',
            args: ActivityDetailRouteArgs(key: key, Snapshot: Snapshot));

  static const String name = 'ActivityDetailRoute';
}

class ActivityDetailRouteArgs {
  const ActivityDetailRouteArgs({this.key, required this.Snapshot});

  final _i12.Key? key;

  final dynamic Snapshot;

  @override
  String toString() {
    return 'ActivityDetailRouteArgs{key: $key, Snapshot: $Snapshot}';
  }
}
