class Ability {
  final String action;
  final String subject;

  const Ability({
    required this.action,
    required this.subject,
  });

  factory Ability.fromMap(Map<String, dynamic> map) {
    return Ability(
      action: (map['action'] as String? ?? '').toLowerCase(),
      subject: (map['subject'] as String? ?? '').toLowerCase(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'action': action,
      'subject': subject,
    };
  }

  @override
  String toString() {
    return 'Ability(action: $action, subject: $subject)';
  }
}

