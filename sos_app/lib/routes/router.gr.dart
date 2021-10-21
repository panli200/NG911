// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i8;

import '../activities.dart' as _i3;
import '../profile_extended_pages/profile.dart' as _i7;
import '../sos.dart' as _i1;
import '../sos_extended_pages/how_to_use_app_page.dart' as _i5;
import '../sos_extended_pages/in_call_page.dart' as _i6;
import '../sos_extended_pages/sos_home_page.dart' as _i4;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
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
          routeData: routeData, child: const _i3.ActivitiesPage());
    },
    SosHomeRoute.name: (routeData) {
      final args = routeData.argsAs<SosHomeRouteArgs>(
          orElse: () => const SosHomeRouteArgs());
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i4.SosHomePage(key: args.key));
    },
    HowToUseRoute.name: (routeData) {
      final args = routeData.argsAs<HowToUseRouteArgs>(
          orElse: () => const HowToUseRouteArgs());
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i5.HowToUsePage(key: args.key));
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
                    path: '', parent: SosRouter.name),
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
              path: 'activities', parent: SosRoute.name)
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

/// generated route for [_i3.ActivitiesPage]
class ActivitiesRouter extends _i2.PageRouteInfo<void> {
  const ActivitiesRouter() : super(name, path: 'activities');

  static const String name = 'ActivitiesRouter';
}

/// generated route for [_i4.SosHomePage]
class SosHomeRoute extends _i2.PageRouteInfo<SosHomeRouteArgs> {
  SosHomeRoute({_i8.Key? key})
      : super(name, path: '', args: SosHomeRouteArgs(key: key));

  static const String name = 'SosHomeRoute';
}

class SosHomeRouteArgs {
  const SosHomeRouteArgs({this.key});

  final _i8.Key? key;
}

/// generated route for [_i5.HowToUsePage]
class HowToUseRoute extends _i2.PageRouteInfo<HowToUseRouteArgs> {
  HowToUseRoute({_i8.Key? key})
      : super(name, path: '', args: HowToUseRouteArgs(key: key));

  static const String name = 'HowToUseRoute';
}

class HowToUseRouteArgs {
  const HowToUseRouteArgs({this.key});

  final _i8.Key? key;
}

/// generated route for [_i6.InCallPage]
class InCallRoute extends _i2.PageRouteInfo<InCallRouteArgs> {
  InCallRoute({_i8.Key? key})
      : super(name, path: '', args: InCallRouteArgs(key: key));

  static const String name = 'InCallRoute';
}

class InCallRouteArgs {
  const InCallRouteArgs({this.key});

  final _i8.Key? key;
}

/// generated route for [_i7.ProfilePage]
class ProfileRoute extends _i2.PageRouteInfo<void> {
  const ProfileRoute() : super(name, path: '');

  static const String name = 'ProfileRoute';
}
