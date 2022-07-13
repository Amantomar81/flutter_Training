import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FlutterCrud extends StatefulWidget {
  const FlutterCrud({Key? key}) : super(key: key);

  @override
  State<FlutterCrud> createState() => FlutterCrudState();
}

class FlutterCrudState extends State<FlutterCrud> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  // firebase Instance
  final firebase = FirebaseFirestore.instance;

  create() async {
    try {
      await firebase
          .collection("User")
      // .doc()
          .doc(name.text)
          .set({"name": name.text, "email": email.text});
    } catch (e) {
      print(e);
    }
    // print("Create Button Cliecked");
  }

  update() async {
    print('update call');
    try {
      await firebase.collection("User").doc(name.text).update({
        "email": email.text,
      });
    } catch (e) {
      print(e);
    }
  }

  delete() async {
    try {
      await firebase.collection("User").doc(name.text).delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crud Firebase"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            TextField(
              //keyboardType: TextInputType.number,
              controller: name,
              decoration: InputDecoration(
                  labelText: "UserName",
                  hintText: "Enter Username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              //keyboardType: TextInputType.number,
              keyboardType: TextInputType.emailAddress,
              controller: email,
              decoration: InputDecoration(
                  labelText: "Email Address",
                  hintText: "Enter Email Address",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      create();
                      name.clear();
                      email.clear();
                    },
                    child: Text(
                      "Create",
                      style: TextStyle(fontSize: 20),
                    )),
                ElevatedButton(
                    onPressed: () {
                      update();
                      name.clear();
                      email.clear();
                    },
                    child: Text(
                      "Update",
                      style: TextStyle(fontSize: 20),
                    )),
                ElevatedButton(
                    onPressed: () {
                      delete();
                      name.clear();
                      email.clear();
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(fontSize: 20),
                    )),
              ],
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              // height: 300,
              // width: double.infinity,
              child: StreamBuilder<QuerySnapshot>(
                stream: firebase.collection("User").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          QueryDocumentSnapshot x = snapshot.data!.docs[i];
                          return Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.person,
                                  size: 40,
                                ),
                                title: Text(x['name']),
                                subtitle: Text(x['email']),
                              ),
                              Divider(
                                height: 5,
                              )
                            ],
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
