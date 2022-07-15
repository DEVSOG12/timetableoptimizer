import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:timetableoptimizer/models/room.dart';
import 'package:timetableoptimizer/models/room_type.dart';

import '../models/subject.dart';
import '../models/teachers.dart';

class Teachers extends StatefulWidget {
  const Teachers({Key? key}) : super(key: key);

  @override
  State<Teachers> createState() => _RoomsState();
}

class _RoomsState extends State<Teachers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                Hive.deleteBoxFromDisk("teachers");
                // Box<dynamic> s = await Hive.openBox("teachers");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Removing Data on teachers")));
                // s.clear();
              },
              icon: Icon(Icons.clear))
        ],
        title: const Text("Teachers Details"),
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
          children: const [
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   child: ListView.builder(
            //       itemCount: s.length,
            //       itemBuilder: (context, i) {
            //         return ListTile(
            //           leading: s.values
            //                   .toList()[i]["roomname"]
            //                   .toString()
            //                   .contains("Roo")
            //               ? const CircleAvatar(child: Text("R"))
            //               : const CircleAvatar(child: Text("L")),
            //           title: Text(
            //             s.values.toList()[i]["roomname"],
            //           ),
            //           subtitle:
            //               Text((s.values.toList()[i]["roomnumber"]).toString()),
            //         );
            //         // return Text(s.values.toList()[i]["roomname"]);
            //       }),
            // )
          ],
        ),
      ),
    );
  }

  show() {
    return WidgetsBinding.instance.addPostFrameCallback((_) async {
      Box<dynamic> s = await Hive.openBox("teachers");
      Box<dynamic> m = await Hive.openBox("subjects");

      log("Hello ${s.values.toList()}");

      showDialog(
          context: context,
          builder: (_) {
            TextEditingController teachername = TextEditingController();
            TextEditingController teacherlevel = TextEditingController();
            final List<Subject> _selectedItems = [];

            String type = "classroom";
            return ScaffoldMessenger(
              child: StatefulBuilder(builder: (context, setState) {
                void _itemChange(Subject itemValue, bool isSelected) {
                  setState(() {
                    if (isSelected) {
                      _selectedItems.add(itemValue);
                      log(_selectedItems.toString());
                    } else {
                      _selectedItems.removeWhere((element) =>
                          element.subjectname == itemValue.subjectname);
                      log("${_selectedItems}Remove");
                    }
                  });
                }

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
                            hintText: "Enter Name of Teacher",
                          ),
                          controller: teachername,
                          onChanged: (x) => setState((() => log("reload"))),
                        ),
                        TextFormField(
                          onChanged: (x) => setState((() => log("reload"))),
                          decoration: const InputDecoration(
                            hintText:
                                "Enter Teacher Level. e.g. It should be 1 or 2.",
                          ),
                          controller: teacherlevel,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Select Subject Teacher will teach"),
                        SingleChildScrollView(
                            child: ListBody(
                                children: m.values
                                    .where((element) {
                                      log("1st ${m.values}");
                                      log("2st ${element.toString()}");
                                      if (s.values.isEmpty) {
                                        return true;
                                      }
                                      return s.values.any((m) {
                                        log("3rd ${m["subjects"]}");
                                        return (m["subjects"] as List<dynamic>)
                                            .any((mi) {
                                          log(mi.subjectname!);
                                          return !(mi.subjectname ==
                                              element["subjectname"]);
                                        });
                                      });
                                    })
                                    .map((e) => CheckboxListTile(
                                        value: _selectedItems.any((element) =>
                                            element.subjectname ==
                                            e["subjectname"]),
                                        title: Text(e["subjectname"]),
                                        onChanged: (isM) => _itemChange(
                                            Subject.fromMap(
                                                Map<String, dynamic>.from(e)),
                                            isM!)))
                                    .toList())),
                        // CupertinoButton(
                        //     child: const Text("Validiate"),
                        //     onPressed: () async {
                        //       // final rooms = await Hive.openBox("rooms");

                        //       setState((() => log("reload")));
                        //       if (roomnumber.text.isNotEmpty &&
                        //           !int.parse(roomnumber.text).isNaN &&
                        //           roomname.text.isNotEmpty &&
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
                              if (teacherlevel.text.isNotEmpty &&
                                  !int.parse(teacherlevel.text).isNaN &&
                                  teachername.text.isNotEmpty &&
                                  type.isNotEmpty) {
                                Map results = Teacher().toMap(
                                    int.parse(teacherlevel.text),
                                    _selectedItems,
                                    teachername.text);

                                s.add(results);
                                log("${s.values}Hello");
                                // // Map results = Room().toMap(
                                // //     int.parse(roomnumber.text),
                                // //     roomname.text,
                                // //     type == "classroom"
                                // //         ? RoomType(true)
                                // //         : RoomType(false));
                                // log("Results$results");
                                // final teachers = await Hive.openBox("teachers");
                                // if (teachers.values.any((element) =>
                                //     element["teachername"] ==
                                //     results["teachername"])) {
                                //   log("Results$results");

                                //   // ScaffoldMessenger.of(context).showSnackBar(
                                //   //     const SnackBar(
                                //   //         content: const Text(
                                //   //             "Data is Present in the Database")));
                                // } else {
                                // log(teachers.values.toString());

                                // teachers.add(results).then((value) =>
                                //     log(teachers.values.toString()));
                              }
                              // Navigator.pop(context);
                              // } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: const Text("Not Valid! ")));
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
