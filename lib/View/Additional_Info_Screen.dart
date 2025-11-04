import 'dart:io';
import 'package:crud_operation/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import '../Models/Create_User_Model.dart';
import 'Profile_Screen.dart';

class AdditionalInfoScreen extends StatefulWidget {
  final CreateUserModel user;
  const AdditionalInfoScreen({super.key, required this.user});

  @override
  State<AdditionalInfoScreen> createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController totalLeaveController = TextEditingController();

  File? selectedFile;
  String fileStatus = ""; // Upload status text

  int? selectedCountry;
  int? selectedState;
  int? selectedCity;

  final List<Map<String, dynamic>> countries = [
    {"id": 100, "name": "Select"},
    {"id": 101, "name": "India"},
    {"id": 102, "name": "USA"},
    {"id": 103, "name": "UK"},
  ];

  final List<Map<String, dynamic>> states = [
    {"id": 1, "name": "Select"},
    {"id": 2, "name": "UP"},
    {"id": 3, "name": "Gujarat"},
    {"id": 4, "name": "Delhi"},
    {"id": 10, "name": "Punjab"},
    {"id": 11, "name": "Haryana"},
    {"id": 12, "name": "Bihar"},
  ];


  final List<Map<String, dynamic>> cities = [
    {"id": 1, "name": "Select"},
    {"id": 2, "name": "Mumbai"},
    {"id": 3, "name": "Pune"},
    {"id": 4, "name": "Surat"},

    {"id": 7, "name": "Chennai"},
    {"id": 8, "name": "Kolkata"},
    {"id": 9, "name": "Jaipur"},

    {"id": 11, "name": "Lucknow"},
    {"id": 12, "name": "Kanpur"},
    {"id": 13, "name": "Indore"},
    {"id": 14, "name": "Bhopal"},
    {"id": 15, "name": "Patna"},
    {"id": 17, "name": "Noida"},
    {"id": 18, "name": "Gurugram"},
    {"id": 19, "name": "Thane"},
    {"id": 20, "name": "Nagpur"},
  ];

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  @override
  void initState() {
    super.initState();
    addressController.text = widget.user.address ?? '';
    pincodeController.text = widget.user.pincode ?? '';
    departmentController.text =
    widget.user.departmentId != null ? widget.user.departmentId.toString() : '';
    designationController.text =
    widget.user.designationId != null ? widget.user.designationId.toString() : '';
    totalLeaveController.text =
    widget.user.totalLeave != null ? widget.user.totalLeave.toString() : '';
    selectedCountry = widget.user.country;
    selectedState = widget.user.stateId;
    selectedCity = widget.user.cityId;
  }

  @override
  void dispose() {
    addressController.dispose();
    pincodeController.dispose();
    departmentController.dispose();
    designationController.dispose();
    totalLeaveController.dispose();
    super.dispose();
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
          fileStatus = "File selected successfully ✅";
        });
      } else {
        setState(() {
          fileStatus = "File selection cancelled";
        });
      }
    } catch (e) {
      setState(() {
        fileStatus = "Failed to select file";
      });
      debugPrint("File picker error: $e");
    }
  }

  void goToProfileScreen() {
    if (addressController.text.isEmpty || pincodeController.text.isEmpty) {
 Utils.flushbarErrorMessage('Please fill all required fields', context);
      return;
    }
    // Pincode validation (6 digits)
    if (pincodeController.text.trim().length != 6 ||
        int.tryParse(pincodeController.text.trim()) == null) {
     Utils.flushbarErrorMessage('Pincode must be exactly 6 digits', context);
      return;
    }
    // Updated user model (file path NOT sent to server)
    CreateUserModel updatedUser = widget.user.copyWith(
      address: addressController.text.trim(),
      pincode: pincodeController.text.trim(),
      country: selectedCountry,
      stateId: selectedState,
      cityId: selectedCity,
      departmentId: int.tryParse(departmentController.text.trim()) ?? widget.user.departmentId,
      designationId: int.tryParse(designationController.text.trim()) ?? widget.user.designationId,
      totalLeave: int.tryParse(totalLeaveController.text.trim()) ?? widget.user.totalLeave,
      screenMonitoring: false,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(user: updatedUser),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Team"),
      backgroundColor: Colors.green,),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Center(
            child: Text('Additional Information',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue
            ),),
          ),
            SizedBox(height: 15,),
            TextField(
              controller: addressController,
              decoration: inputDecoration("Address"),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedCountry,
                    decoration: inputDecoration("Country"),
                    items: countries
                        .map((c) => DropdownMenuItem<int>(
                      value: c['id'],
                      child: Text(c['name']),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedCountry = val),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedState,
                    decoration: inputDecoration("State"),
                    items: states
                        .map((s) => DropdownMenuItem<int>(
                      value: s['id'],
                      child: Text(s['name']),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedState = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedCity,
                    decoration: inputDecoration("City"),
                    items: cities
                        .map((c) => DropdownMenuItem<int>(
                      value: c['id'],
                      child: Text(c['name']),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedCity = val),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: pincodeController,
                    decoration: inputDecoration("Pincode"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: departmentController,
              decoration: inputDecoration("Department"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: designationController,
              decoration: inputDecoration("Designation"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: totalLeaveController,
              decoration: inputDecoration("Total Leave"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: pickFile,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        selectedFile != null
                            ? selectedFile!.path.split('/').last
                            : " Select file  ",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              fileStatus,
              style: TextStyle(
                color: fileStatus.contains("success") ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: goToProfileScreen,
                child: const Text(
                  "Next",
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
