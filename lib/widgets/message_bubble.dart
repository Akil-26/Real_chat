import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool showTail;

  const MessageBubble({
    super.key,
    required this.message,
    this.showTail = true,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: message.isMe ? 60 : 0,
          right: message.isMe ? 0 : 60,
          bottom: 4,
        ),
        child: _buildBubbleContent(),
      ),
    );
  }

  Widget _buildBubbleContent() {
    switch (message.type) {
      case MessageType.text:
        return _buildTextBubble();
      case MessageType.voice:
        return _buildVoiceBubble();
      case MessageType.image:
        return _buildImageBubble();
      default:
        return _buildTextBubble();
    }
  }

  Widget _buildTextBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: message.isMe ? AppColors.sentBubble : AppColors.receivedBubble,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(message.isMe ? 20 : (showTail ? 4 : 20)),
          bottomRight: Radius.circular(message.isMe ? (showTail ? 4 : 20) : 20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message.content,
            style: AppTextStyles.messageText.copyWith(
              color: message.isMe
                  ? AppColors.sentBubbleText
                  : AppColors.receivedBubbleText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: message.isMe ? AppColors.sentBubble : AppColors.receivedBubble,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(message.isMe ? 20 : (showTail ? 4 : 20)),
          bottomRight: Radius.circular(message.isMe ? (showTail ? 4 : 20) : 20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: message.isMe
                  ? AppColors.textOnPrimary
                  : AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: message.isMe
                  ? AppColors.primary
                  : AppColors.textOnPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Waveform visualization
          _buildWaveform(),
          const SizedBox(width: AppSpacing.sm),
          Text(
            message.voiceDurationString,
            style: TextStyle(
              color: message.isMe
                  ? AppColors.sentBubbleText.withValues(alpha: 0.7)
                  : AppColors.receivedBubbleText.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    return SizedBox(
      width: 140,
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(25, (index) {
          // Create a simple waveform pattern
          final heights = [0.3, 0.5, 0.7, 0.4, 0.9, 0.6, 0.8, 0.5, 0.7, 0.4, 
                         0.6, 0.9, 0.5, 0.7, 0.4, 0.8, 0.6, 0.5, 0.7, 0.9,
                         0.4, 0.6, 0.5, 0.7, 0.4];
          return Container(
            width: 2,
            height: 24 * heights[index % heights.length],
            decoration: BoxDecoration(
              color: message.isMe
                  ? AppColors.textOnPrimary.withValues(alpha: 0.7)
                  : AppColors.textPrimary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(1),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildImageBubble() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      decoration: BoxDecoration(
        color: message.isMe ? AppColors.sentBubble : AppColors.receivedBubble,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(message.isMe ? 20 : (showTail ? 4 : 20)),
          bottomRight: Radius.circular(message.isMe ? (showTail ? 4 : 20) : 20),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(message.isMe ? 20 : (showTail ? 4 : 20)),
          bottomRight: Radius.circular(message.isMe ? (showTail ? 4 : 20) : 20),
        ),
        child: Stack(
          children: [
            if (message.mediaUrl != null)
              Image.network(
                message.mediaUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 150,
                    color: AppColors.surface,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              )
            else
              Container(
                width: 200,
                height: 150,
                color: AppColors.surface,
                child: const Icon(Icons.image, size: 48),
              ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message.timeString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
