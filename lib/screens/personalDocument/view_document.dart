import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/data/db_helper.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/app_textfield.dart';
import 'package:notes_app/utils/colors.dart';
import 'package:notes_app/utils/pickImage.dart';
import 'package:notes_app/utils/snachbar.dart';

class ViewDocument extends StatefulWidget {
  final int id;
  final String title;
  final String body;
  final String dueDate;
  final String dueTime;
  final String? image;
  final int important;
  const ViewDocument({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    required this.dueDate,
    required this.dueTime,
    required this.image,
    required this.important,
  });

  @override
  State<ViewDocument> createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  bool removeImage = false;

  getData() {
    dateInput.text = widget.dueDate;
    timeInput.text = widget.dueTime;
    titleController.text = widget.title;
    bodyController.text = widget.body;
  }

  List<File> images = [];

  void selectImage() async {
    var res = await pickImage();
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
          if (widget.image != null) {
            if (removeImage == false) {
              if (images.isNotEmpty) {
                await DatabaseHelper.dbHelper.updateRecord({
                  DatabaseHelper.notesId: widget.id,
                  DatabaseHelper.notesDueDate: dateInput.text,
                  DatabaseHelper.notesDueTime: timeInput.text,
                  DatabaseHelper.notesTitle: titleController.text,
                  DatabaseHelper.notesBody: bodyController.text,
                  DatabaseHelper.imageAttachment: base64Strings[0],
                  DatabaseHelper.isImportant: widget.important,
                });
              }
            } else {
              await DatabaseHelper.dbHelper.updateRecord({
                DatabaseHelper.notesId: widget.id,
                DatabaseHelper.notesDueDate: dateInput.text,
                DatabaseHelper.notesDueTime: timeInput.text,
                DatabaseHelper.notesTitle: titleController.text,
                DatabaseHelper.notesBody: bodyController.text,
                DatabaseHelper.imageAttachment: null,
                DatabaseHelper.isImportant: widget.important,
              });
            }
          }
          if (widget.image == null) {
            if (images.isNotEmpty) {
              await DatabaseHelper.dbHelper.updateRecord({
                DatabaseHelper.notesId: widget.id,
                DatabaseHelper.notesDueDate: dateInput.text,
                DatabaseHelper.notesDueTime: timeInput.text,
                DatabaseHelper.notesTitle: titleController.text,
                DatabaseHelper.notesBody: bodyController.text,
                DatabaseHelper.imageAttachment: base64Strings[0],
                DatabaseHelper.isImportant: widget.important,
              });
            } else {
              await DatabaseHelper.dbHelper.updateRecord({
                DatabaseHelper.notesId: widget.id,
                DatabaseHelper.notesDueDate: dateInput.text,
                DatabaseHelper.notesDueTime: timeInput.text,
                DatabaseHelper.notesTitle: titleController.text,
                DatabaseHelper.notesBody: bodyController.text,
                DatabaseHelper.isImportant: widget.important,
              });
            }
          }
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
                    height: 125,
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
                              Navigator.pop(context);
                              Navigator.pop(context);

                              await DatabaseHelper.dbHelper
                                  .deleteRecord(widget.id);

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
                              weight: FontWeight.w500,
                              color: AppColors.textColor,
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
                              weight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          )
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
                    ),
                    (widget.image != null)
                        ? (removeImage == false)
                            ? (images.isEmpty)
                                ? Card(
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.memory(
                                            base64Decode(widget.image!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  removeImage = true;
                                                });
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: AppColors
                                                    .hintTextColor
                                                    .withOpacity(0.8),
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
                                    ),
                                  )
                                : ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: images.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: Stack(
                                          children: [
                                            Image.file(
                                              images[index],
                                              // height: 250,
                                              // width: double.infinity,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      images.removeAt(0);
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
                                                      color:
                                                          AppColors.textColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Stack(
                                      children: [
                                        Image.file(
                                          images[index],
                                          // height: 250,
                                          // width: double.infinity,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  images.removeAt(0);
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
                                    ),
                                  );
                                },
                              )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Stack(
                                  children: [
                                    Image.file(
                                      images[index],
                                      // height: 250,
                                      // width: double.infinity,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              images.removeAt(0);
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
    );
  }
}
