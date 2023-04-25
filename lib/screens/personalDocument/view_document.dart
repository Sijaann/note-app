import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/data/db_helper.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/app_textfield.dart';
import 'package:notes_app/utils/colors.dart';
import 'package:notes_app/utils/snachbar.dart';

class ViewDocument extends StatefulWidget {
  final int id;
  final String title;
  final String body;
  final String dueDate;
  final String dueTime;
  const ViewDocument({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    required this.dueDate,
    required this.dueTime,
  });

  @override
  State<ViewDocument> createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  getData() {
    dateInput.text = widget.dueDate;
    timeInput.text = widget.dueTime;
    titleController.text = widget.title;
    bodyController.text = widget.body;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () async {
          await DatabaseHelper.dbHelper.updateRecord({
            DatabaseHelper.notesId: widget.id,
            DatabaseHelper.notesDueDate: dateInput.text,
            DatabaseHelper.notesDueTime: timeInput.text,
            DatabaseHelper.notesTitle: titleController.text,
            DatabaseHelper.notesBody: bodyController.text,
          });
          Navigator.pop(context);
          showSnackBar(
            context: context,
            text: "Note Updated!",
            textColor: AppColors.textColor,
            backgroundColor: Colors.green,
          );
        },
        child: const Icon(
          Icons.save,
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
        title: AppText(
          text: widget.title,
          color: AppColors.textColor,
          weight: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                barrierColor: AppColors.backgroundColor.withOpacity(0.5),
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
                                  BorderRadiusDirectional.circular(10),
                            ),
                            onTap: () async {
                              await DatabaseHelper.dbHelper
                                  .deleteRecord(widget.id);

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
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: AppTextField(
                            hide: false,
                            radius: 10,
                            readOnly: true,
                            hintText: "Due Date",
                            labelText: "Due Date",
                            controller: dateInput,
                            iconButton: IconButton(
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025),
                                );
                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);

                                  setState(() {
                                    dateInput.text = formattedDate;
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: AppTextField(
                            hide: false,
                            radius: 10,
                            hintText: "Due Time",
                            labelText: "Due Time",
                            readOnly: true,
                            controller: timeInput,
                            iconButton: IconButton(
                              onPressed: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );

                                if (pickedTime != null) {
                                  DateTime parsedTime = DateFormat.jm().parse(
                                    pickedTime.format(context).toString(),
                                  );
                                  String formattedTime =
                                      DateFormat('HH:mm').format(parsedTime);
                                  // print(parsedTime);
                                  setState(() {
                                    timeInput.text = formattedTime;
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.timer,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AppTextField(
                        controller: titleController,
                        hide: false,
                        radius: 10,
                        hintText: "Title",
                        labelText: "Title",
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: AppTextField(
                        maxLines: 30,
                        controller: bodyController,
                        hide: false,
                        radius: 10,
                        hintText: "Body",
                        labelText: "Body",
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: AppText(
                        text: "Attachments",
                        color: AppColors.textColor,
                        weight: FontWeight.bold,
                        size: 23,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_photo_alternate_rounded,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
