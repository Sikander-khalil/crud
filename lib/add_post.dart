import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  final postcontroller = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
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

              String id  = DateTime.now().millisecondsSinceEpoch.toString();

              databaseRef.child(id).set({
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
