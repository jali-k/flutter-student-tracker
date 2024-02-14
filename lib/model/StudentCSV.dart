
class StudentCSV{
  String InstructorId;
  String StudentEmail;
  String StudentRegistrationNumber;

  StudentCSV({required this.InstructorId, required this.StudentEmail, required this.StudentRegistrationNumber});

  Map<String, dynamic> toMap() {
    return {
      'InstructorId': InstructorId,
      'StudentEmail': StudentEmail,
      'StudentRegistrationNumber': StudentRegistrationNumber,
    };
  }

  @override
  String toString() {
    return 'StudentCSV{InstructorId: $InstructorId, StudentEmail: $StudentEmail, StudentRegistrationNumber: $StudentRegistrationNumber}';
  }

  factory StudentCSV.fromMap(Map<String, dynamic> map) {
    return StudentCSV(
      InstructorId: map['InstructorId'],
      StudentEmail: map['StudentEmail'],
      StudentRegistrationNumber: map['StudentRegistrationNumber'],
    );
  }

  factory StudentCSV.fromDS(String id, Map<String, dynamic> data) {
    return StudentCSV(
      InstructorId: data['InstructorId'],
      StudentEmail: data['StudentEmail'],
      StudentRegistrationNumber: data['StudentRegistrationNumber'],
    );
  }

  getFromCSV(String csv) {
    List<String> elements = csv.split(',');
    InstructorId = elements[0];
    StudentEmail = elements[1];
    StudentRegistrationNumber = elements[2];
  }
}