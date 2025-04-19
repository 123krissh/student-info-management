class Student {
  final int id;
  final String name;
  final String roll;
  final String email;
  final String department;
  final String year;

  Student({
    required this.id,
    required this.name,
    required this.roll,
    required this.email,
    required this.department,
    required this.year,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      roll: json['roll'],
      email: json['email'],
      department: json['department'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'roll': roll,
      'email': email,
      'department': department,
      'year': year,
    };
  }
}
