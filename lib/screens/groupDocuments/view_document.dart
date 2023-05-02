import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/app_textfield.dart';
import 'package:notes_app/utils/colors.dart';
import 'package:notes_app/utils/labled_checkbox.dart';
import 'package:notes_app/utils/pickImage.dart';
import 'package:notes_app/utils/snachbar.dart';

class ViewDocument extends StatefulWidget {
  final String id;
  final String dueDate;
  final String dueTime;
  final String title;
  final String body;
  final List images;
  final List tasks;
  final List collaborators;
  const ViewDocument({
    super.key,
    required this.dueDate,
    required this.dueTime,
    required this.title,
    required this.body,
    required this.images,
    required this.tasks,
    required this.id,
    required this.collaborators,
  });

  @override
  State<ViewDocument> createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {
  final TextEditingController dateInput = TextEditingController();
  final TextEditingController timeInput = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List collaborators = [];

  List tasks = [];
  List<File> images = [];

  List attachments = [];

  void setData() {
    dateInput.text = widget.dueDate;
    timeInput.text = widget.dueTime;
    titleController.text = widget.title;
    bodyController.text = widget.body;
    attachments = widget.images;
    tasks = widget.tasks;
    collaborators = widget.collaborators;
  }

  void selectImage() async {
    var res = await pickMultiImage();
    setState(() {
      images = res!;
    });

    // print(images);
    openImage();
  }

  List<String> imagePaths = [];
  List<File> imageFiles = [];
  List<Uint8List> imageBytes = [];
  List<String> base64Strings = [];

  openImage() async {
    try {
      for (int i = 0; i < images.length; i++) {
        imagePaths.add(images[i].toString().substring(6));
        // print(i);
      }
      // print(imagePaths);

      for (String path in imagePaths) {
        int pathLength = path.length;
        imageFiles.add(
          File(
            path.substring(2, pathLength - 1),
          ),
        );
        // print(imageFiles);
      }

      for (File file in imageFiles) {
        // Uint8List imgByte = await file.readAsBytes();
        imageBytes.add(await file.readAsBytes());
      }
      // print(imageBytes);

      for (Uint8List imgByte in imageBytes) {
        base64Strings.add(base64Encode(imgByte));
        setState(() {
          attachments.add(base64Encode(imgByte));
        });
      }
      // debugPrint(base64Strings[0]);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateDocument({
    required BuildContext context,
    required dynamic noteId,
  }) async {
    try {
      return FirebaseFirestore.instance.collection('notes').doc(noteId).update({
        'dueDate': dateInput.text,
        'dueTime': timeInput.text,
        'title': titleController.text,
        'body': bodyController.text,
        'attachments': attachments,
        'tasks': [],
        'collaborators': collaborators,
      }).then((value) {
        FirebaseFirestore.instance.collection("notes").doc(noteId).update({
          'tasks': FieldValue.arrayUnion(tasks),
        }).then((value) {
          print(tasks);
        });
        // print(tasks);
        Navigator.pop(context);
        showSnackBar(
          context: context,
          text: "Document Updated",
          textColor: AppColors.textColor,
          backgroundColor: Colors.green,
        );
      });
    } on FirebaseException catch (error) {
      debugPrint(
        error.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setData();
    // print(taskss);
    print(attachments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          updateDocument(context: context, noteId: widget.id);
        },
        child: const Icon(
          Icons.save,
          color: AppColors.textColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const AppText(
          text: "Collaborative Document",
          color: AppColors.textColor,
          weight: FontWeight.w500,
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
                    height: 250,
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
                            onTap: () {
                              // selectImage();
                              // Navigator.pop(context);
                            },
                            leading: const Icon(
                              Icons.person_add,
                              color: Colors.yellow,
                            ),
                            title: const AppText(
                              text: "Add Collaborator",
                              size: 16,
                              color: AppColors.textColor,
                              weight: FontWeight.w500,
                            ),
                          ),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(10),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const AppText(
                                    text: "Add Text",
                                    color: AppColors.textColor,
                                  ),
                                  content: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Field cannot be empty";
                                        }
                                      },
                                      controller: taskController,
                                      decoration: const InputDecoration(
                                        hintText: "Task",
                                        labelText: "Task",
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const AppText(
                                        text: "Cancel",
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            tasks.add(
                                                {taskController.text: false});
                                          });
                                          taskController.clear();
                                          Navigator.pop(context);
                                          Navigator.pop(context);

                                          showSnackBar(
                                            context: context,
                                            text: "Task Added",
                                            textColor: AppColors.textColor,
                                            backgroundColor:
                                                AppColors.primaryColor,
                                          );
                                        }
                                      },
                                      child: const AppText(
                                        text: "Add",
                                        color: AppColors.primaryColor,
                                        weight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            leading: const Icon(
                              Icons.checklist_rounded,
                              color: AppColors.primaryColor,
                            ),
                            title: const AppText(
                              text: "Add Tasks",
                              size: 16,
                              color: AppColors.textColor,
                              weight: FontWeight.w500,
                            ),
                          ),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(10),
                            ),
                            onTap: () {
                              selectImage();
                              Navigator.pop(context);
                            },
                            leading: const Icon(
                              Icons.add_photo_alternate_rounded,
                              color: Colors.green,
                            ),
                            title: const AppText(
                              text: "Add Image",
                              size: 16,
                              color: AppColors.textColor,
                              weight: FontWeight.w500,
                            ),
                          ),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(10),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);

                              showSnackBar(
                                context: context,
                                text: "Note Discarded!",
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
                              text: "Discard",
                              color: AppColors.textColor,
                              size: 16,
                              weight: FontWeight.w500,
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
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                        text: "Tasks",
                        color: AppColors.textColor,
                        weight: FontWeight.bold,
                        size: 23,
                      ),
                    ),
                    (tasks.isNotEmpty)
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              String key = tasks[index].keys.first;
                              bool value = tasks[index][key]!;
                              return InkWell(
                                onLongPress: () {
                                  showModalBottomSheet(
                                    barrierColor: AppColors.backgroundColor
                                        .withOpacity(0.5),
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
                                                      BorderRadiusDirectional
                                                          .circular(
                                                    10,
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    tasks.removeAt(index);
                                                  });
                                                  Navigator.pop(context);
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
                                child: LabeledCheckbox(
                                  label: key,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  value: value,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      // isSelected = newValue;
                                      tasks[index][key] = newValue;
                                    });
                                  },
                                ),
                              );
                            },
                          )
                        : const SizedBox(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: AppText(
                        text: "Attachments",
                        color: AppColors.textColor,
                        weight: FontWeight.bold,
                        size: 23,
                      ),
                    ),
                    (attachments.isEmpty)
                        ? const SizedBox()
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: attachments.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Card(
                                    child: Image.memory(
                                      base64Decode(attachments[index]),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            attachments.removeAt(index);
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: AppColors
                                              .hintTextColor
                                              .withOpacity(0.8)
                                              .withOpacity(0.5),
                                          radius: 10,
                                          child: const AppText(
                                            text: "X",
                                            size: 15,
                                            weight: FontWeight.bold,
                                            color: AppColors.textColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
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
                    onPressed: () => selectImage(),
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
