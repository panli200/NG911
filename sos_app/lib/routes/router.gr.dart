// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i10;

import '../activities_extended_pages/activities.dart' as _i8;
import '../activities_extended_pages/activity_detail.dart' as _i9;
import '../profile_extended_pages/profile.dart' as _i7;
import '../sos.dart' as _i1;
import '../sos_extended_pages/how_to_use_app_page.dart' as _i4;
import '../sos_extended_pages/in_call_page.dart' as _i6;
import '../sos_extended_pages/medical_call_popup_page.dart' as _i5;
import '../sos_extended_pages/sos_home_page.dart' as _i3;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    SosRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SosPage());
    },
    SosRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    ProfileRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    ActivitiesRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    SosHomeRoute.name: (routeData) {
      final args = routeData.argsAs<SosHomeRouteArgs>(
          orElse: () => const SosHomeRouteArgs());
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.SosHomePage(key: args.key));
    },
    HowToUseRoute.name: (routeData) {
      final pathParams = routeData.pathParams;
      final args = routeData.argsAs<HowToUseRouteArgs>(
          orElse: () =>
              HowToUseRouteArgs(howToUseID: pathParams.getInt('howToUseID')));
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.HowToUsePage(key: args.key, howToUseID: args.howToUseID));
    },
    MedicalCallPopUpRoute.name: (routeData) {
      final pathParams = routeData.pathParams;
      final args = routeData.argsAs<MedicalCallPopUpRouteArgs>(
          orElse: () => MedicalCallPopUpRouteArgs(
              medicalCallPopUpID: pathParams.getInt('medicalCallPopUpID')));
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.MedicalCallPopUpPage(
              key: args.key, medicalCallPopUpID: args.medicalCallPopUpID));
    },
    InCallRoute.name: (routeData) {
      final args = routeData.argsAs<InCallRouteArgs>(
          orElse: () => const InCallRouteArgs());
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i6.InCallPage(key: args.key));
    },
    ProfileRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.ProfilePage());
    },
    ActivitiesRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i8.ActivitiesPage());
    },
    ActivityDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ActivityDetailRouteArgs>();
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child:
              _i9.ActivityDetailPage(key: args.key, Snapshot: args.Snapshot));
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig(SosRoute.name, path: '/', children: [
          _i2.RouteConfig(SosRouter.name,
              path: 'sos_extended_pages',
              parent: SosRoute.name,
              children: [
                _i2.RouteConfig(SosHomeRoute.name,
                    path: '', parent: SosRouter.name),
                _i2.RouteConfig(HowToUseRoute.name,
                    path: ':howToUseID', parent: SosRouter.name),
                _i2.RouteConfig(MedicalCallPopUpRoute.name,
                    path: ':medicalCallPopUpID', parent: SosRouter.name),
                _i2.RouteConfig(InCallRoute.name,
                    path: '', parent: SosRouter.name)
              ]),
          _i2.RouteConfig(ProfileRouter.name,
              path: 'profile_extended_pages',
              parent: SosRoute.name,
              children: [
                _i2.RouteConfig(ProfileRoute.name,
                    path: '', parent: ProfileRouter.name)
              ]),
          _i2.RouteConfig(ActivitiesRouter.name,
              path: 'activities_extended_pages',
              parent: SosRoute.name,
              children: [
                _i2.RouteConfig(ActivitiesRoute.name,
                    path: '', parent: ActivitiesRouter.name),
                _i2.RouteConfig(ActivityDetailRoute.name,
                    path: '', parent: ActivitiesRouter.name)
              ])
        ])
      ];
}

