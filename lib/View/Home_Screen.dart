import 'dart:async';

import 'package:crud_operation/Data/response/status.dart';
import 'package:crud_operation/Models/Userfetch_Model.dart';
import 'package:crud_operation/View%20Model/Home_View_Model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../Utils/routes/Routes_Name.dart';
import '../Utils/Utils.dart';
import '../View Model/Delete_View_Model.dart';
import '../View Model/Updateuser_View_Model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> with RouteAware{
  late String liveTime;
  Timer? timer;
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  void startListening() async {
    bool available = await speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );

    if (available) {
      setState(() => isListening = true);
      speech.listen(
        onResult: (result) {
          setState(() {
            searchController.text = result.recognizedWords;
            homeViewModel.filterUsers(result.recognizedWords);
          });
        },
      );
    }
  }
  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }

  HomeViewModel homeViewModel = HomeViewModel();
  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    _updateTime();
    speech = stt.SpeechToText();
    _initSpeech();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
    homeViewModel.fetchUserApi();
    super.initState();
  }


  Future<void> _initSpeech() async {
    bool available = await speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );

    if (!available) {
      Utils.flushbarErrorMessage("Speech recognition not available", context);
    }
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      liveTime = "${now.hour.toString().padLeft(2,'0')}:"
          "${now.minute.toString().padLeft(2,'0')}:"
          "${now.second.toString().padLeft(2,'0')}";
    });
  }
  @override
  void dispose() {
    speech.stop();
    timer?.cancel();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void onSearchChanged(String value) {
    homeViewModel.filterUsers(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search by username",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon:IconButton(
                    icon: Icon(Icons.mic, color: Colors.blue),
                    onPressed: () async {
                      bool available = await speech.initialize(
                        onStatus: (status) => print('Speech status: $status'),
                        onError: (error) => print('Speech error: $error'),
                      );

                      if (!available) {
                        Utils.flushbarErrorMessage("Speech recognition not available", context);
                        return;
                      }

                      speech.listen(
                        onResult: (result) {
                          setState(() {
                            searchController.text = result.recognizedWords;
                            homeViewModel.filterUsers(result.recognizedWords);
                          });
                        },
                      );
                    },
                  ),

                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.userscreen);
                },
              ),
            ),
          ],
        ),
      ),
      body: ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(
          builder: (context, value, _) {
            switch (value.userList.status) {
              case Status.Loading:
                return Center(child: SpinKitCircle(
                    color: Colors.blueAccent

                ));
              case Status.Error:
                return Center(child: Text(value.userList.message.toString()));
              case Status.Completed:
                if (value.filteredList.isEmpty) {
                  return const Center(child: Text("No users found"));
                }
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      padding: const EdgeInsets.all(12),
                      child:Row(
                        children: [
                          Text(
                            " ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                            style: const TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Text(
                            liveTime,
                            style: const TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )

                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: value.filteredList.length,
                        itemBuilder: (context, index) {
                          final user = value.filteredList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.grey, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          user.username,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: user.isActive ? Colors.green : Colors.red,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          user.isActive ? "Active" : "Inactive",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    " ${user.role?.name ?? 'No Role'}",
                                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_note_outlined, color: Colors.orange, size: 20),
                                        onPressed: () {
                                          showEditUserDialog(context, user, homeViewModel);
                                        },
                                      ),


                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                        onPressed: () async {
                                          final confirm = await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Confirm Delete",style: TextStyle(
                                                color: Colors.red
                                              ),),
                                              content: Text("Are you sure you want to delete ${user.username}?"),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                                                ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete",style: TextStyle(
                                                    color: Colors.red
                                                ),),),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            final deleteVM = DeleteUserViewModel();
                                            try {
                                              await deleteVM.deleteUser(user.id);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("${user.username} deleted successfully")),
                                              );
                                              homeViewModel.fetchUserApi(); // Refresh the list
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Delete failed: $e")),
                                              );
                                            }
                                          }
                                        },
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}


Future<void> showEditUserDialog(
    BuildContext context,
    UserFetchModel user,
    HomeViewModel homeVM,
    ) async {
  final usernameController = TextEditingController(text: user.username);
  final firstNameController = TextEditingController(text: user.profile?.firstName ?? '');
  final lastNameController = TextEditingController(text: user.profile?.lastName ?? '');
  final emailController = TextEditingController(text: user.profile?.email ?? '');
  final mobileController = TextEditingController(text: user.profile?.mobile ?? '');
  final addressController = TextEditingController(text: user.profile?.address ?? '');
  final pincodeController = TextEditingController(text: user.profile?.pincode ?? '');
  final genderController = TextEditingController(text: user.profile?.gender ?? 'male');
  bool screenMonitoring = user.screenMonitoring;
  String joiningDate = user.joiningDate ?? "2024-06-06";
  String dob = user.profile?.dob ?? "2000-06-06";

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Edit User"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: usernameController, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: firstNameController, decoration: const InputDecoration(labelText: "First Name")),
            TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "Last Name")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: mobileController, decoration: const InputDecoration(labelText: "Mobile")),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: "Address")),
            TextField(controller: pincodeController, decoration: const InputDecoration(labelText: "Pincode")),
            TextField(controller: genderController, decoration: const InputDecoration(labelText: "Gender")),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Screen Monitoring"),
                StatefulBuilder(
                  builder: (context, setState) => Switch(
                    value: screenMonitoring,
                    onChanged: (val) => setState(() => screenMonitoring = val),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            final body = {
              "username": usernameController.text,
              "roleId": user.role?.id ?? 1,
              "first_name": firstNameController.text,
              "last_name": lastNameController.text,
              "email": emailController.text,
              "mobile": mobileController.text,
              "address": addressController.text,
              "pincode": pincodeController.text,
              "country": 101,
              "stateId": 1,
              "cityId": 1,
              "departmentId": null,
              "designationId": null,
              "joining_date": joiningDate,
              "gender": genderController.text,
              "total_leave": 12,
              "image": null,
              "dob": dob,
              "screen_monitoring": screenMonitoring,
              "employee_id": ""
            };

            try {
              final updateVM = UpdateUserViewModel();
              await updateVM.updateUserApi(user.id, body);

              Navigator.pop(context);
              homeVM.fetchUserApi();

              Utils.flushbarSuccessMessage('User updated successfully', context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Update failed: $e")),
              );
            }
          },
          child: const Text("Update"),
        ),
      ],
    ),
  );
}


