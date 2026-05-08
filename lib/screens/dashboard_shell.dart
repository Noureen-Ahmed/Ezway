import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_bottom_navigation.dart';

class DashboardShell extends ConsumerStatefulWidget {
  final Widget child;

  const DashboardShell({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends ConsumerState<DashboardShell> {
  String _getCurrentRoute() {
    try {
      return GoRouterState.of(context).uri.path;
    } catch (_) {
      return '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = _getCurrentRoute();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Main content
          Positioned.fill(child: widget.child),
          
          // Custom header - removed to avoid double header
          // HomeScreen handles its own header
          /*
          if (currentRoute.startsWith('/home'))
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomHeader(),
            ),
          */
          
          // Custom bottom navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavigation(currentRoute: currentRoute),
          ),
        ],
      ),
    );
  }
}
