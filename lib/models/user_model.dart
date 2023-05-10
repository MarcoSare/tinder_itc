class UserModel {
  String? id;
  String? name;
  String? email;
  String? pass;
  String? profilePicture;
  String? carrer;
  int? semester;
  String? aboutMe;
  List<String?>? interests;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.pass,
      this.profilePicture,
      this.carrer,
      this.semester,
      this.aboutMe,
      this.interests});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'pass': pass,
        'profile_picture': profilePicture,
        'carrer': carrer,
        'semester': semester,
        'aboutMe': aboutMe,
        'interests': interests
      };
}
