import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002147),
      body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Top section with logo and welcome text
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logo image
                                Image.asset(
                                  'assets/splash screen/sci.png',
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Welcome',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Choose how you want to continue',
                                  style: TextStyle(
                                    color: Color(0xFFd1d5db),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Bottom section with buttons
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // User Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => context.go('/login'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF002147),
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person, color: Colors.white, size: 24),
                                      SizedBox(width: 12),
                                      Text(
                                        'User',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Guest Button
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => context.go('/guest/ar'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFF002147),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_outline,
                                        color: Color(0xFF002147),
                                        size: 24,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Guest',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF002147),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
    );
  }


}
