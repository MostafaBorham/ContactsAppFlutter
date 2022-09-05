class ContactModel {
  String name;
  String number;
  String? email;
  String? company;
  String? address;
  String? relationship;
  String? numberType;
  String? emailType;
  String? image;

  ContactModel(
      {required this.name,
      required this.number,
      this.email,
      this.company,
      this.address,
      this.relationship,
      this.numberType,
      this.emailType,
      this.image});

  factory ContactModel.fromJson(Map<String, dynamic> map) => ContactModel(
      name: map['name'],
      number: map['number'],
      email: map[' email'],
      company: map[' company'],
      address: map[' address'],
      relationship: map[' relationship'],
      numberType: map[' numberType'],
      emailType: map[' emailType'],
      image: map[' image']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'email': email,
        'company': company,
        'address': address,
        'relationship': relationship,
        'numberType': numberType,
        'emailType': emailType,
        'image': image
      };
}
