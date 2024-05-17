import 'package:contact_book/database.dart';
import 'package:contact_book/screens/add_contacts.dart';
import 'package:contact_book/screens/edit_contacts.dart';
import 'package:flutter/material.dart';

import '../model/contact.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Contact> contacts = List.empty(growable: true);
  final MyDatabase _myDatabase=MyDatabase();
 int count =0;


  Future<void>_refresh(){
    return Future.delayed(Duration(seconds: 2));
  }


 getDatafromDb ()async{
 await  _myDatabase.initializeDatabase();
 List<Map<String, Object?>> map = await _myDatabase.getContactList();
 for (int i = 0; i < map.length; i++) {
   contacts.add(Contact.toContact(map[i]));
 }
 count =await _myDatabase.countContact();
 setState(() {
   isLoading=false;
 });
 }
  @override
  void initState() {
   getDatafromDb();
    // contacts.add(Contact(
    //   id:1,
    //     contactPhone: '0123456789',
    //     contactName: 'Mona',
    //     contactEmail: 'Mona@gmail.com'));
    // contacts.add(Contact(
    //     contactPhone: '0124456689',
    //     contactName: 'Menna',
    //     contactEmail: 'Menna@gmail.com', id: 2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ):contacts.isEmpty
          ? const Center(
        child: Text('No contacts yet'),
      )
          : RefreshIndicator(
        onRefresh: _refresh,
            child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) => Card(child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditContacts(contact:contacts[index] ,  myDatabase: _myDatabase,)));
                  },
                  leading: const CircleAvatar(child: Icon(Icons.person),),
                  title:Text(contacts[index].contactName),
                  subtitle: Text(contacts[index].contactPhone),
                  trailing: IconButton(onPressed: ()async {

      String empName = contacts[index].contactName;
      await _myDatabase.deleteContact(contacts[index]);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('$empName deleted.')));
        Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
                  (route) => false);
      }
      //

                  },icon: const Icon(Icons.delete)),

                ))),
          ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  AddContacts(myDatabase: _myDatabase,)));
        },
      ),
    );
  }
}
