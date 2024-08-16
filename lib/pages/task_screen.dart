import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_app/config.dart';
import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/models/user_model.dart';
import 'package:flutter_task_app/providers/new_task_provider.dart';
import 'package:flutter_task_app/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Untuk format tanggal

class CreateTaskPage extends StatefulWidget {
  final TaskModel? task;
  const CreateTaskPage({super.key, this.task});

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final nameFocus = FocusNode();
  final descriptionFocus = FocusNode();
  DateTime? _startDate;
  DateTime? _endDate;
  List<UserModel> _selectedMembers = [];

  final List<String> _categories = [
    'Design',
    'Development',
    'Research',
  ];
  String? _selectedCategory = 'Design';
  final List<String> _priorities = ['Low', 'Medium', 'High']; // Daftar priority
  String? _selectedPriority;

  void _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null &&
        pickedDate != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.task != null) {
      _nameController.text = widget.task!.name;
      _descriptionController.text = widget.task!.description;
      _selectedCategory = widget.task!.category;
      _selectedPriority = widget.task!.priority;
      _startDate = DateTime.parse(widget.task!.startDate.toIso8601String());
      _endDate = DateTime.parse(widget.task!.endDate.toIso8601String());
      _selectedMembers = widget.task!.members;
      log(_selectedMembers.length.toString());
      setState(() {});
    }
  }

  void showMemberSelection() async {
    final List<UserModel>? selectedMembers = await showDialog<List<UserModel>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: true);
        return AlertDialog(
          title: Text('Select Members'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: userProvider.newUsers.map((member) {
                    final isSelected =
                        //  _selectedMembers.contains(member);
                        _selectedMembers
                            .any((element) => element.id == member.id);

                    log(isSelected.toString(), name: member.name!);
                    return ListTile(
                      title: Text(
                        member.name!,
                        style: font,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isSelected ? Colors.deepPurple : null,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isSelected) {
                              // _selectedMembers.remove(member);
                              _selectedMembers.removeWhere(
                                (element) => element.id == member.id,
                              );
                            } else {
                              // if (!_selectedMembers.contains(member)) {
                              _selectedMembers.add(member);
                              // _selectedMembers.add(member);
                              // }
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_selectedMembers);
              },
              child: Text(
                'OK',
                style: font,
              ),
            ),
          ],
        );
      },
    );

    if (selectedMembers != null) {
      setState(() {
        _selectedMembers = selectedMembers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(
          widget.task == null ? 'Create Task' : 'Detail Task',
          style: font.copyWith(),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (widget.task != null)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Confirm Delete',
                        style: font,
                      ),
                      content: Text(
                        'Are you sure you want to delete this task?',
                        style: font,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: font,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<NewTaskProvider>(context, listen: false)
                                .deleteTask(widget.task!.id!);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Delete',
                            style: font,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete_rounded),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          nameFocus.unfocus();
          descriptionFocus.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name Field
                  TextFormField(
                    focusNode: nameFocus,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      labelStyle: font.copyWith(fontWeight: FontWeight.bold),
                      hintText: 'Masukkan Task Name',
                      border: const OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Category',
                    style: font.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _selectedCategory == category
                              ? ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple),
                                  child: Text(
                                    category,
                                    style: font,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  },
                                  child: Text(
                                    category,
                                    style: font,
                                  ),
                                ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (_selectedCategory ==
                      null) // Pesan error jika kategori belum dipilih
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Please select a category',
                          style: font.copyWith(color: Colors.red)),
                    ),
                  const SizedBox(height: 16),

                  // Members Selection
                  Text(
                    'Members',
                    style: font.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      if (_selectedMembers.isNotEmpty) ...[
                        if (_selectedMembers.length > 2)
                          Row(
                            children: [
                              ..._selectedMembers
                                  .sublist(_selectedMembers.length - 2)
                                  .toList()
                                  .reversed
                                  .map((e) => Chip(
                                        label: Text(
                                          e.name!,
                                          style: font,
                                        ),
                                        onDeleted: () {
                                          setState(() {
                                            _selectedMembers.remove(e);
                                          });
                                        },
                                      )),
                              Text(
                                ' +${_selectedMembers.length - 2}',
                                style: font.copyWith(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          )
                        else
                          ..._selectedMembers.map((member) {
                            return Chip(
                              label: Text(
                                member.name!,
                                style: font,
                              ),
                              onDeleted: () {
                                setState(() {
                                  _selectedMembers.remove(member);
                                });
                              },
                            );
                          }),
                        const SizedBox(width: 16),
                      ],
                      ElevatedButton(
                        onPressed: () {
                          nameFocus.unfocus();
                          descriptionFocus.unfocus();
                          showMemberSelection();
                        },
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Priority',
                    style: font.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedPriority,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedPriority = newValue;
                      });
                    },
                    items: _priorities.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Priority tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Date & Time',
                    style: font.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      // Start Date Field
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Start Date',
                            labelStyle: font,
                            hintText: _startDate != null
                                ? DateFormat('yyyy-MM-dd').format(_startDate!)
                                : 'Select date',
                            hintStyle: font,
                            suffixIcon: GestureDetector(
                                onTap: () => _selectDate(context, true),
                                child: const Icon(Icons.calendar_today)),
                          ),
                          controller: TextEditingController(
                            text: _startDate != null
                                ? DateFormat('yyyy-MM-dd').format(_startDate!)
                                : '',
                          ),
                          validator: (value) {
                            if (_startDate == null) {
                              return 'Start Date tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // End Date Field
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'End Date',
                            labelStyle: font,
                            hintText: _endDate != null
                                ? DateFormat('yyyy-MM-dd').format(_endDate!)
                                : 'Select date',
                            hintStyle: font,
                            suffixIcon: GestureDetector(
                                onTap: () => _selectDate(context, false),
                                child: const Icon(Icons.calendar_today)),
                          ),
                          controller: TextEditingController(
                            text: _endDate != null
                                ? DateFormat('yyyy-MM-dd').format(_endDate!)
                                : '',
                          ),
                          validator: (value) {
                            if (_endDate == null) {
                              return 'End Date tidak boleh kosong';
                            }
                            if (_startDate != null &&
                                _endDate != null &&
                                _endDate!.isBefore(_startDate!)) {
                              return 'End Date harus sama dengan atau setelah Start Date';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description Field
                  TextFormField(
                    focusNode: descriptionFocus,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: font.copyWith(fontWeight: FontWeight.bold),
                      hintText: 'Masukkan Task Description',
                      hintStyle: font,
                      border: const OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description tidak boleh kosong';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        nameFocus.unfocus();
                        descriptionFocus.unfocus();
                        if (_selectedCategory == null) {
                          // Validasi manual untuk kategori
                          setState(() {});
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          // Buat task dari form data
                          if (widget.task == null) {
                            final newTask = TaskModel(
                                name: _nameController.text,
                                description: _descriptionController.text,
                                category: _selectedCategory!,
                                members: _selectedMembers,
                                isCompleted: false,
                                startDate: _startDate!,
                                endDate: _endDate!,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                                priority: _selectedPriority!);

                            Provider.of<NewTaskProvider>(context, listen: false)
                                .addTask(newTask);
                          } else {
                            final newTask = TaskModel(
                                id: widget.task!.id!,
                                name: _nameController.text,
                                description: _descriptionController.text,
                                category: _selectedCategory!,
                                members: _selectedMembers,
                                isCompleted: widget.task!.isCompleted,
                                startDate: _startDate!,
                                endDate: _endDate!,
                                createdAt: widget.task!.createdAt,
                                updatedAt: DateTime.now(),
                                priority: _selectedPriority!);
                            Provider.of<NewTaskProvider>(context, listen: false)
                                .updateTask(newTask);
                          }
                          String message = widget.task == null
                              ? 'Task berhasil dibuat'
                              : 'Task berhasil diubah';
                          // Tampilkan snackbar atau navigasi ke halaman lain
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                message,
                                style: font,
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        widget.task == null ? 'Create Task' : 'Update Task',
                        style: font,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
