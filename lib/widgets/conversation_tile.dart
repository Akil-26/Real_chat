import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import 'user_avatar.dart';

class ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ConversationTile({
    super.key,
    required this.conversation,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        child: Row(
          children: [
            // Avatar
            UserAvatar(
              imageUrl: conversation.displayAvatar,
              name: conversation.displayName,
              size: 52,
              showOnlineIndicator: true,
              isOnline: conversation.user.isOnline,
            ),
            const SizedBox(width: AppSpacing.md),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.displayName,
                          style: AppTextStyles.chatName.copyWith(
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        conversation.lastMessageTime,
                        style: AppTextStyles.chatTime.copyWith(
                          color: conversation.unreadCount > 0
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                          fontWeight: conversation.unreadCount > 0
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Message status indicator for sent messages
                      if (conversation.lastMessage?.isMe == true) ...[
                        _buildStatusIcon(conversation.lastMessage!.status),
                        const SizedBox(width: 4),
                      ],
                      
                      Expanded(
                        child: Text(
                          conversation.lastMessagePreview,
                          style: AppTextStyles.chatPreview.copyWith(
                            color: conversation.unreadCount > 0
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Unread count or muted icon
                      if (conversation.unreadCount > 0)
                        _buildUnreadBadge()
                      else if (conversation.isMuted)
                        const Icon(
                          Icons.volume_off_rounded,
                          size: 18,
                          color: AppColors.textTertiary,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    IconData icon;
    Color color;
    
    switch (status) {
      case MessageStatus.sending:
        icon = Icons.access_time_rounded;
        color = AppColors.textTertiary;
        break;
      case MessageStatus.sent:
        icon = Icons.check_rounded;
        color = AppColors.textTertiary;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all_rounded;
        color = AppColors.textTertiary;
        break;
      case MessageStatus.read:
        icon = Icons.done_all_rounded;
        color = AppColors.accent;
        break;
      case MessageStatus.failed:
        icon = Icons.error_outline_rounded;
        color = AppColors.error;
        break;
    }
    
    return Icon(icon, size: 16, color: color);
  }

  Widget _buildUnreadBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.unread,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        conversation.unreadCount > 99 ? '99+' : conversation.unreadCount.toString(),
        style: const TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
