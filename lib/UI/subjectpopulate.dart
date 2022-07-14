import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:timetableoptimizer/models/room.dart';
import 'package:timetableoptimizer/models/room_type.dart';
import 'package:timetableoptimizer/models/subject.dart';

class Subjects extends StatefulWidget {
  const Subjects({Key? key}) : super(key: key);

  @override
  State<Subjects> createState() => _RoomsState();
}

class _RoomsState extends State<Subjects> {
  late Box<dynamic> s;
  late Box<dynamic> m;
  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    s = await Hive.openBox("subjects");
    m = await Hive.openBox("rooms");
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
                    SnackBar(content: Text("Removing Data on subjects")));
                s.clear();
              },
              icon: Icon(Icons.clear))
        ],
        title: const Text("Subjects Details"),
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
                              .toList()[i]["subjects"]
                              .toString()
                              .contains("Roo")
                          ? const CircleAvatar(child: Text("R"))
                          : const CircleAvatar(child: Text("L")),
                      title: Text(
                        s.values.toList()[i]["subjectname"],
                      ),
                      subtitle: Text(
                          (s.values.toList()[i]["subjectclass"]).toString()),
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
            TextEditingController subjectname = TextEditingController();
            TextEditingController subjectclass = TextEditingController();
            // TextEditingController subjectclass = TextEditingController();
            TextEditingController strength = TextEditingController();
            String type = "Room 1";
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
                            hintText: "Enter Name of the Subject",
                          ),
                          controller: subjectname,
                          onChanged: (x) => setState((() => log("reload"))),
                        ),
                        TextFormField(
                          onChanged: (x) => setState((() => log("reload"))),
                          decoration: const InputDecoration(
                            hintText: "Enter Grade Level of Subject",
                          ),
                          controller: subjectclass,
                        ),
                        TextFormField(
                          onChanged: (x) => setState((() => log("reload"))),
                          decoration: const InputDecoration(
                            hintText:
                                "Enter Strength Level of Subject. Between 1 and 2. 1 for normal 2 for compluslory*",
                          ),
                          controller: strength,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("The Preferred Room"),
                        Container(
                          height: MediaQuery.of(context).size.height * .5,
                          child: ListView.builder(
                              itemCount: m.length,
                              itemBuilder: (context, i) {
                                return ListTile(
                                  leading: Radio(
                                    value: m.values.toList()[i]["roomname"]
                                        as String,
                                    groupValue: type,
                                    onChanged: (m) {
                                      setState(() {
                                        type = m.toString();
                                      });
                                    },
                                  ),
                                  title: Text(
                                    m.values.toList()[i]["roomname"],
                                  ),
                                  subtitle: Text((m.values.toList()[i]
                                          ["roomnumber"])
                                      .toString()),
                                );
                                // return Text(s.values.toList()[i]["roomname"]);
                              }),
                        ),
                        // ListTile(
                        //   title: const Text("Classroom"),
                        //   leading: Radio(
                        //     value: "classroom",
                        //     groupValue: type,
                        //     onChanged: (m) {
                        //       setState(() {
                        //         type = m.toString();
                        //       });
                        //     },
                        //   ),
                        // ),
                        // Column(
                        //   children: [
                        //     Text("Subject Name: ${subjectname.text}"),
                        //     Text("Subject Class: ${subjectclass.text}"),
                        //     Text("Preferred Room Type: $type")
                        //   ],
                        // ),
                        // CupertinoButton(
                        //     child: const Text("Validiate"),
                        //     onPressed: () async {
                        //       // final subjects = await Hive.openBox("subjects");

                        //       setState((() => log("reload")));
                        //       if (subjectclass.text.isNotEmpty &&
                        //           !int.parse(subjectclass.text).isNaN &&
                        //           subjectname.text.isNotEmpty &&
                        //           strength.text.isNotEmpty &&
                        //           type.isNotEmpty) {
                        //         log("valid");
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(
                        //                 content: const Text("Valid! ")));
                        //       } else {
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(
                        //                 content: const Text("Not Valid! ")));
                        //       }
                        //     }),
                        CupertinoButton(
                            child: const Text("Add"),
                            onPressed: () async {
                              setState((() => log("reload")));
                              if (subjectclass.text.isNotEmpty &&
                                  !int.parse(subjectclass.text).isNaN &&
                                  subjectname.text.isNotEmpty &&
                                  type.isNotEmpty) {
                                Map results = Subject().toMap(
                                    subjectname.text,
                                    int.parse(subjectclass.text),
                                    int.parse(strength.text),
                                    type == "classroom"
                                        ? RoomType(true)
                                        : RoomType(false));

                                log(results.toString());
                                final subjects = await Hive.openBox("subjects");
                                if (subjects.values.any((element) =>
                                    element["roomname"] ==
                                    results["roomname"])) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: const Text(
                                              "Data is Present in the Database")));
                                } else {
                                  subjects.add(results);
                                }
                                log(subjects.values.toString());
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
