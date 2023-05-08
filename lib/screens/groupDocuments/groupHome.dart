import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/screens/groupDocuments/group_add_notes.dart';
import 'package:notes_app/screens/groupDocuments/view_document.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/colors.dart';
import 'package:notes_app/utils/snachbar.dart';

class GroupHome extends StatefulWidget {
  const GroupHome({super.key});

  @override
  State<GroupHome> createState() => _GroupHomeState();
}

class _GroupHomeState extends State<GroupHome> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<String> fliterType = [
    "All",
    "Weekly",
    "Monthly",
    "Yearly",
  ];
  String filterTypeValue = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GroupNotesAdd(),
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
          text: "Collaborations",
          color: AppColors.textColor,
          weight: FontWeight.w500,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .where('collaborators', arrayContains: user!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: AppText(
                text: "Something went wrong",
                color: AppColors.primaryColor,
                weight: FontWeight.w500,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<Card> notesTile = snapshot.data!.docs
              .map(
                (DocumentSnapshot document) => Card(
                  elevation: 2,
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
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('notes')
                                          .doc(document['noteId'])
                                          .delete()
                                          .then((value) {
                                        Navigator.pop(context);
                                        showSnackBar(
                                          context: context,
                                          text: "Document Deleted",
                                          textColor: AppColors.textColor,
                                          backgroundColor: Colors.red,
                                        );
                                      });
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewDocument(
                            collaborators: document['collaborators'],
                            id: document['noteId'],
                            dueDate: document['dueDate'],
                            dueTime: document['dueTime'],
                            title: document['title'],
                            body: document['body'],
                            images: document['attachments'],
                            tasks: document['tasks'],
                          ),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: AppText(
                      text: "${document['title']}",
                      color: AppColors.textColor,
                      weight: FontWeight.w500,
                      size: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: AppText(
                      text:
                          "${DateFormat('yyyy-MM-dd').format(document['dueDate'].toDate())} | ${document['dueTime']}",
                      color: AppColors.hintTextColor,
                      size: 15,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('notes')
                            .doc(document['noteId'])
                            .update(
                          {'isImportant': !document['isImportant']},
                        );
                      },
                      icon: (document['isImportant'] == false)
                          ? const Icon(
                              Icons.star_outline_rounded,
                              color: AppColors.hintTextColor,
                            )
                          : const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                            ),
                    ),
                  ),
                ),
              )
              .toList();

          return (notesTile.isEmpty)
              ? const Center(
                  child: AppText(
                    text: "No Documents Available",
                    color: AppColors.primaryColor,
                    weight: FontWeight.w500,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppText(
                            text: "Filter by dute date",
                            color: AppColors.primaryColor,
                            weight: FontWeight.bold,
                            size: 18,
                          ),
                          SizedBox(
                            width: 150,
                            child: DropdownButton(
                              borderRadius: BorderRadius.circular(10),
                              isExpanded: true,
                              value: filterTypeValue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: fliterType.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: AppText(
                                    text: item,
                                    color: AppColors.textColor,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  filterTypeValue = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: notesTile.length,
                        itemBuilder: (context, index) {
                          return notesTile[index];
                        },
                      ),
                    ],
                  ));
        },
      ),
    );
  }
}
