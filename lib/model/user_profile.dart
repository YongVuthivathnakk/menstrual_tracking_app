class UserProfile {
  final String id;
  final DateTime lastPeriodDate;
  final int periodDuration; // 1-14 days
  final int cycleLength; // 15-60 days
  final bool isRegular;
  final int age;
  final DateTime createdAt;

  const UserProfile({
    required this. id,
    required this.lastPeriodDate,
    required this.periodDuration,
    required this.cycleLength,
    required this.isRegular,
    required this.age,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id':  id,
      'lastPeriodDate': lastPeriodDate.toIso8601String(),
      'periodDuration': periodDuration,
      'cycleLength': cycleLength,
      'isRegular': isRegular ?  1 : 0,
      'age': age,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      lastPeriodDate: DateTime. parse(json['lastPeriodDate']),
      periodDuration: json['periodDuration'],
      cycleLength: json['cycleLength'],
      isRegular: json['isRegular'] == 1,
      age:  json['age'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  String toString() {
    return 'UserProfile{id: $id, lastPeriodDate: $lastPeriodDate, periodDuration: $periodDuration, cycleLength: $cycleLength, isRegular:  $isRegular, age: $age}';
  }
}