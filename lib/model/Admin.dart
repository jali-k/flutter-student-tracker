class Admin{
  String email;
  String password;
  String uid;

  Admin({required this.email, required this.password, required this.uid});

  toList() {
    return [email, password, uid];
  }
}