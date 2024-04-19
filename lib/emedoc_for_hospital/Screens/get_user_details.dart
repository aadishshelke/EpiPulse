import 'package:emedoc/models/user_model.dart';
import 'package:emedoc/utils/colors.dart';
import 'package:flutter/material.dart';

class Userdetailscreen extends StatelessWidget {
  const Userdetailscreen({Key? key, required this.user}) : super(key: key);
  final Userinfo user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lasttName}', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
        backgroundColor: appBarColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('First Name', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.firstName),
              ),
              ListTile(
                title: const Text('Last Name', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.lasttName),
              ),
              ListTile(
                title: const Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.address),
              ),
              ListTile(
                title: const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.phoneNumber),
              ),
              ListTile(
                title: const Text('Blood Group', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.bloodGroup),
              ),
              ListTile(
                title: const Text('Diabetes', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.diabeties ? 'Yes' : 'No'),
              ),
              ListTile(
                title: const Text('Allergies', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.allergies),
              ),
              ListTile(
                title: const Text('Hypertension', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.hypertension ? 'Yes' : 'No'),
              ),
              ListTile(
                title: const Text('Asthma', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.asthama ? 'Yes' : 'No'),
              ),
              ListTile(
                title: const Text('Family Doctor Name', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.nameOfFamilyDoc),
              ),
              ListTile(
                title: const Text('Family Doctor Number', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.numOfFamilyDoc),
              ),
              ListTile(
                title: const Text('Special Instructions', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.specialInstructions),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
