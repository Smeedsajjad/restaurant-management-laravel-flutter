class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  String? token;
  String? name;
  String? email;

  void setUser(Map<String, dynamic> userData, String userToken) {
    name = userData['name'];
    email = userData['email'];
    token = userToken;
  }

  void clear() {
    name = null;
    email = null;
    token = null;
  }
}
