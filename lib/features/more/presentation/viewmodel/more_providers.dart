import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileModel {
  final String name;
  final String avatarUrl;
  final bool isPremium;

  const UserProfileModel({
    required this.name,
    required this.avatarUrl,
    required this.isPremium,
  });
}

// User Profile Provider returning dummy data
final userProfileProvider = Provider<UserProfileModel>((ref) {
  return const UserProfileModel(
    name: 'Budi',
    avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&h=150&q=80',
    isPremium: true,
  );
});

// StateProvider to control notification badge visibility
final hasUnreadNotificationsProvider = StateProvider<bool>((ref) => true);
