class OpalModel {
  final String userName;
  final String uid;
  final String opalTitle;
  final String opalId;
  final List<String>? opalPics;
  final bool isOnline;
  final String? country;
  final String? city;
  final String aboutOpal;
  final List<String> industry;
  final List<String> sellingOrBuying;
  final List<String> opalTags;

  OpalModel({
    required this.userName,
    required this.uid,
    required this.opalTitle,
    required this.opalId,
    this.opalPics,
    required this.isOnline,
    this.country,
    this.city,
    required this.aboutOpal,
    required this.industry,
    required this.sellingOrBuying,
    required this.opalTags,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'uid': uid,
      'opalTitle': opalTitle,
      'opalId': opalId,
      'opalPics': opalPics,
      'isOnline': isOnline,
      'country': country,
      'city': city,
      'aboutOpal': aboutOpal,
      'industry': industry,
      'sellingOrBuying': sellingOrBuying,
      'opalTags': opalTags,
    };
  }

  factory OpalModel.fromMap(Map<String, dynamic> map) {
    return OpalModel(
      userName: map['userName'] ?? '',
      uid: map['uid'] ?? '',
      opalTitle: map['opalTitle'] ?? '',
      opalId: map['opalId'] ?? '',
      opalPics: map['opalPics'] != null ? List<String>.from(map['opalPics']) : null,
      isOnline: map['isOnline'] ?? false,
      country: map['country'],
      city: map['city'],
      aboutOpal: map['aboutOpal'] ?? '',
      industry: List<String>.from(map['industry'] ?? []),
      sellingOrBuying: List<String>.from(map['sellingOrBuying'] ?? []),
      opalTags: List<String>.from(map['opalTags'] ?? []),
    );
  }
}

List<OpalModel> opalList = [
  OpalModel(
    userName: 'Jeanette',
    uid: '12345',
    opalTitle: 'Looking for Franchisees for F&B business in Malaysia',
    opalId: '78910',
    opalPics: [
      'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      'https://images.unsplash.com/photo-1537047902294-62a40c20a6ae?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
      'https://images.unsplash.com/photo-1424847651672-bf20a4b0982b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      'https://images.unsplash.com/photo-1566704284379-0d6fdf3d229c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80',
      'https://images.unsplash.com/photo-1595842296100-56a63f34c54a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      'https://images.unsplash.com/photo-1566703720034-2ceca93dec48?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80',
      'https://images.unsplash.com/photo-1653286017704-6f60b21df20c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=627&q=80',
      'https://images.unsplash.com/photo-1653291339794-f2c51991e532?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=627&q=80',
      'https://images.unsplash.com/photo-1660924770215-b88137c974dd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=627&q=80',
    ],
    isOnline: true,
    country: 'Malaysia',
    city: 'Kular Lumpar',
    aboutOpal:
        'We are a western food business, specializing in chicken wings. We are looking for franchisees for Vietnam, Cambodia market',
    industry: ['F&B'],
    sellingOrBuying: ['selling'],
    opalTags: [
      'Franchise',
      'Vietnam',
      'Cambodia',
      'F&B',
      'Western Food',
      'Mid-tier',
      'Partnership'
    ],
  ),
  OpalModel(
    userName: 'John',
    uid: '67890',
    opalTitle: 'Lookng for Buyers',
    opalId: '78910',
    opalPics: [
      'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      'https://images.unsplash.com/photo-1603558431750-dfa36513aee6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
      'https://images.unsplash.com/photo-1556012018-50c5c0da73bf?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    ],
    isOnline: false,
    country: 'Vietnam',
    city: 'Ho Chi Minh City',
    aboutOpal:
        'We operates a few toy factors in Vietnam, able to produce soft toys, lego-like toys, barbie dolls, etc. Looking for buyers including Brand principals to work with.',
    industry: ['Manufacturing'],
    sellingOrBuying: ['Selling'],
    opalTags: ['OEM', 'White-label', 'Seeking Buyers'],
  ),
  // Add more OpalModel objects with fake data as needed
];