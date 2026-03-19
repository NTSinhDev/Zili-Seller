/// Collaborator Model - Payment method collaborator
class Collaborator {
  final String id;
  final String name;
  final dynamic code;
  final dynamic phone;
  final dynamic status;
  final dynamic types;

  Collaborator({
    required this.id,
    required this.name,
    required this.code,
    required this.phone,
    this.status,
    this.types,
  });

  factory Collaborator.fromMap(Map<String, dynamic> map) => Collaborator(
    id: map['id']?.toString() ?? '',
    name: map['fullName'] ?? '',
    code: map['code'] ?? '',
    phone: map['phone'] ?? '',
    status: map['status'],
    types: map['types'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'code': code,
    'phone': phone,
    'status': status,
    'type': types,
  };
}
