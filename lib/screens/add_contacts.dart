import 'package:contact_book/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import '../database.dart';
import 'homepage.dart';

final _formkey = GlobalKey<FormState>();

class AddContacts extends StatefulWidget {
  final MyDatabase myDatabase;
  const AddContacts({super.key, required this.myDatabase});

  @override
  State<AddContacts> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Contacts'), centerTitle: true),
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

                    autovalidateMode: AutovalidateMode.onUserInteraction),
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
                    autovalidateMode: AutovalidateMode.onUserInteraction),
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
                              contactPhone: phoneController.text,
                              contactName: nameController.text,
                              contactEmail: emailController.text);
                          await widget.myDatabase.insertContact(contact);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content:
                                    Text('${contact.contactName} added.')));
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                                (route) => false);
                          }

                          //
                        },
                        child: const Text('Add')),
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
