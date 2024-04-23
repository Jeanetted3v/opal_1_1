class UserModel {
  final String userName;
  final String uid;
  final String? profilePic;
  final bool isOnline;
  final String? company;
  final String? userCountry;
  final String? userCity;
  final String aboutMe;
  final List<String> userTags;
  final List<String> lookingForTags;

  UserModel(
      {required this.userName,
      required this.uid,
      this.profilePic,
      required this.isOnline,
      this.company,
      this.userCountry,
      this.userCity,
      required this.aboutMe,
      required this.userTags,
      required this.lookingForTags});

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'userCountry': userCountry,
      'userCity': userCity,
      'company': company,
      'aboutMe': aboutMe,
      'userTags': userTags,
      'lookingForTags': lookingForTags,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userName: map['userName'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'],
      isOnline: map['isOnline'] ?? false,
      company: map['company'],
      userCountry: map['userCountry'],
      userCity: map['userCity'],
      aboutMe: map['aboutMe'] ?? '',
      userTags: List<String>.from(map['userTags'] ?? []),
      lookingForTags: List<String>.from(map['lookingForTags'] ?? []),
    );
  }
}