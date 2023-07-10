import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFirestorePost extends StatefulWidget {
  const AddFirestorePost({super.key});

  @override
  State<AddFirestorePost> createState() => _AddFirestorePostState();
}

class _AddFirestorePostState extends State<AddFirestorePost> {

  final postcontroller = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('user');

  //final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add FireStore Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            TextFormField(
              controller: postcontroller,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: 'What is your mind?',
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (){

             String id = DateTime.now().millisecondsSinceEpoch.toString();
             fireStore.doc(id).set({

               'title' : postcontroller.text.toString(),
               'id' : id

             });




            }, child: Text("Add"))

          ],

        ),
      ),
    );
  }
}
