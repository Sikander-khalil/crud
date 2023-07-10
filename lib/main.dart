import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'add_post.dart';
import 'firestore/firestore_list_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter CRUD APPLICATION',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: FireListScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});





  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

final auth = FirebaseAuth.instance;
final ref = FirebaseDatabase.instance.ref('Post');
final searchFilter = TextEditingController();
final editController = TextEditingController();
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: searchFilter,
            decoration: InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(),
            ),
            onChanged: (String value){
              setState(() {

              });
            },
          ),
        ),
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
        Expanded(
          child: FirebaseAnimatedList(
              query: ref,
              itemBuilder: (context, snapshot, animation, index){
                final title = snapshot.child('title').value.toString();
                if(searchFilter.text.isEmpty){
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(

                            child: ListTile(
                              onTap: (){

                                Navigator.pop(context);
                                showDialogue(title, snapshot.child('id').value.toString());

                  },
                          leading: Icon(Icons.edit),
                          title: Text("Edit"),
                        )),
                        PopupMenuItem(

                            child: ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                ref.child(snapshot.child('id').value.toString()).remove();

                },
                              leading: Icon(Icons.delete_outline),
                              title: Text("Delete"),
                            ))
                      ],
                    ),
                  );
                }else if(title.toLowerCase().contains(searchFilter.text.toLowerCase())){
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                  );
                }else{
                  return Container();
                }

              }),
        ),

      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: (){
        
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost()));
        
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
              ref.child(id).update({

                'title' : editController.text.toLowerCase()

              });
            }, child: Text("Update")),
          ],
        );

      }
  );

}
}
