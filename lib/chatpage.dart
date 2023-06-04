import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chatpage extends StatefulWidget {
  String? sender;
  String? receiver;

  Chatpage(this.sender, this.receiver);

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  List key = [];
  List value = [];
  List sorted = [];
  TextEditingController msg = TextEditingController();
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('chat');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.receiver}",
        ),

      ),
      body: Column(
        children: [
          Text("${widget.sender}"),
          Expanded(
            child: StreamBuilder(
              stream: starCountRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final data = snapshot.data!.snapshot.value;
                  Map m = data as Map;
                  key = m.keys.toList();
                  value = m.values.toList();
                  sorted = [];
                  value.forEach((element) {
                    if ((widget.receiver == element["receiver"] &&
                        widget.sender == element["sender"])) {
                      sorted.add(element);
                    }
                  });

                  for (int i = 0; i < sorted.length - 1; i++) {
                    for (int j = 0; j < sorted.length - i - 1; j++) {
                      if (int.parse(sorted[j]['time']) >
                          int.parse(sorted[j + 1]['time'])) {
                        // Swap elements

                        var temp = sorted[j]['time'];
                        sorted[j]['time'] = sorted[j + 1]['time'];
                        sorted[j + 1]['time'] = temp;
                      }
                    }
                  }

                  value.sort((a, b) =>
                      int.parse(a['time']).compareTo(int.parse(b['time'])));
                  print("sorted ${sorted}");

                  return ListView.builder(
                    itemCount: sorted.length,
                    itemBuilder: (context, index) {
                      return (widget.receiver == value[index]['receiver'])
                          ? Card(
                              child: ListTile(
                                trailing: Text("${sorted[index]['massage']}"
                                    "${value[index]['time']}"),
                                // subtitle: Text("${value[index]['time']}"),
                              ),
                            )
                          : Card(
                              child: ListTile(
                                leading: Text("${sorted[index]['massage']}"
                                    "${value[index]['time']}"),
                                // subtitle: Text("${value[index]['time']}"),
                              ),
                            );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Card(
                child: TextField(
                  decoration: InputDecoration(hintText: "Enter your massage"),
                  controller: msg,
                ),
              )),
              IconButton(
                  onPressed: () async {
                    String time = DateFormat.Hms().format(DateTime.now());
                    DatabaseReference ref =
                        FirebaseDatabase.instance.ref("chat").push();

                    await ref.set({
                      "massage": "${msg.text}",
                      "sender": "${widget.sender}",
                      "receiver": "${widget.receiver}",
                      "time": "${DateTime.now().second}",
                    });
                    msg.text = "";
                    print("time: ${DateTime.now().second}");
                  },
                  icon: Icon(Icons.send)),
            ],
          ),
        ],
      ),
    );
  }
}
