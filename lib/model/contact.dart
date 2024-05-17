class Contact{
  final int id;
  final String contactPhone;
  final String contactName;
  final String contactEmail;
  Contact({ required this.id,required this.contactPhone,required this.contactName, required this.contactEmail});



  // convert to Map
  Map<String, dynamic> toMap() => {
    "id": id,
    "name": contactName,
    "phone": contactPhone,
    "email": contactEmail,
  };
  // convert Map to Employee
  factory Contact.toContact(Map<String, dynamic> map) => Contact(
     id: map["id"],
      contactName: map["name"],
     contactPhone: map["phone"],
      contactEmail: map["email"]) ;
}
