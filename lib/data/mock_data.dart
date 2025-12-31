import '../models/models.dart';

class MockData {
  // Current user
  static const UserModel currentUser = UserModel(
    id: 'current_user',
    name: 'You',
    isOnline: true,
  );

  // Sample users
  static final List<UserModel> users = [
    UserModel(
      id: '1',
      name: 'Robert Fox',
      subtitle: 'Founder, nix race mega machines',
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
      isOnline: true,
    ),
    UserModel(
      id: '2',
      name: 'Marvin McKinney',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    UserModel(
      id: '3',
      name: 'Ralph Edwards',
      avatarUrl: 'https://i.pravatar.cc/150?img=13',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(days: 1)),
    ),
    UserModel(
      id: '4',
      name: 'Albert Flores',
      avatarUrl: 'https://i.pravatar.cc/150?img=14',
      isOnline: true,
    ),
    UserModel(
      id: '5',
      name: 'Guy Hawkins',
      avatarUrl: 'https://i.pravatar.cc/150?img=15',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(days: 30)),
    ),
    UserModel(
      id: '6',
      name: 'Emma Wilson',
      avatarUrl: 'https://i.pravatar.cc/150?img=16',
      isOnline: true,
    ),
    UserModel(
      id: '7',
      name: 'James Brown',
      avatarUrl: 'https://i.pravatar.cc/150?img=17',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  // Sample conversations
  static List<ConversationModel> getConversations() {
    return [
      ConversationModel(
        id: 'conv_1',
        user: users[0],
        lastMessage: MessageModel(
          id: 'm1',
          senderId: users[0].id,
          content: 'Thnx!',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          status: MessageStatus.read,
          isMe: false,
        ),
        unreadCount: 4,
      ),
      ConversationModel(
        id: 'conv_2',
        user: users[1],
        lastMessage: MessageModel(
          id: 'm2',
          senderId: users[1].id,
          content: 'Wheewhoo',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          status: MessageStatus.read,
          isMe: false,
        ),
        unreadCount: 2,
      ),
      ConversationModel(
        id: 'conv_3',
        user: users[2],
        lastMessage: MessageModel(
          id: 'm3',
          senderId: users[2].id,
          content: 'Defenetely',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          status: MessageStatus.read,
          isMe: false,
        ),
      ),
      ConversationModel(
        id: 'conv_4',
        user: users[3],
        lastMessage: MessageModel(
          id: 'm4',
          senderId: 'current_user',
          content: 'Thanks. I will reach you...',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(days: 7)),
          status: MessageStatus.delivered,
          isMe: true,
        ),
      ),
      ConversationModel(
        id: 'conv_5',
        user: users[4],
        lastMessage: MessageModel(
          id: 'm5',
          senderId: users[4].id,
          content: 'Okay',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(days: 30)),
          status: MessageStatus.read,
          isMe: false,
        ),
      ),
      ConversationModel(
        id: 'conv_6',
        user: users[5],
        lastMessage: MessageModel(
          id: 'm6',
          senderId: users[5].id,
          content: 'Voice message',
          type: MessageType.voice,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          status: MessageStatus.read,
          isMe: false,
          voiceDuration: 45,
        ),
      ),
      ConversationModel(
        id: 'conv_7',
        user: users[6],
        lastMessage: MessageModel(
          id: 'm7',
          senderId: users[6].id,
          content: 'Check out this photo!',
          type: MessageType.image,
          timestamp: DateTime.now().subtract(const Duration(hours: 8)),
          status: MessageStatus.read,
          isMe: false,
        ),
        unreadCount: 1,
      ),
    ];
  }

  // Sample messages for Robert Fox conversation
  static List<MessageModel> getRobertFoxMessages() {
    final now = DateTime.now();
    return [
      MessageModel(
        id: 'msg_1',
        senderId: 'current_user',
        content: 'Hi',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 3)),
        status: MessageStatus.read,
        isMe: true,
      ),
      MessageModel(
        id: 'msg_2',
        senderId: users[0].id,
        content: 'Hi',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 2, minutes: 55)),
        status: MessageStatus.read,
        isMe: false,
      ),
      MessageModel(
        id: 'msg_3',
        senderId: 'current_user',
        content: 'Did you review the proposal?',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 2, minutes: 50)),
        status: MessageStatus.read,
        isMe: true,
      ),
      MessageModel(
        id: 'msg_4',
        senderId: users[0].id,
        content: 'Agreed.',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 2, minutes: 40)),
        status: MessageStatus.read,
        isMe: false,
      ),
      MessageModel(
        id: 'msg_5',
        senderId: users[0].id,
        content: 'Marketing needs more funds. We should add a buffer. My team needs more training.',
        type: MessageType.text,
        timestamp: now.subtract(const Duration(hours: 2, minutes: 35)),
        status: MessageStatus.read,
        isMe: false,
      ),
      MessageModel(
        id: 'msg_6',
        senderId: users[0].id,
        content: '',
        type: MessageType.voice,
        timestamp: now.subtract(const Duration(hours: 2, minutes: 30)),
        status: MessageStatus.read,
        isMe: false,
        voiceDuration: 12,
      ),
      MessageModel(
        id: 'msg_7',
        senderId: users[0].id,
        content: '',
        type: MessageType.voice,
        timestamp: now.subtract(const Duration(hours: 2, minutes: 25)),
        status: MessageStatus.read,
        isMe: false,
        voiceDuration: 8,
      ),
    ];
  }
}
