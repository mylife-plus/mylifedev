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


  static Map<String, List<Contact>> contactsListToMap(){

    Map<String, List<Contact>> groupedContacts = {};

    for (var contact in Contact.mockContacts) {
      String firstLetter = contact.firstName[0].toUpperCase();
      if (!groupedContacts.containsKey(firstLetter)) {
        groupedContacts[firstLetter] = [];
      }
      groupedContacts[firstLetter]!.add(contact);
    }

    return groupedContacts;
  }

  static List<Contact> mockContacts = [
  Contact(
  id: 1,
  firstName: 'John',
  lastName: 'Doe',
  imageUri: 'https://picsum.photos/id/100/200',
  phone: '+1 (123) 456-7890',
  email: 'john.doe@example.com',
  website: 'https://www.johndoe.com',
  instagram: 'johndoe',
  birthdate: '1980-01-01',
  homeAddress: '123 Main St, Anytown, CA 12345',
  profession: 'Software Engineer',
  businessAddress: '555 Technology Way, Anytown, CA 12345',
  faith: 'Christianity',
  ),
  Contact(
  id: 2,
  firstName: 'Jane',
  lastName: 'Smith',
  imageUri: 'https://picsum.photos/id/101/200',
  phone: '+1 (987) 654-3210',
  email: 'jane.smith@example.com',
  website: 'https://www.jansmith.com',
  instagram: 'janesmith',
  birthdate: '1985-07-15',
  homeAddress: '456 Elm St, Anytown, CA 12345',
  profession: 'Marketing Manager',
  businessAddress: '123 Main St, Anytown, CA 12345',
  faith: 'Islam',
  ),
  Contact(
  id: 3,
  firstName: 'Mike',
  lastName: 'Lee',
  imageUri: 'https://picsum.photos/id/102/200',
  phone: '+1 (555) 123-4567',
  email: 'mike.lee@example.com',
  website: 'https://www.mikelee.com',
  instagram: 'mikelee',
  birthdate: '1990-02-22',
  homeAddress: '789 Oak St, Anytown, CA 12345',
  profession: 'Software Developer',
  businessAddress: '456 Elm St, Anytown, CA 12345',
  faith: 'Hinduism',
  ),
  Contact(
  id: 4,
  firstName: 'Sarah',
  lastName: 'Jones',
  imageUri: 'https://picsum.photos/id/103/200',
  phone: '+1 (213) 789-0123',
  email: 'sarah.jones@example.com',
  website: 'https://www.sarahjones.com',
  instagram: 'sarahjones',
  birthdate: '1975-11-09',
  homeAddress: '1011 Maple St, Anytown, CA 12345',
  profession: 'Accountant',
  businessAddress: '789 Oak St, Anytown, CA 12345',
  faith: 'Buddhism',
  ),
  Contact(
  id: 5,
  firstName: 'David',
  lastName: 'Williams',
  imageUri: 'https://picsum.photos/id/104/200',
  phone: '+1 (415) 321-6543',
  email: 'david.williams@example.com',
  website: 'https://www.davidwilliams.com',
  instagram: 'davidwilliams',
  birthdate: '1982-05-17',
  homeAddress: '1213 Poplar St, Anytown, CA 12345',
  profession: 'Teacher',
  businessAddress: '1011 Maple St, Anytown, CA 12345',
  faith: 'Judaism',
  ),
  Contact(
  id: 6,
  firstName: 'Emily',
  lastName: 'Brown',
  imageUri: 'https://picsum.photos/id/105/200',
  phone: '+1 (310) 555-1212',
  email: 'emily.brown@example.com',
  website: 'https://www.emilybrown.com',
  instagram: 'emilybrown',
  birthdate: '1992-03-10',
  homeAddress: '1415 Pine St, Anytown, CA 12345',
  profession: 'Doctor',
  businessAddress: '1213 Poplar St, Anytown, CA 12345',
  faith: 'Christianity',
  ),
  Contact(
  id: 7,
  firstName: 'Michael',
  lastName: 'Davis',
  imageUri: 'https://picsum.photos/id/106/200',
  phone: '+1 (714) 555-9876',
  email: 'michael.davis@example.com',
  website: 'https://www.michaeldavis.com',
  instagram: 'michaeldavis',
  birthdate: '1978-08-25',
  homeAddress: '1617 Spruce St, Anytown, CA 12345',
  profession: 'Lawyer',
  businessAddress: '1415 Pine St, Anytown, CA 12345',
  faith: 'Islam',
  ),
  Contact(
  id: 8,
  firstName: 'Jessica',
  lastName: 'Garcia',
  imageUri: 'https://picsum.photos/id/107/200',
  phone: '+1 (818) 555-4321',
  email: 'jessica.garcia@example.com',
  website: 'https://www.jessicagarcia.com',
  instagram: 'jessicagarcia',
  birthdate: '1987-12-18',
  homeAddress: '1819 Sycamore St, Anytown, CA 12345',
  profession: 'Designer',
  businessAddress: '161', faith: '')];


}
