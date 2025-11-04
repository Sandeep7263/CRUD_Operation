import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Models/Create_User_Model.dart';
import '../Utils/Utils.dart';
import 'Additional_Info_Screen.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  // Emergency Contact Controllers
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController emergencyRelationController = TextEditingController();

  // Dropdown selections
  String? selectedTitle;
  int selectedRoleId = 1;
  int selectedRegionId = 1;
  int selectedShiftId = 1;

  bool isLoading = false;

  // Dropdown options
  final List<Map<String, dynamic>> titles = [
    {"id": 1, "name": "Mr"},
    {"id": 2, "name": "Ms"},
    {"id": 3, "name": "Mrs"},
  ];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    employeeIdController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    dobController.dispose();
    genderController.dispose();
    emergencyNameController.dispose();
    emergencyContactController.dispose();
    emergencyRelationController.dispose();
    super.dispose();
  }

  void nextScreen() {
    // Required fields validation
    if (selectedTitle == null ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        contactNumberController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        dobController.text.isEmpty ||
        genderController.text.isEmpty) {
      Utils.flushbarErrorMessage('Please fill all required fields', context);
      return;
    }

    // Contact number validation
    if (contactNumberController.text.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(contactNumberController.text)) {
      Utils.flushbarErrorMessage('Contact number must be exactly 10 digits', context);
      return;
    }

    setState(() => isLoading = true);

    // Create User Model
    CreateUserModel user = CreateUserModel(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
      roleId: selectedRoleId,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      mobile: contactNumberController.text.trim(),
      dob: dobController.text.trim(),
      gender: genderController.text.trim(),
      employeeId: employeeIdController.text.trim(),
      address: '',
      pincode: '',
      country: 101,
      stateId: 1,
      cityId: 1,
      departmentId: null,
      designationId: null,
      totalLeave: 12,
      image: null,
      joiningDate: dobController.text.trim(),
      screenMonitoring: false,
    );

    setState(() => isLoading = false);

    // Navigate to AdditionalInfoScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdditionalInfoScreen(user: user),
      ),
    );
  }

  Widget buildDropdown(String label, String? value, List<Map<String, dynamic>> items,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
        value: item["id"].toString(),
        child: Text(item["name"]),
      ))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Team"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text('User Details',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue
              ),),
            ),
            SizedBox(height: 15,),
            buildDropdown("Title", selectedTitle, titles, (val) {
              setState(() => selectedTitle = val);
            }),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: contactNumberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: const InputDecoration(
                      labelText: "Contact Number",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: genderController,
                    decoration: const InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              keyboardType: TextInputType.number,
              controller: employeeIdController,
              decoration: const InputDecoration(

                labelText: "Employee ID",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),

              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dobController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  dobController.text =
                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                }
              },
              decoration: const InputDecoration(
                labelText: "Date of Birth",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "*Emergency Contact*",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.red),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emergencyNameController,
              decoration: const InputDecoration(
                labelText: "Person Name",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: emergencyContactController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: const InputDecoration(
                      labelText: "Alternative No",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: emergencyRelationController,
                    decoration: const InputDecoration(
                      labelText: "Relation",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: isLoading ? null : nextScreen,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Next", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
