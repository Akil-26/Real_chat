import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class ChatDetailScreen extends StatefulWidget {
  final ConversationModel conversation;

  const ChatDetailScreen({super.key, required this.conversation});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  List<MessageModel> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // Load messages based on conversation
    if (widget.conversation.user.name == 'Robert Fox') {
      _messages = MockData.getRobertFoxMessages();
    } else {
      // Generate some sample messages for other conversations
      _messages = _generateSampleMessages();
    }
    setState(() {});
  }

  List<MessageModel> _generateSampleMessages() {
    final now = DateTime.now();
    return [
      MessageModel(
        id: 'gen_1',
        senderId: widget.conversation.user.id,
        content: 'Hey there! 👋',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 2)),
        status: MessageStatus.read,
        isMe: false,
      ),
      MessageModel(
        id: 'gen_2',
        senderId: 'current_user',
        content: 'Hi! How are you?',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 1, minutes: 55)),
        status: MessageStatus.read,
        isMe: true,
      ),
      MessageModel(
        id: 'gen_3',
        senderId: widget.conversation.user.id,
        content: widget.conversation.lastMessagePreview,
        type: widget.conversation.lastMessage?.type ?? MessageType.text,
        timestamp: widget.conversation.lastMessage?.timestamp ?? now,
        status: MessageStatus.read,
        isMe: false,
        voiceDuration: widget.conversation.lastMessage?.voiceDuration,
      ),
    ];
  }

  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;

    final newMessage = MessageModel(
      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'current_user',
      content: content,
      type: MessageType.text,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
      isMe: true,
    );

    setState(() {
      _messages.add(newMessage);
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate message delivery
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          final index = _messages.indexWhere((m) => m.id == newMessage.id);
          if (index != -1) {
            _messages[index] = newMessage.copyWith(
              status: MessageStatus.delivered,
            );
          }
        });
      }
    });

    // Simulate "typing" and response
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isTyping = false;

          // Mark as read
          final index = _messages.indexWhere((m) => m.id == newMessage.id);
          if (index != -1) {
            _messages[index] = newMessage.copyWith(status: MessageStatus.read);
          }

          // Add response
          _messages.add(
            MessageModel(
              id: 'resp_${DateTime.now().millisecondsSinceEpoch}',
              senderId: widget.conversation.user.id,
              content: _getAutoResponse(content),
              type: MessageType.text,
              timestamp: DateTime.now(),
              status: MessageStatus.read,
              isMe: false,
            ),
          );
        });

        // Scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  String _getAutoResponse(String message) {
    final responses = [
      'That\'s interesting! 🤔',
      'I agree with you.',
      'Let me think about that...',
      'Great point! 👍',
      'Thanks for sharing!',
      'I\'ll get back to you on that.',
      'Sounds good!',
      'Perfect! 🎉',
    ];
    return responses[message.length % responses.length];
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentOption(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      color: const Color(0xFFE91E63),
                      onTap: () {
                        Navigator.pop(context);
                        _showSnackBar('Opening camera...');
                      },
                    ),
                    _buildAttachmentOption(
                      icon: Icons.photo_rounded,
                      label: 'Gallery',
                      color: const Color(0xFF9C27B0),
                      onTap: () {
                        Navigator.pop(context);
                        _showSnackBar('Opening gallery...');
                      },
                    ),
                    _buildAttachmentOption(
                      icon: Icons.insert_drive_file_rounded,
                      label: 'Document',
                      color: const Color(0xFF3F51B5),
                      onTap: () {
                        Navigator.pop(context);
                        _showSnackBar('Opening files...');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentOption(
                      icon: Icons.location_on_rounded,
                      label: 'Location',
                      color: const Color(0xFF4CAF50),
                      onTap: () {
                        Navigator.pop(context);
                        _showSnackBar('Opening location...');
                      },
                    ),
                    _buildAttachmentOption(
                      icon: Icons.person_rounded,
                      label: 'Contact',
                      color: const Color(0xFF03A9F4),
                      onTap: () {
                        Navigator.pop(context);
                        _showSnackBar('Opening contacts...');
                      },
                    ),
                    _buildAttachmentOption(
                      icon: Icons.poll_rounded,
                      label: 'Poll',
                      color: const Color(0xFFFF9800),
                      onTap: () {
                        Navigator.pop(context);
                        _showSnackBar('Creating poll...');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _startVoiceRecording() {
    _showSnackBar('Hold to record voice message');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          if (_isTyping) _buildTypingIndicator(),
          ChatInputField(
            onSendMessage: _sendMessage,
            onAttachmentPressed: _showAttachmentOptions,
            onVoicePressed: _startVoiceRecording,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.iconDefault,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          UserAvatar(
            imageUrl: widget.conversation.displayAvatar,
            name: widget.conversation.displayName,
            size: 40,
            showOnlineIndicator: true,
            isOnline: widget.conversation.user.isOnline,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.conversation.displayName,
                  style: AppTextStyles.chatName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.conversation.user.subtitle != null)
                  Text(
                    widget.conversation.user.subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                else if (_isTyping)
                  Text(
                    'typing...',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accent,
                    ),
                  )
                else
                  Text(
                    widget.conversation.user.isOnline
                        ? 'Online'
                        : widget.conversation.user.lastSeenText,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: widget.conversation.user.isOnline
                          ? AppColors.online
                          : AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.more_vert_rounded,
            color: AppColors.iconDefault,
          ),
          onPressed: () {
            _showChatOptions();
          },
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final showTail =
            index == _messages.length - 1 ||
            _messages[index + 1].isMe != message.isMe;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: MessageBubble(message: message, showTail: showTail),
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.receivedBubble,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTypingDot(0),
            const SizedBox(width: 4),
            _buildTypingDot(1),
            const SizedBox(width: 4),
            _buildTypingDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.textTertiary.withValues(
              alpha: 0.3 + (0.7 * ((value + index * 0.3) % 1)),
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ListTile(
                  leading: const Icon(Icons.search_rounded),
                  title: const Text('Search in chat'),
                  onTap: () {
                    Navigator.pop(context);
                    _showSnackBar('Search feature coming soon');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: const Text('Media, links, and docs'),
                  onTap: () {
                    Navigator.pop(context);
                    _showSnackBar('Media gallery coming soon');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.wallpaper_rounded),
                  title: const Text('Wallpaper'),
                  onTap: () {
                    Navigator.pop(context);
                    _showSnackBar('Wallpaper picker coming soon');
                  },
                ),
                ListTile(
                  leading: Icon(
                    widget.conversation.isMuted
                        ? Icons.volume_up_rounded
                        : Icons.volume_off_rounded,
                  ),
                  title: Text(
                    widget.conversation.isMuted
                        ? 'Unmute'
                        : 'Mute notifications',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showSnackBar('Notification settings updated');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.block_rounded,
                    color: AppColors.error,
                  ),
                  title: const Text(
                    'Block',
                    style: TextStyle(color: AppColors.error),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showBlockConfirmation();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBlockConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: const Text('Block Contact'),
          content: Text(
            'Are you sure you want to block ${widget.conversation.displayName}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                _showSnackBar('Contact blocked');
              },
              child: const Text(
                'Block',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
