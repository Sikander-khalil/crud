import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../add_post.dart';
import 'add_firestor_screen.dart';

class FireListScreen extends StatefulWidget {
  const FireListScreen({super.key});

  @override
  State<FireListScreen> createState() => _FireListScreenState();
}

class _FireListScreenState extends State<FireListScreen> {

  final auth = FirebaseAuth.instance;
 // final ref = FirebaseDatabase.instance.ref('Post');
 // final searchFilter = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('user').snapshots();

  final editController = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('user');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,

        title: Center(child: Text("CRUD",style: TextStyle(color: Colors.white),)),


      ),
      body: Column(
        children: [
          SizedBox(height: 10,),

          /*Expanded(child: StreamBuilder(
          stream: ref.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }else{
              Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
              List<dynamic> list = [];
              list.clear();
              list = map.values.toList();
              return ListView.builder(
                  itemCount: snapshot.data!.snapshot.children.length,
                  itemBuilder: (context, index){

                return ListTile(
                  title: Text(list[index]['title']),
                );

              });
            }

          },
        )),*/
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){

                  return CircularProgressIndicator();
                }

                     return Expanded(

    child: ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index){

          return ListTile(
            onTap: (){
              ref.doc(snapshot.data!.docs[index]['title'].toString()).update({

                'title' : 'Sikander'
              });
             // ref.doc(snapshot.data!.docs[index]['title'].toString()).delete();
            },
            title: Text(snapshot.data!.docs[index]['title'].toString()),
          );
        })
);
          }),


        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          Navigator.push(context, MaterialPageRoute(builder: (context) => AddFirestorePost()));

        },
        child: Icon(Icons.add),
      ),

    );
  }
  Future<void> showDialogue(String title, String id)async{
    editController.text = title;
    return showDialog(
        context: context,
        builder:(BuildContext dialogContext){
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextFormField(
                controller: editController,
                decoration: InputDecoration(
                    hintText: "Edit"
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),
              TextButton(onPressed: (){
                Navigator.pop(context);

              }, child: Text("Update")),
            ],
          );

        }
    );

  }
}
