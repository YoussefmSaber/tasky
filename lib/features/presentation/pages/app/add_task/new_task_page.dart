import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/features/domain/entities/task/add_task.dart';
import 'package:tasky/features/presentation/pages/app/add_task/new_task/new_task_cubit.dart';
import 'package:tasky/features/presentation/pages/app/add_task/new_task/new_task_states.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';
import 'package:tasky/routes.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _selectedDate;
  String? _selectedPriority;

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

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _addTask(BuildContext context) async {
    if (_selectedImage == null) {
      _showSnackbar('Please select an image.');
      return;
    }
    final cubit = context.read<NewTaskCubit>();
    try {
      final imageUrl = await cubit.uploadImage(_selectedImage!);
      if (imageUrl != null) {
        await cubit.addTask(AddTask(
          image: imageUrl,
          title: titleController.text.trim(),
          desc: descController.text.trim(),
          priority: _selectedPriority,
          dueDate: _selectedDate,
        ));
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteGenerator.home,
          (route) => false,
        );
      }
    } catch (e) {
      _showSnackbar('Error adding task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushNamed(RouteGenerator.home),
          icon: AppIcons.backArrow,
        ),
        title: Text(Strings.addNewTask, style: FontStyles.textTitleStyle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: BlocConsumer<NewTaskCubit, NewTaskStates>(
              listener: (context, state) {
                if (state is ErrorUpdatingTaskState) {
                  _showSnackbar(state.message);
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        onTap: () => _showImagePickerDialog(context),
                        child: _selectedImage != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      _selectedImage!,
                                      height: 250,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              )
                            : SvgPicture.asset(Images.addImage),
                      ),
                    ),
                    _buildTextField(
                      Strings.taskTitle,
                      Strings.titleHere,
                      controller: titleController,
                    ),
                    _buildTextField(
                      Strings.taskDesc,
                      null,
                      controller: descController,
                      isMultiline: true,
                    ),
                    _buildPrioritySelector(),
                    _buildDateSelector(),
                    const SizedBox(height: 32),
                    SignButton(
                      text: 'Add Task',
                      onTap: () => _addTask(context),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String? hint,
      {required TextEditingController controller, bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: FontStyles.hintTextStyle),
          TextInput(
            controller: controller,
            inputType:
                isMultiline ? TextInputType.multiline : TextInputType.text,
            hint: hint ?? "",
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: PriorityCard(
        priority: "low",
        onPrioritySelected: (value) => _selectedPriority = value,
      ),
    );
  }

  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: DatePicker(
        onDateSelected: (date) => _selectedDate = date,
      ),
    );
  }
}
