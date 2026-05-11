import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme_extensions.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/app_session_provider.dart';
import '../widgets/user_avatar.dart';
import 'avatar_crop_screen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  String? _avatarUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider).value;
    _avatarUrl = user?.avatar;
  }

  Future<void> _changePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final bytes = await image.length();
      const maxSizeBytes = 5 * 1024 * 1024;

      if (bytes > maxSizeBytes) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image size exceeds 5MB limit. Please choose a smaller image.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (!mounted) return;
      // Navigate to crop screen — rootNavigator bypasses bottom nav shell
      final result = await Navigator.of(context, rootNavigator: true).push<String>(
        MaterialPageRoute(
          builder: (context) => AvatarCropScreen(imageFile: image),
        ),
      );

      if (mounted && result != null) {
        setState(() => _avatarUrl = result);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      avatar: _avatarUrl ?? currentUser.avatar,
    );

    final success = await ref.read(appSessionControllerProvider.notifier).updateUser(updatedUser);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF002147);
    const goldColor = Color(0xFFFDC800);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(color: context.navyOrWhite, fontWeight: FontWeight.bold)),
        backgroundColor: context.pageBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: context.navyOrWhite),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: context.navyOrWhite)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
            children: [

              // Avatar with camera button
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: navyColor.withValues(alpha: 0.1), width: 4),
                      ),
                      child: UserAvatar(
                        avatarUrl: _avatarUrl ?? '',
                        name: ref.read(currentUserProvider).value?.name ?? '',
                        size: 100,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _changePhoto,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: navyColor,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                          ),
                          child: const Icon(Icons.camera_alt, color: goldColor, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tap the camera icon to change your photo',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              const SizedBox(height: 32),

              // Info card about UMS data
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.borderCol),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF3B82F6), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Name, faculty, department, and level are synced from UMS and cannot be edited here.',
                        style: TextStyle(color: context.mutedText, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
      ),
    );
  }
}
