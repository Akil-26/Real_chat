import 'user_model.dart';
import 'message_model.dart';

enum ConversationType { direct, group, broadcast, team }

class ConversationModel {
  final String id;
  final UserModel user;
  final MessageModel? lastMessage;
  final int unreadCount;
  final bool isMuted;
  final bool isPinned;
  final bool isArchived;
  final ConversationType type;
  final List<UserModel>? participants; // for groups
  final String? groupName;
  final String? groupAvatarUrl;

  const ConversationModel({
    required this.id,
    required this.user,
    this.lastMessage,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isPinned = false,
    this.isArchived = false,
    this.type = ConversationType.direct,
    this.participants,
    this.groupName,
    this.groupAvatarUrl,
  });

  String get displayName {
    if (type == ConversationType.group && groupName != null) {
      return groupName!;
    }
    return user.name;
  }

  String? get displayAvatar {
    if (type == ConversationType.group && groupAvatarUrl != null) {
      return groupAvatarUrl;
    }
    return user.avatarUrl;
  }

  String get lastMessagePreview {
    if (lastMessage == null) return '';

    switch (lastMessage!.type) {
      case MessageType.text:
        return lastMessage!.content;
      case MessageType.voice:
        return '🎵 Voice message';
      case MessageType.image:
        return '📷 Photo';
      case MessageType.video:
        return '🎬 Video';
      case MessageType.document:
        return '📎 ${lastMessage!.fileName ?? "Document"}';
      case MessageType.location:
        return '📍 Location';
    }
  }

  String get lastMessageTime {
    if (lastMessage == null) return '';

    final now = DateTime.now();
    final messageDate = lastMessage!.timestamp;
    final difference = now.difference(messageDate);

    if (difference.inDays == 0) {
      // Today - show time
      return lastMessage!.timeString;
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}m';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y';
    }
  }

  ConversationModel copyWith({
    String? id,
    UserModel? user,
    MessageModel? lastMessage,
    int? unreadCount,
    bool? isMuted,
    bool? isPinned,
    bool? isArchived,
    ConversationType? type,
    List<UserModel>? participants,
    String? groupName,
    String? groupAvatarUrl,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      user: user ?? this.user,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      groupName: groupName ?? this.groupName,
      groupAvatarUrl: groupAvatarUrl ?? this.groupAvatarUrl,
    );
  }
}
