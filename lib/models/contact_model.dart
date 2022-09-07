class ContactModel {
  int? id;
  String name;
  String phone;
  String? email;
  String? company;
  String? address;
  String? website;
  String? numberType;
  String? emailType;
  String? image;

  ContactModel(
      {this.id,
      required this.name,
      required this.phone,
      this.email,
      this.company,
      this.address,
      this.website,
      this.numberType,
      this.emailType,
      this.image});

  factory ContactModel.fromJson(Map<String, dynamic> map) => ContactModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      company: map['company']['name'],
      address: map['address']['city'],
      website: map['website'],
      numberType: 'Mobile',
      emailType: 'Work',
      image: 'https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg');

  Map<String, dynamic> toJson() => {
        'name': name,
        'username': name,
        'phone': phone,
        'email': email,
        'company': {'name': company, 'catchPhrase': company, 'bs': company},
        'address': {
          'street': address,
          'suite': address,
          'city': address,
          'zipcode': address,
          'geo': {'lat': address, 'lng': address}
        },
        'website': website,
      };
}
