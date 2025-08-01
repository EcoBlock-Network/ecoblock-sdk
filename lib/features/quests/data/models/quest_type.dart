/// Enum for quest type
enum QuestType {
  personal,
  community,
  unique,
}

extension QuestTypeExt on QuestType {
  String get name => toString().split('.').last;
  static QuestType fromString(String type) {
    switch (type) {
      case 'personal':
        return QuestType.personal;
      case 'community':
        return QuestType.community;
      case 'unique':
        return QuestType.unique;
      default:
        throw ArgumentError('Unknown quest type: $type');
    }
  }
}
