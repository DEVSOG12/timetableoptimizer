import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:timetableoptimizer/models/room.dart';
import 'package:timetableoptimizer/models/room_type.dart';

class Rooms extends StatefulWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  late Box<dynamic> s = load();
  @override
  void initState() {
    super.initState();
  }

  load() async {
    s = await Hive.openBox("rooms");
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Removing Data on rooms")));
                s.clear();
              },
              icon: Icon(Icons.clear))
        ],
        title: const Text("Rooms Details"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => show(),
        child: const Icon(Icons.add),
      ),
      // body: [0,1,2,2].forEach((element) {
      //   return Text('')
      // }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: s.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: s.values
                              .toList()[i]["roomname"]
                              .toString()
                              .contains("Roo")
                          ? const CircleAvatar(child: Text("R"))
                          : const CircleAvatar(child: Text("L")),
                      title: Text(
                        s.values.toList()[i]["roomname"],
                      ),
                      subtitle:
                          Text((s.values.toList()[i]["roomnumber"]).toString()),
                    );
                    // return Text(s.values.toList()[i]["roomname"]);
                  }),
            )
          ],
        ),
      ),
    );
  }

  show() {
    return WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (_) {
            TextEditingController roomname = TextEditingController();
            TextEditingController roomnumber = TextEditingController();
            String type = "classroom";
            return ScaffoldMessenger(
              child: StatefulBuilder(builder: (context, setState) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: Dialog(
                        child: Container(
                            child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Enter Name of Room",
                          ),
                          controller: roomname,
                          onChanged: (x) => setState((() => log("reload"))),
                        ),
                        TextFormField(
                          onChanged: (x) => setState((() => log("reload"))),
                          decoration: const InputDecoration(
                            hintText:
                                "Enter Number of Room. e.g. if it's a lab enter 99",
                          ),
                          controller: roomnumber,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("The type of the room"),
                        ListTile(
                          title: const Text("Classroom"),
                          leading: Radio(
                            value: "classroom",
                            groupValue: type,
                            onChanged: (m) {
                              setState(() {
                                type = m.toString();
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Lab"),
                          leading: Radio(
                            value: "lab",
                            groupValue: type,
                            onChanged: (m) {
                              setState(() {
                                type = m.toString();
                              });
                            },
                          ),
                        ),
                        Column(
                          children: [
                            Text("Room Name: ${roomname.text}"),
                            Text("Room Number: ${roomnumber.text}"),
                            Text("Room Type: ${type}")
                          ],
                        ),
                        CupertinoButton(
                            child: const Text("Validiate"),
                            onPressed: () async {
                              // final rooms = await Hive.openBox("rooms");

                              setState((() => log("reload")));
                              if (roomnumber.text.isNotEmpty &&
                                  !int.parse(roomnumber.text).isNaN &&
                                  roomname.text.isNotEmpty &&
                                  type.isNotEmpty) {
                                log("valid");
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: const Text("Valid! ")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: const Text("Not Valid! ")));
                              }
                            }),
                        CupertinoButton(
                            child: const Text("Add"),
                            onPressed: () async {
                              setState((() => log("reload")));
                              if (roomnumber.text.isNotEmpty &&
                                  !int.parse(roomnumber.text).isNaN &&
                                  roomname.text.isNotEmpty &&
                                  type.isNotEmpty) {
                                Map results = Room().toMap(
                                    int.parse(roomnumber.text),
                                    roomname.text,
                                    type == "classroom"
                                        ? RoomType(true)
                                        : RoomType(false));
                                log(results.toString());
                                final rooms = await Hive.openBox("rooms");
                                if (rooms.values.any((element) =>
                                    element["roomname"] ==
                                    results["roomname"])) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: const Text(
                                              "Data is Present in the Database")));
                                } else {
                                  rooms.add(results);
                                }
                                log(rooms.values.toString());
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: const Text("Not Valid! ")));
                              }
                            })
                      ],
                    ))),
                  ),
                );
              }),
            );
          });
    });
  }
}
