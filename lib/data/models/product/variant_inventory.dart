import 'dart:convert';

class VariantInventory {
  final int id;
  final String locationId;
  final int onHandling;
  final int available;
  final int committed;
  final int incoming;
  VariantInventory({
    required this.id,
    required this.locationId,
    required this.onHandling,
    required this.available,
    required this.committed,
    required this.incoming,
  });

  VariantInventory copyWith({
    int? id,
    String? locationId,
    int? onHandling,
    int? available,
    int? committed,
    int? incoming,
  }) {
    return VariantInventory(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      onHandling: onHandling ?? this.onHandling,
      available: available ?? this.available,
      committed: committed ?? this.committed,
      incoming: incoming ?? this.incoming,
    );
  }

  factory VariantInventory.fromMap(Map<String, dynamic> map) {
    return VariantInventory(
      id: map['id'] as int,
      locationId: map['location_id'] as String,
      onHandling: int.parse(map['on_hand'] ?? "0"),
      available: int.parse(map['available'] ?? "0"),
      committed: int.parse(map['committed'] ?? "0"),
      incoming: int.parse(map['incoming'] ?? "0"),
    );
  }

  factory VariantInventory.fromJson(String source) =>
      VariantInventory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VariantInventory(id: $id, location_id: $locationId, onHandling: $onHandling, available: $available, committed: $committed, incoming: $incoming)';
  }

  @override
  bool operator ==(covariant VariantInventory other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.locationId == locationId &&
        other.onHandling == onHandling &&
        other.available == available &&
        other.committed == committed &&
        other.incoming == incoming;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        locationId.hashCode ^
        onHandling.hashCode ^
        available.hashCode ^
        committed.hashCode ^
        incoming.hashCode;
  }
}
