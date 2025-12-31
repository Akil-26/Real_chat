import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../chat_detail/chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ConversationModel> _conversations = [];
  List<ConversationModel> _filteredConversations = [];
  int _currentNavIndex = 1; // Start on Chats tab

  @override
  void initState() {
    super.initState();
    _loadConversations();
    _searchController.addListener(_filterConversations);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadConversations() {
    _conversations = MockData.getConversations();
    _filteredConversations = List.from(_conversations);
    setState(() {});
  }

  void _filterConversations() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      _filteredConversations = List.from(_conversations);
    } else {
      _filteredConversations = _conversations.where((conv) {
        return conv.displayName.toLowerCase().contains(query) ||
            (conv.lastMessagePreview.toLowerCase().contains(query));
      }).toList();
    }
    setState(() {});
  }

  void _navigateToChat(ConversationModel conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(conversation: conversation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildConversationList()),
          ],
        ),
      ),
      floatingActionButton: _buildFab(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Messages', style: AppTextStyles.h1),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppColors.iconDefault,
                size: 22,
              ),
              onPressed: () {
                // Handle notifications
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: SearchField(
        controller: _searchController,
        hintText: 'Search chats',
      ),
    );
  }

  Widget _buildConversationList() {
    if (_filteredConversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 64,
              color: AppColors.textTertiary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _searchController.text.isEmpty
                  ? 'No conversations yet'
                  : 'No results found',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _searchController.text.isEmpty
                  ? 'Start a new chat by tapping the + button'
                  : 'Try a different search term',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      itemCount: _filteredConversations.length,
      itemBuilder: (context, index) {
        final conversation = _filteredConversations[index];
        return ConversationTile(
          conversation: conversation,
          onTap: () => _navigateToChat(conversation),
          onLongPress: () {
            _showConversationOptions(conversation);
          },
        );
      },
    );
  }

  Widget _buildFab() {
    return FabMenu(
      items: [
        FabMenuItem(
          label: 'Chat',
          onTap: () {
            // Start new chat
            _showSnackBar('Starting new chat...');
          },
        ),
        FabMenuItem(
          label: 'Contact',
          onTap: () {
            // Add contact
            _showSnackBar('Adding contact...');
          },
        ),
        FabMenuItem(
          label: 'Group',
          onTap: () {
            // Create group
            _showSnackBar('Creating group...');
          },
        ),
        FabMenuItem(
          label: 'Broadcast',
          onTap: () {
            // Create broadcast
            _showSnackBar('Creating broadcast...');
          },
        ),
        FabMenuItem(
          label: 'Team',
          onTap: () {
            // Create team
            _showSnackBar('Creating team...');
          },
        ),
      ],
    );
  }

  void _showConversationOptions(ConversationModel conversation) {
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
                _buildOption(
                  icon: conversation.isMuted
                      ? Icons.volume_up_rounded
                      : Icons.volume_off_rounded,
                  label: conversation.isMuted ? 'Unmute' : 'Mute',
                  onTap: () {
                    Navigator.pop(context);
                    _showSnackBar(
                      conversation.isMuted
                          ? 'Notifications enabled'
                          : 'Notifications muted',
                    );
                  },
                ),
                _buildOption(
                  icon: conversation.isPinned
                      ? Icons.push_pin_outlined
                      : Icons.push_pin_rounded,
                  label: conversation.isPinned ? 'Unpin' : 'Pin',
                  onTap: () {
                    Navigator.pop(context);
                    _showSnackBar(
                      conversation.isPinned ? 'Chat unpinned' : 'Chat pinned',
                    );
                  },
                ),
                _buildOption(
                  icon: Icons.archive_outlined,
                  label: 'Archive',
                  onTap: () {
                    Navigator.pop(context);
                    _showSnackBar('Chat archived');
                  },
                ),
                _buildOption(
                  icon: Icons.delete_outline_rounded,
                  label: 'Delete',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(conversation);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.iconDefault,
      ),
      title: Text(
        label,
        style: AppTextStyles.bodyLarge.copyWith(
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showDeleteConfirmation(ConversationModel conversation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: const Text('Delete Chat'),
          content: Text(
            'Are you sure you want to delete your chat with ${conversation.displayName}?',
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
                setState(() {
                  _conversations.remove(conversation);
                  _filterConversations();
                });
                _showSnackBar('Chat deleted');
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
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
}
