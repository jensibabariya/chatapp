import 'package:chatapp/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login_page(),
  ));
}

class Login_page extends StatefulWidget {
  static SharedPreferences? pref;

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  bool temp = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {
    Login_page.pref = await SharedPreferences.getInstance();

    temp = Login_page.pref!.getBool("login") ?? false;
    if (temp == true) {
      Future.delayed(Duration.zero)
          .then((value) => Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return View("${name.text}", "${contact.text}");
                },
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Login here",
        ),
        backgroundColor: Colors.indigo[900],
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Text(
            "Name",textAlign: TextAlign.start,
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          )),
          Container(margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(6)),
            child: TextField(
              textAlign: TextAlign.center,
              controller: name,
              decoration: InputDecoration(hintText: "Enter your name"),
            ),
          ),
          Container(margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Text(textAlign: TextAlign.start,
            "Contact",
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          )),
          Container(margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(6)),
            child: TextField(
              textAlign: TextAlign.center,
              controller: contact,
              decoration: InputDecoration(hintText: "Enter your contact"),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                DatabaseReference ref =
                    FirebaseDatabase.instance.ref("users").push();

                await ref.set({
                  "name": "${name.text}",
                  "contact": "${contact.text}",
                });
                Login_page.pref!.setBool("login", true);
                Login_page.pref!.setString("check", name.text);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return View("${name.text}", "${contact.text}");
                  },
                ));
                setState(() {});
              },
              child: Text("ADD"))
        ],
      ),
    ));
  }
}
