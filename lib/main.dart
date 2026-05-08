import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/app_session_provider.dart';
import 'providers/theme_provider.dart';
import 'core/app_theme.dart';
import 'screens/dashboard_shell.dart';
import 'screens/TaskPages/Task.dart';
import 'screens/assignments_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/navigate_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/auth/login_screen.dart';

import 'screens/auth/register_screen.dart';
import 'screens/auth/course_selection_screen.dart';
import 'screens/auth/verification_page.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'storage_services.dart';
import 'notification_service.dart';
import 'screens/student_guide/explain_screen.dart';
import 'screens/student_guide/explain_program.dart';

import 'screens/guest/guest_dashboard_shell.dart';
import 'screens/adaptive_dashboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'services/data_service.dart';
import 'models/user.dart';
import 'features/admin/admin_panel_page.dart';
import 'screens/doctor/doctor_dashboard_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/courses_list_screen.dart';
import 'screens/advising_chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Services
  await StorageService.init();
  await NotificationService.init();
  await NotificationService.requestPermissions();

  // Initialize Firebase (non-fatal if google-services.json is not yet added)
  if (!kIsWeb) {
    await NotificationService.initFirebase();
  }
  
  runApp(const ProviderScope(child: PhoneFrameWrapper(child: StudentDashboardApp())));
}

/// Wraps the app in a phone frame on web for demo purposes
class PhoneFrameWrapper extends StatelessWidget {
  final Widget child;
  const PhoneFrameWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Only show phone frame on web
    if (!kIsWeb) return child;
    
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF1a1a2e),
        body: Center(
          child: Container(
            width: 380,
            height: 800,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.grey.shade800, width: 8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class StudentDashboardApp extends ConsumerStatefulWidget {
  const StudentDashboardApp({super.key});

  @override
  ConsumerState<StudentDashboardApp> createState() =>
      _StudentDashboardAppState();
}

class _StudentDashboardAppState extends ConsumerState<StudentDashboardApp> {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      navigatorKey: _navigatorKey,
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/verification',
          builder: (context, state) {
            final extra = state.extra as Map<String, String>?;
            return VerificationPage(
              email: extra?['email'] ?? '',
              password: extra?['password'],
              isPasswordReset: extra?['isPasswordReset'] == 'true',
            );
          },
        ),
        GoRoute(
          path: '/reset-password',
          builder: (context, state) {
            final extra = state.extra as Map<String, String>?;
            return ResetPasswordPage(email: extra?['email'] ?? '');
          },
        ),
        GoRoute(
          path: '/course-selection',
          builder: (context, state) {
            final extra = state.extra as Map<String, String>?;
            return SelectCoursePage(
              email: extra?['email'] ?? '',
              password: extra?['password'],
            );
          },
        ),

            GoRoute(
              path: '/admin',
              builder: (context, state) => AdminPanelPage(),
            ),
            GoRoute(
              path: '/doctor',
              builder: (context, state) => DoctorDashboardScreen(),
            ),

        ShellRoute(
          builder: (context, state, child) {
            return GuestDashboardShell(child: child);
          },
          routes: [
            GoRoute(
              path: '/guest/ar',
              builder: (context, state) => const NavigateScreen(isGuest: true),
            ),
            GoRoute(
              path: '/guest/departments',
              builder: (context, state) => const ExplainProgram(),
            ),
          ],
        ),
        ShellRoute(
          builder: (context, state, child) {
            return DashboardShell(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const AdaptiveDashboard(),
            ),
            GoRoute(
              path: '/tasks',
              builder: (context, state) => const TasksPage(),
            ),
            GoRoute(
              path: '/assignments',
              builder: (context, state) => const AssignmentsScreen(),
            ),
            GoRoute(
              path: '/schedule',
              builder: (context, state) => const ScheduleScreen(),
            ),
            GoRoute(
              path: '/navigate',
              builder: (context, state) => const NavigateScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: '/course/:courseId',
              builder: (context, state) {
                final courseId = state.pathParameters['courseId']!;
                return CourseDetailScreen(courseId: courseId);
              },
            ),
            GoRoute(
              path: '/notifications',
              builder: (context, state) => NotificationsScreen(),
            ),
            GoRoute(
              path: '/my-courses',
              builder: (context, state) => CoursesListScreen(),
            ),

            GoRoute(
              path: '/advising/chat/:email',
              builder: (context, state) {
                final email = state.pathParameters['email']!;
                return AdvisingChatScreen(otherUserEmail: email);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    // Redirection Logic
    void handleRedirection() {
      if (!mounted) return;
      
      final currentLocation = _router.routerDelegate.currentConfiguration.uri.path;
      final isAuthRoute = currentLocation == '/login' ||
          currentLocation == '/register' ||
          currentLocation == '/splash' ||
          currentLocation == '/welcome' ||
          currentLocation.startsWith('/guest/'); 
      final isVerificationRoute = currentLocation == '/verification';
      final isOnboardingRoute = currentLocation == '/course-selection';

      // Skip redirects while session is initializing from SharedPreferences
      if (authState is AuthLoading) return;

      // Handle navigation based on auth state
      if (authState is AuthUnauthenticated) {
        // Not logged in - redirect to login unless already on an auth page
        if (!isAuthRoute && !isOnboardingRoute && !isVerificationRoute) {
          _router.go('/login');
        }
      } else if (authState is AuthOnboardingRequired) {
        final user = authState.user;
        // User is logged in but hasn't completed onboarding
        if (!isOnboardingRoute && !isVerificationRoute) {
          _router.go('/course-selection', extra: {'email': user.email});
        }
      } else if (authState is AuthAuthenticated) {
        final user = (authState as AuthAuthenticated).user;
        final isAdminRoute = currentLocation.startsWith('/admin');
        final isDoctorRoute = currentLocation.startsWith('/doctor');

        if (user.mode == AppMode.admin) {
          // Admin only sees the admin panel (PDF upload)
          if (!isAdminRoute) {
            _router.go('/admin');
          }
        } else if (user.mode == AppMode.doctor) {
          // Doctors see the doctor dashboard
          if (!isDoctorRoute) {
            _router.go('/doctor');
          }
        } else {
          // Students go to home
          if (isAuthRoute || isOnboardingRoute || isVerificationRoute || currentLocation == '/splash') {
            _router.go('/home');
          }
        }
      }
    }

    // Only listen for state changes, don't run on every build
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (previous != next) {
        WidgetsBinding.instance.addPostFrameCallback((_) => handleRedirection());
      }

      // When a user logs in, send their FCM token to the backend
      if (next is AuthAuthenticated && previous is! AuthAuthenticated) {
        NotificationService.getFcmToken().then((token) {
          if (token != null) DataService.updateFcmToken(token);
        });

        // Also keep the token fresh when Firebase rotates it
        if (!kIsWeb) {
          FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
            DataService.updateFcmToken(newToken);
          });
        }
      }
    });
    
    // Initial check on first build
    WidgetsBinding.instance.addPostFrameCallback((_) => handleRedirection());

    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Student Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}
