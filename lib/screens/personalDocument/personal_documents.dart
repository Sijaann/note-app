import 'package:flutter/material.dart';
import 'package:notes_app/data/db_helper.dart';
import 'package:notes_app/screens/personalDocument/add_notes.dart';
import 'package:notes_app/screens/personalDocument/view_document.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/colors.dart';
import 'package:notes_app/utils/snachbar.dart';

class PersonalDocuments extends StatefulWidget {
  const PersonalDocuments({super.key});

  @override
  State<PersonalDocuments> createState() => _PersonalDocumentsState();
}

class _PersonalDocumentsState extends State<PersonalDocuments> {
  List<Map<String, dynamic>> data = [];

  getData() async {
    dynamic val = await DatabaseHelper.dbHelper.readRecord();
    setState(() {
      data = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNotes(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: AppColors.textColor,
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const AppText(
          text: "Personal Documents",
          color: AppColors.textColor,
          weight: FontWeight.w500,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return (data.isNotEmpty)
                ? Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      onLongPress: () {
                        showModalBottomSheet(
                          barrierColor:
                              AppColors.backgroundColor.withOpacity(0.5),
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 70,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                          10,
                                        ),
                                      ),
                                      onLongPress: () async {
                                        await DatabaseHelper.dbHelper
                                            .deleteRecord(data[index]['id']);

                                        Navigator.pop(context);
                                        Navigator.pop(context);

                                        showSnackBar(
                                          context: context,
                                          text: "Note Deleted!",
                                          textColor: AppColors.textColor,
                                          backgroundColor: Colors.red,
                                        );
                                      },
                                      dense: true,
                                      leading: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      title: const AppText(
                                        text: "Delete",
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      onTap: () {
                        print(data);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViewDocument(
                              id: data[index]["id"],
                              title: data[index]["title"],
                              body: data[index]["body"],
                              dueDate: data[index]["dueDate"],
                              dueTime: data[index]["dueTime"],
                            ),
                          ),
                        );
                      },
                      title: AppText(
                        text: data[index]["title"],
                        color: AppColors.textColor,
                        size: 16,
                        maxLines: 1,
                      ),

                      // subtitle: (data[index]["body"].length) < 40
                      //     ? Text(data[index]['body'])
                      //     : Text('${data[index]["body"]}'.substring(0, 40)),
                      subtitle: AppText(
                        text:
                            "${data[index]['dueDate']} | ${data[index]['dueTime']}",
                        color: AppColors.hintTextColor,
                        size: 16,
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          await DatabaseHelper.dbHelper
                              .deleteRecord(data[index]['id']);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Text("No Data Found"),
                  );
          },
        ),
      ),
    );
  }
}
