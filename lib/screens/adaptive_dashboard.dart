import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_session_provider.dart';
import '../models/user.dart';
import 'home_screen.dart';

class AdaptiveDashboard extends ConsumerWidget {
  const AdaptiveDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user != null && user.mode == AppMode.professor) {
          WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/admin'));
          return const SizedBox.shrink();
        }
        return const HomeScreen();
      },
      loading: () => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF002147),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'CG',
                    style: TextStyle(
                      color: Color(0xFFFDC800),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF002147)),
              ),
            ],
          ),
        ),
      ),
      error: (error, _) => const HomeScreen(), // Fallback to home screen on error
    );
  }
}