/// generated route for [_i1.SosPage]
class SosRoute extends _i2.PageRouteInfo<void> {
  const SosRoute({List<_i2.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'SosRoute';
}

/// generated route for [_i2.EmptyRouterPage]
class SosRouter extends _i2.PageRouteInfo<void> {
  const SosRouter({List<_i2.PageRouteInfo>? children})
      : super(name, path: 'sos_extended_pages', initialChildren: children);

  static const String name = 'SosRouter';
}

/// generated route for [_i2.EmptyRouterPage]
class ProfileRouter extends _i2.PageRouteInfo<void> {
  const ProfileRouter({List<_i2.PageRouteInfo>? children})
      : super(name, path: 'profile_extended_pages', initialChildren: children);

  static const String name = 'ProfileRouter';
}

/// generated route for [_i2.EmptyRouterPage]
class ActivitiesRouter extends _i2.PageRouteInfo<void> {
  const ActivitiesRouter({List<_i2.PageRouteInfo>? children})
      : super(name,
            path: 'activities_extended_pages', initialChildren: children);

  static const String name = 'ActivitiesRouter';
}

/// generated route for [_i3.SosHomePage]
class SosHomeRoute extends _i2.PageRouteInfo<SosHomeRouteArgs> {
  SosHomeRoute({_i10.Key? key})
      : super(name, path: '', args: SosHomeRouteArgs(key: key));

  static const String name = 'SosHomeRoute';
}

class SosHomeRouteArgs {
  const SosHomeRouteArgs({this.key});

  final _i10.Key? key;
}

/// generated route for [_i4.HowToUsePage]
class HowToUseRoute extends _i2.PageRouteInfo<HowToUseRouteArgs> {
  HowToUseRoute({_i10.Key? key, required int howToUseID})
      : super(name,
            path: ':howToUseID',
            args: HowToUseRouteArgs(key: key, howToUseID: howToUseID),
            rawPathParams: {'howToUseID': howToUseID});

  static const String name = 'HowToUseRoute';
}

class HowToUseRouteArgs {
  const HowToUseRouteArgs({this.key, required this.howToUseID});

  final _i10.Key? key;

  final int howToUseID;
}

/// generated route for [_i5.MedicalCallPopUpPage]
class MedicalCallPopUpRoute
    extends _i2.PageRouteInfo<MedicalCallPopUpRouteArgs> {
  MedicalCallPopUpRoute({_i10.Key? key, required int medicalCallPopUpID})
      : super(name,
            path: ':medicalCallPopUpID',
            args: MedicalCallPopUpRouteArgs(
                key: key, medicalCallPopUpID: medicalCallPopUpID),
            rawPathParams: {'medicalCallPopUpID': medicalCallPopUpID});

  static const String name = 'MedicalCallPopUpRoute';
}

class MedicalCallPopUpRouteArgs {
  const MedicalCallPopUpRouteArgs({this.key, required this.medicalCallPopUpID});

  final _i10.Key? key;

  final int medicalCallPopUpID;
}

/// generated route for [_i6.InCallPage]
class InCallRoute extends _i2.PageRouteInfo<InCallRouteArgs> {
  InCallRoute({_i10.Key? key})
      : super(name, path: '', args: InCallRouteArgs(key: key));

  static const String name = 'InCallRoute';
}

class InCallRouteArgs {
  const InCallRouteArgs({this.key});

  final _i10.Key? key;
}

/// generated route for [_i7.ProfilePage]
class ProfileRoute extends _i2.PageRouteInfo<void> {
  const ProfileRoute() : super(name, path: '');

  static const String name = 'ProfileRoute';
}

/// generated route for [_i8.ActivitiesPage]
class ActivitiesRoute extends _i2.PageRouteInfo<void> {
  const ActivitiesRoute() : super(name, path: '');

  static const String name = 'ActivitiesRoute';
}

/// generated route for [_i9.ActivityDetailPage]
class ActivityDetailRoute extends _i2.PageRouteInfo<ActivityDetailRouteArgs> {
  ActivityDetailRoute({_i10.Key? key, required dynamic Snapshot})
      : super(name,
            path: '',
            args: ActivityDetailRouteArgs(key: key, Snapshot: Snapshot));

  static const String name = 'ActivityDetailRoute';
}

class ActivityDetailRouteArgs {
  const ActivityDetailRouteArgs({this.key, required this.Snapshot});

  final _i10.Key? key;

  final dynamic Snapshot;
}
