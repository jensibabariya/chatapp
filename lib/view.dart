import 'package:chatapp/chatpage.dart';
import 'package:chatapp/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class View extends StatefulWidget {
  String? user;
  String? user_num;

  View([this.user, this.user_num]);

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  List key = [];
  List value = [];
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('users');
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.user=Login_page.pref!.getString("check")??"";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Login_page.pref!.setBool("login", false);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Login_page();
                  },
                ));
              },
              icon: Icon(Icons.logout_rounded))
        ],
        title: Text("${widget.user!}"),
      ),
      body: StreamBuilder(
        stream: starCountRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final data = snapshot.data!.snapshot.value;
            Map m = data as Map;
            key = m.keys.toList();
            value = m.values.toList();

            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return (widget.user!=value[index]['name'])?Card(
                    child: InkWell(onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) {
                       return Chatpage("${widget.user}","${value[index]['name']}");
                     },));
                    },
                      child: ListTile(
                      title: Text("${value[index]['name']}"),
                subtitle: Text("${value[index]['contact']}"),
                ),
                    ),):Text("");

              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
