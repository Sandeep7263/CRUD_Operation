import 'dart:io';
import 'package:crud_operation/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Models/Create_User_Model.dart';
import '../View Model/Createuser_View_Model.dart';
import '../View Model/Imageupload_View_Model.dart'; // Add this


import 'Home_Screen.dart';

class ProfileScreen extends StatefulWidget {
  final CreateUserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController joiningDateController = TextEditingController();
  bool isImageUploaded = false; // Image upload status

  File? profileImage;
  bool isLoading = false; // Submit button loading
  bool profileImageUploading = false; // Camera icon loading

  int? selectedTeamId;
  int? selectedRoleId;
  int? selectedRegionId;
  int? selectedShiftId;
  bool screenMonitoring = false; // Screen monitoring switch

  late ImageUploadViewModel imageUploadVM;

  final List<Map<String, dynamic>> teams = [
    {"id": 1, "name": "Team A"},
    {"id": 2, "name": "Team B"},
    {"id": 3, "name": "Team C"},
  ];

  final List<Map<String, dynamic>> roles = [
    {"id": 1, "name": "Select"},
    {"id": 2, "name": "Admin"},
    {"id": 3, "name": "Manager"},
    {"id": 4, "name": "Employee"},
    {"id": 5, "name": "Flutter Developer"},
    {"id": 6, "name": "UI/UX Designer"},
    {"id": 7, "name": "Python Developer"},
    {"id": 8, "name": "Java Developer"},
    {"id": 9, "name": "React Developer"},
    {"id": 10, "name": "Backend Developer"},
    {"id": 11, "name": "Frontend Developer"},
    {"id": 12, "name": "DevOps Engineer"},
    {"id": 13, "name": "QA Engineer"},
    {"id": 14, "name": "Project Manager"},
  ];

  final List<Map<String, dynamic>> regions = [
    {"id": 1, "name": "North"},
    {"id": 2, "name": "South"},
    {"id": 3, "name": "East"},
    {"id": 4, "name": "West"},
  ];

  final List<Map<String, dynamic>> shifts = [
    {"id": 1, "name": "Morning"},
    {"id": 2, "name": "Evening"},
    {"id": 3, "name": "Night"},
  ];

  final List<String> defaultImages = [
    'https://static.vecteezy.com/system/resources/previews/021/548/095/original/default-profile-picture-avatar-user-avatar-icon-person-icon-head-icon-profile-picture-icons-default-anonymous-user-male-and-female-businessman-photo-placeholder-social-network-avatar-portrait-free-vector.jpg',
  ];
  late String randomDefaultImage;

  @override
  void initState() {
    super.initState();
    randomDefaultImage = (defaultImages..shuffle()).first;
    joiningDateController.text = widget.user.joiningDate ?? '';
    screenMonitoring = widget.user.screenMonitoring ?? false;
    imageUploadVM = ImageUploadViewModel();
  }

  Future<void> _selectJoiningDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        joiningDateController.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        setState(() {
          profileImage = File(result.files.single.path!);
        });
        await _uploadProfileImage(); // Upload immediately after pick
      }
    } catch (e) {
      debugPrint("File picker error: $e");
    }
  }

  Future<void> _uploadProfileImage() async {
    if (profileImage == null) return;

    setState(() {
      profileImageUploading = true;
      isImageUploaded = false; // uploading started
    });

    try {
      await imageUploadVM.uploadImage(
        file: profileImage!,
        entityId: "25",
        entityType: "user",
      );

      if (imageUploadVM.uploadResponse != null) {
      Utils.flushbarSuccessMessage('Image uploaded successfully', context);

        setState(() {
          isImageUploaded = true; // upload complete
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed: $e")),
      );
    } finally {
      setState(() => profileImageUploading = false);
    }
  }


  InputDecoration customInputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      suffixIcon: suffixIcon,
    );
  }

  Widget buildDropdownInt(
      String label, int? selectedId, List<Map<String, dynamic>> items, Function(int?) onChanged) {
    return DropdownButtonFormField<int>(
      value: selectedId,
      decoration: customInputDecoration(label),
      items: items
          .map((item) => DropdownMenuItem<int>(
        value: item['id'],
        child: Text(item['name']),
      ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget buildScreenMonitoringSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        const Text(
          "Screen Monitoring",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Switch(
          value: screenMonitoring,
          onChanged: (val) {
            setState(() {
              screenMonitoring = val;
            });
          },
          activeColor: Colors.green,
          inactiveThumbColor: Colors.grey,
        ),
      ],
    );
  }

  // Final API submit (without image upload)
  Future<void> saveProfile() async {
    // ✅ Check profile image
    if (profileImage == null) {
  Utils.flushbarErrorMessage('Please upload a profile image', context);
      return;
    }

    // ✅ Check role
    if (selectedRoleId == null) {
      Utils.flushbarErrorMessage('Please select a role', context);
      return;
    }

    // Check joining date
    if (joiningDateController.text.isEmpty) {
      Utils.flushbarErrorMessage('Please select joining date', context);
      return;
    }

    setState(() => isLoading = true);

    CreateUserModel finalUser = widget.user.copyWith(
      roleId: selectedRoleId,
      joiningDate: joiningDateController.text.trim(),
      screenMonitoring: screenMonitoring,
    );

    try {
      final viewModel = CreateuserViewModel();
      await viewModel.createUser(finalUser);

      setState(() => isLoading = false);

      final response = viewModel.response;
      if (response != null && response['success'] == true) {
        Utils.flushbarSuccessMessage('User Created Successfully', context);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
                (route) => false,
          );


        });
      }
else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?["message"] ?? "Failed to submit data")),
        );
      }

      print("Final JSON to server: ${finalUser.toJson()}");

    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Team",style: TextStyle(
          fontSize: 20
        ),),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () => Navigator.pop(context),
    ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('User Profile',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blue
              ),),

            SizedBox(height: 15,),
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : NetworkImage(randomDefaultImage) as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: profileImageUploading
                          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Joining Date
            GestureDetector(
              onTap: () => _selectJoiningDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: joiningDateController,
                  decoration: customInputDecoration(
                    "Joining Date",
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dropdowns
            buildDropdownInt("Select Team", selectedTeamId, teams,
                    (val) => setState(() => selectedTeamId = val)),
            const SizedBox(height: 12),

            buildDropdownInt("Select Role", selectedRoleId, roles,
                    (val) => setState(() => selectedRoleId = val)),
            const SizedBox(height: 12),

            buildDropdownInt("Select Region", selectedRegionId, regions,
                    (val) => setState(() => selectedRegionId = val)),
            const SizedBox(height: 12),

            buildDropdownInt("Select Shift", selectedShiftId, shifts,
                    (val) => setState(() => selectedShiftId = val)),
            const SizedBox(height: 16),

            // Screen Monitoring Switch
            buildScreenMonitoringSwitch(),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: (isLoading || !isImageUploaded) ? null : saveProfile,
                child: isLoading
                    ? const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 20.0,
                )
                    : const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
