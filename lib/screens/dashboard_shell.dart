import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  DateTime? _lastBackPress;

  @override
  Widget build(BuildContext context) {
    final currentRoute = _getCurrentRoute();
    final isHome = currentRoute == '/home';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (!isHome) {
          // Non-home tab: go back to home
          context.go('/home');
        } else {
          // Home tab: double-back to exit
          final now = DateTime.now();
          if (_lastBackPress != null && now.difference(_lastBackPress!) < const Duration(seconds: 2)) {
            SystemNavigator.pop();
          } else {
            _lastBackPress = now;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Press back again to exit'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: widget.child),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomNavigation(currentRoute: currentRoute),
            ),
          ],
        ),
      ),
    );
  }
}
