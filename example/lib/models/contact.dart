class Contact {
  final int id;
  final String firstName;
  final String lastName;
  final String imageUri;
  final String phone;
  final String email;
  final String website;
  final String instagram;
  final String birthdate;
  final String homeAddress;
  final String profession;
  final String businessAddress;
  final String faith;

  Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.imageUri,
    required this.phone,
    required this.email,
    required this.website,
    required this.instagram,
    required this.birthdate,
    required this.homeAddress,
    required this.profession,
    required this.businessAddress,
    required this.faith,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: (map['id'] as int?) ?? 0,
      firstName: (map['firstName'] as String?) ?? '',
      lastName: (map['lastName'] as String?) ?? '',
      imageUri: (map['imageUri'] as String?) ?? '',
      phone: (map['phone'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      website: (map['website'] as String?) ?? '',
      instagram: (map['instagram'] as String?) ?? '',
      birthdate: (map['birthdate'] as String?) ?? '',
      homeAddress: (map['homeAddress'] as String?) ?? '',
      profession: (map['profession'] as String?) ?? '',
      businessAddress: (map['businessAddress'] as String?) ?? '',
      faith: (map['faith'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'imageUri': imageUri,
      'phone': phone,
      'email': email,
      'website': website,
      'instagram': instagram,
      'birthdate': birthdate,
      'homeAddress': homeAddress,
      'profession': profession,
      'businessAddress': businessAddress,
      'faith': faith,
    };
  }
}
