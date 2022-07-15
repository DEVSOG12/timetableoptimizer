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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _pullRefresh() async {
      // List<WordPair> freshWords = await WordDataSource().getFutureWords(delay: 2);
      setState(() {
        // words = freshWords;
      });
      // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                Box<dynamic> s = await Hive.openBox("subjects");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Removing Data on subjects")));
                s.clear();
              },
              icon: Icon(Icons.clear)),
          IconButton(onPressed: _pullRefresh, icon: Icon(Icons.refresh))
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
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder(
                    future: Hive.openBox("subjects"),
                    builder: (context, AsyncSnapshot<Box<dynamic>> sa) {
                      if (sa.connectionState == ConnectionState.done) {
                        final Box<dynamic> s = sa.data!;
                        s.values.toList().sort(((a, b) =>
                            (a["subjectclass"] as int)
                                .compareTo(b["subjectclass"])));
                        // log(s.data as );
                        return ListView.builder(
                            itemCount: s.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                leading: CircleAvatar(
                                    child: Text(s.values
                                        .toList()[i]["subjectname"]
                                        .toString()[0])),
                                title: Text(
                                  s.values.toList()[i]["subjectname"],
                                ),
                                subtitle: Text((s.values.toList()[i]
                                        ["subjectclass"])
                                    .toString()),
                              );
                              // return Text(s.values.toList()[i]["roomname"]);
                            });
                      }
                      return Container(
                        width: 0.0,
                        height: 0.0,
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  show() {
    return WidgetsBinding.instance.addPostFrameCallback((_) async {
      Box<dynamic> m = await Hive.openBox("rooms");
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
                        //                 content: cons

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
                                Map results = Subject(
                                  type == "classroom"
                                      ? RoomType(true)
                                      : RoomType(false),
                                  int.parse(strength.text),
                                  int.parse(subjectclass.text),
                                  subjectname.text,
                                ).toMap();

                                log(results.toString());
                                final subjects = await Hive.openBox("subjects");
                                if (subjects.values.any((element) =>
                                    element["subjectname"] ==
                                    results["subjectname"])) {
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
