import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/core/styles/snackbar.dart';
import 'package:tasky/features/task/domain/entities/task/add_task.dart';
import 'package:tasky/features/task/presentation/states/new_task_states.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';
import 'package:tasky/routes.dart';

import '../cubit/new_task_cubit.dart';

/// A page for creating a new task.
class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

/// State class for `NewTaskPage`.
class _NewTaskPageState extends State<NewTaskPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _selectedDate;
  String? _selectedPriority;
  final _formKey = GlobalKey<FormState>();

  /// Picks an image from the desktop file picker.
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
      showAppSnackBar(
          message: 'Error picking image: $e',
          backgroundColor: AppColors.errorBackgroundColor,
          textColor: AppColors.errorTextColor,
          context: context);
    }
  }

  /// Picks an image from the specified [source].
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      showAppSnackBar(
          message: 'Error selecting image: $e',
          backgroundColor: AppColors.errorBackgroundColor,
          textColor: AppColors.errorTextColor,
          context: context);
    }
  }

  /// Shows a dialog for selecting an image source.
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

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
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
                  showAppSnackBar(
                      message: state.message,
                      backgroundColor: AppColors.errorBackgroundColor,
                      textColor: AppColors.errorTextColor,
                      context: context);
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
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
                        validator: (value) => value == null || value.isEmpty
                            ? "Title is required"
                            : null,
                      ),
                      _buildTextField(
                        Strings.taskDesc,
                        Strings.descHere,
                        controller: descController,
                        isMultiline: true,
                        validator: (value) => value == null || value.isEmpty
                            ? "Description is required"
                            : null,
                      ),
                      _buildPrioritySelector(),
                      _buildDateSelector(),
                      const SizedBox(height: 32),
                      SizedBox(
                          width: double.infinity,
                          child: SignButton(
                            text: 'Add Task',
                            onTap: () => _addTask(context),
                          )),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a text field with the specified [label], [hint], and [controller].
  Widget _buildTextField(
      String label,
      String? hint, {
        required TextEditingController controller,
        bool isMultiline = false,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: FontStyles.descriptionStyle),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: FontStyles.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: isMultiline ? 4 : 1,
            validator: validator,
          ),
        ],
      ),
    );
  }

  /// Builds the priority selector widget with validation.
  Widget _buildPrioritySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Priority", style: FontStyles.descriptionStyle),
          const SizedBox(height: 4),
          PriorityCard(
            priority: "low",
            onPrioritySelected: (value) {
              setState(() {
                _selectedPriority = value;
              });
            },
          ),
          if (_selectedPriority == null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "Please select a priority.",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the date selector widget with validation.
  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Due date", style: FontStyles.descriptionStyle),
          const SizedBox(height: 4),
          DatePicker(
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          if (_selectedDate == null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "Please select a due date.",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  /// Adds a new task with the provided details.
  Future<void> _addTask(BuildContext context) async {
    if (_selectedImage == null) {
      showAppSnackBar(
          message: 'Please select an image.',
          textColor: AppColors.warningTextColor,
          backgroundColor: AppColors.warningBackgroundColor,
          context: context);
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
        showAppSnackBar(
            message: "Task added successfully",
            backgroundColor: AppColors.successBackgroundColor,
            textColor: AppColors.successTextColor,
            context: context);
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteGenerator.home,
              (route) => false,
        );
      }
    } catch (e) {
      showAppSnackBar(
          message: 'Error adding task: $e',
          backgroundColor: AppColors.errorBackgroundColor,
          textColor: AppColors.errorTextColor,
          context: context);
    }
  }
}