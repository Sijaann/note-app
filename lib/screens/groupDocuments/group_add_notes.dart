import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/utils/app_button.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/app_textfield.dart';
import 'package:notes_app/utils/colors.dart';
import 'package:notes_app/utils/labled_checkbox.dart';
import 'package:notes_app/utils/pickImage.dart';
import 'package:notes_app/utils/snachbar.dart';

class GroupNotesAdd extends StatefulWidget {
  const GroupNotesAdd({super.key});

  @override
  State<GroupNotesAdd> createState() => _GroupNotesAddState();
}

class _GroupNotesAddState extends State<GroupNotesAdd> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController dateInput = TextEditingController();
  final TextEditingController timeInput = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController collaboratorEmailController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, bool>> tasks = [];
  List collaborators = [];

  List<File> images = [];

  DateTime? dueDate = DateTime.now();

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
      }
      // debugPrint(base64Strings[0]);
    } catch (e) {
      print(e.toString());
    }
  }

  void addDocument() async {
    try {
      DateTime? dueDatee = dueDate;
      String? dueTime = timeInput.text;
      String title = titleController.text;
      String? body = bodyController.text;
      List? attachments = base64Strings;
      List? task = tasks;
      List collaboratorss = [user!.uid];

      DocumentReference newDocReference =
          await FirebaseFirestore.instance.collection('notes').add({
        'dueDate': dueDatee,
        'dueTime': dueTime,
        'title': title,
        'body': body,
        'attachments': attachments,
        'tasks': task,
        'collaborators': collaboratorss,
        'isImportant': false
      });

      String newDoumentId = newDocReference.id;
      await newDocReference.update({'noteId': newDoumentId}).then((value) {
        Navigator.pop(context);
        showSnackBar(
          context: context,
          text: "Note Added Successfully!",
          textColor: AppColors.textColor,
          backgroundColor: Colors.green,
        );
      });

      DocumentReference requestDocReference =
          await FirebaseFirestore.instance.collection('requests').add({
        'noteID': newDoumentId,
        'requestBy': user!.email,
        'collaborators': collaborators,
      });

      String newRequestId = requestDocReference.id;
      await requestDocReference
          .update({'requestId': newRequestId}).then((value) {
        showSnackBar(
          context: context,
          text: "Collaborators Notified!",
          textColor: AppColors.textColor,
          backgroundColor: AppColors.primaryColor,
        );
      });
    } on FirebaseException catch (error) {
      showSnackBar(
        context: context,
        text: error.toString(),
        textColor: AppColors.textColor,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> addCollaborator({required String collaboratorEmail}) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: collaboratorEmail)
          .get();

      if (querySnapshot.size > 0) {
        DocumentSnapshot userDocument = querySnapshot.docs[0];
        String collaboratorId = userDocument.id;

        if (collaboratorId == user!.uid) {
          Navigator.pop(context);
          Navigator.pop(context);
          showSnackBar(
            context: context,
            text: "Can not add yourself as collaborator!",
            textColor: AppColors.textColor,
            backgroundColor: Colors.red,
          );
        } else {
          if (collaborators.contains(collaboratorId)) {
            Navigator.pop(context);
            Navigator.pop(context);
            showSnackBar(
              context: context,
              text: "The user is already a collaborator",
              textColor: AppColors.textColor,
              backgroundColor: Colors.amber,
            );
          } else {
            collaborators.add(collaboratorId);
            Navigator.pop(context);
            Navigator.pop(context);
            showSnackBar(
              context: context,
              text: "User found. Save Document to add collaborator",
              textColor: AppColors.textColor,
              backgroundColor: AppColors.primaryColor,
            );
          }
        }

        print(collaboratorId);
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        showSnackBar(
          context: context,
          text: "No user found with email $collaboratorEmail",
          textColor: AppColors.textColor,
          backgroundColor: Colors.red,
        );
      }
    } on FirebaseException catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dateInput.dispose();
    timeInput.dispose();
    titleController.dispose();
    bodyController.dispose();
    taskController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          addDocument();
        },
        child: const Icon(
          Icons.add,
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
          text: "Add Note",
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
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const AppText(
                                    text: "Add Collaborator",
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
                                      controller: collaboratorEmailController,
                                      decoration: const InputDecoration(
                                        hintText: "Email",
                                        labelText: "Email",
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
                                          addCollaborator(
                                            collaboratorEmail:
                                                collaboratorEmailController
                                                    .text,
                                          );
                                          collaboratorEmailController.clear();
                                          print(collaborators);
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
                                dueDate = pickedDate;
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
                              Map<String, bool> map = tasks[index];
                              String key = map.keys.first;
                              bool value = map[key]!;

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
                                      horizontal: 8.0),
                                  value: value,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      // isSelected = newValue;
                                      map[key] = newValue;
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
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Image.file(
                            images[index],
                            fit: BoxFit.contain,
                          ),
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
      // body: Column(
      //   children: [
      //     const AppText(
      //       text: "Tasks",
      //       color: AppColors.textColor,
      //     ),
      //     LabeledCheckbox(
      //       label: 'This is the label text',
      //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
      //       value: _isSelected,
      //       onChanged: (bool newValue) {
      //         setState(() {
      //           _isSelected = newValue;
      //         });
      //       },
      //     )
      //   ],
      // ),
    );
  }
}
