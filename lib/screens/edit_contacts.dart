import 'package:contact_book/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../database.dart';

import 'homepage.dart';

final _formkey = GlobalKey<FormState>();

class EditContacts extends StatefulWidget {
  final MyDatabase myDatabase;
  const EditContacts(
      {super.key, required this.contact, required this.myDatabase});
  final Contact contact;
  @override
  State<EditContacts> createState() => _EditContactsState();
}

class _EditContactsState extends State<EditContacts> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // String? validateEmail(String? email)
  // {
  //   RegExp emailRegex=RegExp( "[-!\$%^&*()_+|~=`{}\\[\\]:;'<>?,.\\/\"]");
  //
  //   final isEmailValid=emailRegex.hasMatch(email??'');
  //   if(!isEmailValid){
  //     'please enter a valid email';
  //   }
  //   return null;
  // }
  @override
  Widget build(BuildContext context) {
    idController.text = '${widget.contact.id}';
    nameController.text = widget.contact.contactName;
    phoneController.text = widget.contact.contactPhone;
    emailController.text = widget.contact.contactEmail;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Contacts'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: nameController,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                        hintText: 'Contact name', border: OutlineInputBorder()),
                    validator: (value) => value!.length < 3
                        ? 'name should be at least three characters!'
                        : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  focusNode: _focusNode,
                  controller: idController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'id', border: OutlineInputBorder()),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  focusNode: _focusNode,
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Phone number', border: OutlineInputBorder()),
                  validator: (value) => value!.length < 11
                      ? 'phone number should not be less than 11 digits!'
                      : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: emailController,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                        hintText: 'Email', border: OutlineInputBorder()),
                    validator: (value) {
                      if (!EmailValidator.validate(value!)) {
                        return 'please enter a valid email';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          Contact contact = Contact(
                              id: int.parse(idController.text),
                              contactName: nameController.text,
                              contactPhone: phoneController.text,
                              contactEmail: emailController.text);
                          await widget.myDatabase.updateContact(contact);

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.orange,
                                content:
                                    Text('${contact.contactName} updated.')));
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                                (route) => false);
                          }
                          //
                        },
                        child: const Text('Edit')),
                    ElevatedButton(
                        onPressed: () {
                          nameController.text = '';
                          phoneController.text = '';
                          emailController.text = '';
                          setState(() {
                            _focusNode.requestFocus();
                          });
                        },
                        child: const Text('Reset'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
