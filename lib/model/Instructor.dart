class Instructor{
  String email;
  String id;
  String instructorId;
  String password;
  bool temporaryPassword = true;

  Instructor({
    required this.email,
    required this.id,
    required this.instructorId,
    required this.password,
    this.temporaryPassword = true
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'id': id,
      'instructorId': instructorId,
      'password': password,
      'temporaryPassword': temporaryPassword,
    };
  }

  @override
  String toString() {
    return 'Instructor{email: $email, id: $id, instructorId: $instructorId, password: $password, temporaryPassword: $temporaryPassword}';
  }

  factory Instructor.fromMap(Map<String, dynamic> map) {
    return Instructor(
      email: map['email'],
      id: map['id'],
      instructorId: map['instructorId'],
      password: map['password'],
      temporaryPassword: map['temporaryPassword']
    );
  }

  factory Instructor.fromDS(String id, Map<String, dynamic> data) {
    return Instructor(
      email: data['email'],
      id: id,
      instructorId: data['instructorId'],
      password: data['password'],
      temporaryPassword: data['temporaryPassword']
    );
  }
}
