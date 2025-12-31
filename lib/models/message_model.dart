enum MessageType { text, voice, image, video, document, location }

enum MessageStatus { sending, sent, delivered, read, failed }

class MessageModel {
  final String id;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final MessageStatus status;
  final bool isMe;
  final int? voiceDuration; // in seconds for voice messages
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String? fileName;
  final int? fileSize;
  final MessageModel? replyTo;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.status,
    required this.isMe,
    this.voiceDuration,
    this.mediaUrl,
    this.thumbnailUrl,
    this.fileName,
    this.fileSize,
    this.replyTo,
  });

  String get timeString {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String get voiceDurationString {
    if (voiceDuration == null) return '0:00';
    final minutes = voiceDuration! ~/ 60;
    final seconds = (voiceDuration! % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    MessageStatus? status,
    bool? isMe,
    int? voiceDuration,
    String? mediaUrl,
    String? thumbnailUrl,
    String? fileName,
    int? fileSize,
    MessageModel? replyTo,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      isMe: isMe ?? this.isMe,
      voiceDuration: voiceDuration ?? this.voiceDuration,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      replyTo: replyTo ?? this.replyTo,
    );
  }
}
