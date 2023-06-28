import 'package:flutter/material.dart';

//! This for single routes on the fly creation.
class FadeRouteTransition<T> extends MaterialPageRoute<T> {
  FadeRouteTransition({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == '/') return child;

    return FadeTransition(opacity: animation, child: child);
  }
}

//! This for a general theme which affects all route transitions.
class FadePageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == '/') return child;

    return FadeTransition(opacity: animation, child: child);
  }
}
