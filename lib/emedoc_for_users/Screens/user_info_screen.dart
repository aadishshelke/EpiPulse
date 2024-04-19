import 'package:emedoc/models/user_model.dart';
import 'package:emedoc/emedoc_for_users/Screens/main_entry_screen.dart';
import 'package:emedoc/utils/colors.dart';
import 'package:emedoc/emedoc_for_users/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController nameOfFamilyDocController =
      TextEditingController();
  final TextEditingController numberOfFamilyDocController =
      TextEditingController();
  final TextEditingController specialInstController = TextEditingController();

  bool diabetes = false;
  bool hypertension = false;
  bool asthma = false;

  void _finishLogin() {
    Userinfo user = Userinfo(
      firstName: firstNameController.text,
      lasttName: lastNameController.text,
      address: addressController.text,
      phoneNumber: 'aa',
      bloodGroup: bloodGroupController.text,
      diabeties: diabetes,
      allergies: allergiesController.text,
      hypertension: hypertension,
      asthama: asthma,
      nameOfFamilyDoc: nameOfFamilyDocController.text,
      numOfFamilyDoc: numberOfFamilyDocController.text,
      specialInstructions: specialInstController.text,
    );
    saveUserData(user);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserMainScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('User Information', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
        backgroundColor: appBarColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'First Name'),
                      controller: firstNameController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Last Name'),
                      controller: lastNameController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Address'),
                      controller: addressController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Blood group'),
                      controller: bloodGroupController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Allergies'),
                      controller: allergiesController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Name of Family Doctor'),
                      controller: nameOfFamilyDocController,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Number of Family Doctor'),
                      controller: numberOfFamilyDocController,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Special Instructions'),
                      controller: specialInstController,
                    ),
                    Row(
                      children: [
                        const Text('Diabetes'),
                        Switch(
                          value: diabetes,
                          onChanged: (value) {
                            setState(() {
                              diabetes = value;
                            });
                          },
                        ),
                      ],
                    ),
                    // Switch for Hypertension
                    Row(
                      children: [
                        const Text('Hypertension'),
                        Switch(
                          value: hypertension,
                          onChanged: (value) {
                            setState(() {
                              hypertension = value;
                            });
                          },
                        ),
                      ],
                    ),
                    // Switch for Asthma
                    Row(
                      children: [
                        const Text('Asthma'),
                        Switch(
                          value: asthma,
                          onChanged: (value) {
                            setState(() {
                              asthma = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _finishLogin,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
