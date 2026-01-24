import 'package:flutter/material.dart';

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final SlideTransitionDirection direction;

  SlidePageRoute({
    required this.page,
    this.direction = SlideTransitionDirection.rightToLeft,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Offset begin;
            switch (direction) {
              case SlideTransitionDirection.leftToRight:
                begin = const Offset(-1, 0);
                break;
              case SlideTransitionDirection.rightToLeft:
                begin = const Offset(1, 0);
                break;
              case SlideTransitionDirection.topToBottom:
                begin = const Offset(0, -1);
                break;
              case SlideTransitionDirection.bottomToTop:
                begin = const Offset(0, 1);
                break;
            }

            final tween = Tween(begin: begin, end: Offset.zero).chain(
              CurveTween(curve: Curves.easeOutCubic),
            );

            final fadeTween = Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: Curves.easeOut),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
        );
}

enum SlideTransitionDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}

class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  ScalePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final scaleTween = Tween(begin: 0.8, end: 1.0).chain(
              CurveTween(curve: Curves.easeOutCubic),
            );
            final fadeTween = Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: Curves.easeOut),
            );

            return ScaleTransition(
              scale: animation.drive(scaleTween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
        );
}

class SharedAxisPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SharedAxisPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeInTween = Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
            );
            final slideInTween = Tween(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).chain(
              CurveTween(curve: Curves.easeOutCubic),
            );

            return FadeTransition(
              opacity: animation.drive(fadeInTween),
              child: SlideTransition(
                position: animation.drive(slideInTween),
                child: child,
              ),
            );
          },
        );
}
