
class StudentCSV{
  String studentName;
  String InstructorId;
  String StudentEmail;
  String InstructingGroup;
  String InstructorEmail;
  String StudentRegistrationNumber;

  StudentCSV({
    required this.InstructorId,
    required this.StudentEmail,
    required this.StudentRegistrationNumber,
    required this.studentName,
    required this.InstructingGroup,
    required this.InstructorEmail
  });

  Map<String, dynamic> toMap() {
    return {
      'InstructorId': InstructorId,
      'StudentEmail': StudentEmail,
      'StudentRegistrationNumber': StudentRegistrationNumber,
      'studentName': studentName,
      'InstructingGroup': InstructingGroup,
      'InstructorEmail': InstructorEmail
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
      studentName: map['studentName'],
      InstructingGroup: map['InstructingGroup'],
      InstructorEmail: map['InstructorEmail']
    );
  }

  factory StudentCSV.fromDS(String id, Map<String, dynamic> data) {
    return StudentCSV(
      InstructorId: data['InstructorId'],
      StudentEmail: data['StudentEmail'],
      StudentRegistrationNumber: data['StudentRegistrationNumber'],
      studentName: data['studentName'],
      InstructingGroup: data['InstructingGroup'],
      InstructorEmail: data['InstructorEmail']
    );
  }

  getFromCSV(String csv) {
    List<String> elements = csv.split(',');
    InstructorId = elements[0];
    StudentEmail = elements[1];
    StudentRegistrationNumber = elements[2];
  }
}