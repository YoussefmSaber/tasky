import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky/core/constants/colors.dart';
import 'package:tasky/core/constants/strings.dart';
import 'package:tasky/core/images/icons.dart';
import 'package:tasky/core/styles/fonts.dart';
import 'package:tasky/features/domain/entities/task/edit_task.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';
import 'package:tasky/features/presentation/pages/app/edit_task/cubit/edit_task_cubit.dart';
import 'package:tasky/features/presentation/pages/app/edit_task/cubit/edit_task_states.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';

typedef ErrorCallback = void Function(String message);

class EditTaskPage extends StatefulWidget {
  final TaskData task;

  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState(); // Fixed class name
}

class _EditTaskPageState extends State<EditTaskPage> {
  late String editedPriority;
  late String editedState;
  late TextEditingController titleController;
  late TextEditingController descController;
  File? _selectedImage;
  bool _hasUnsavedChanges = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descController = TextEditingController(text: widget.task.desc);
    editedPriority = widget.task.priority!;
    editedState = widget.task.status!;

    titleController.addListener(_onFieldChanged);
    descController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  @override
  void dispose() {
    titleController.removeListener(_onFieldChanged);
    descController.removeListener(_onFieldChanged);
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onWillPop() async {
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unsaved Changes'),
        content: Text('You have unsaved changes. Do you want to save them?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Don't save, just go back
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              final cubit = context.read<EditTaskCubit>();
              context.read<EditTaskCubit>().saveTask(
                    EditTask(
                      title: titleController.text.trim(),
                      desc: descController.text.trim(),
                      priority: editedPriority,
                      status: editedState,
                      image: await cubit.uploadImage(_selectedImage!) ??
                          widget.task.image!,
                    ),
                    widget.task.id!,
                  );
              Navigator.pop(context); // Save and go back
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDesktopImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        setState(() => _selectedImage = File(result.files.single.path!));
      }
    } catch (e) {
      _showSnackbar('Error picking image: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      _showSnackbar('Error selecting image: $e');
    }
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (Platform.isWindows)
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Choose from Computer'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickDesktopImage();
                  },
                ),
              if (!Platform.isWindows) ...[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  bool _validateInputs() {
    if (titleController.text.trim().isEmpty) {
      _showSnackbar('Title is required');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditTaskCubit, EditTaskStates>(
      listener: (context, state) {
        if (state is EditTaskSuccess) {
          Navigator.pop(context, true);
        } else if (state is EditTaskError) {
          _showSnackbar(state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                _onWillPop();
              },
              icon: AppIcons.backArrow,
            ),
            title: Text(
              Strings.editTask,
              style: FontStyles.textTitleStyle,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                "https://todo.iraqsapp.com/images/${widget.task.image}",
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 250,
                                    width: double.infinity,
                                    color: AppColors.secondaryTextColor,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 250,
                                    width: double.infinity,
                                    color: AppColors.secondaryTextColor,
                                    child: Icon(Icons.error),
                                  );
                                },
                              ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () => _showImagePickerDialog(context),
                            icon: Icon(Icons.edit, size: 18.0),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            icon: Icon(
                              Icons.remove,
                              size: 18.0,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    maxLength: 50,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Title *",
                      hintStyle: FontStyles.secondaryTextStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: descController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: FontStyles.secondaryTextStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TaskState(
                    state: editedState,
                    onStateSelected: (value) {
                      setState(() => editedState = value);
                    },
                  ),
                  SizedBox(height: 16),
                  PriorityCard(
                    priority: editedPriority,
                    onPrioritySelected: (value) {
                      setState(() => editedPriority = value);
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: SignButton(
                      text: "Update Task",
                      onTap: () async {
                        if (_validateInputs()) {
                          context.read<EditTaskCubit>().saveTask(
                                EditTask(
                                  title: titleController.text.trim(),
                                  desc: descController.text.trim(),
                                  priority: editedPriority,
                                  status: editedState,
                                  image: _selectedImage != null
                                      ? await context
                                              .read<EditTaskCubit>()
                                              .uploadImage(_selectedImage!)
                                      : widget.task.image!,
                                ),
                                widget.task.id!,
                              );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
