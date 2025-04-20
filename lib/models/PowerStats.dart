class PowerStats {
  final int intelligence;
  final int strength;
  final int speed;
  final int durability;
  final int power;
  final int combat;

  PowerStats({
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
  });

  factory PowerStats.fromJson(Map<String, dynamic> json) {
    return PowerStats(
      intelligence: int.tryParse(json['intelligence']) ?? 0,
      strength: int.tryParse(json['strength']) ?? 0,
      speed: int.tryParse(json['speed']) ?? 0,
      durability: int.tryParse(json['durability']) ?? 0,
      power: int.tryParse(json['power']) ?? 0,
      combat: int.tryParse(json['combat']) ?? 0,
    );
  }

  int totalScore() => intelligence + strength + speed + durability + power + combat;

  Map<String, int> toMap() {
    return {
      'intelligence': intelligence,
      'strength': strength,
      'speed': speed,
      'durability': durability,
      'power': power,
      'combat': combat,
    };
  }
}
