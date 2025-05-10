import 'package:country_picker/country_picker.dart';
import 'package:epipulse/utils/colors.dart';
import 'package:epipulse/utils/custom_button.dart';
import 'package:epipulse/epipulse_for_hospital/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreenHospital extends StatefulWidget {
  const LoginScreenHospital({super.key});

  @override
  State<LoginScreenHospital> createState() => _LoginScreenHospitalState();
}

class _LoginScreenHospitalState extends State<LoginScreenHospital> {
  String countrycode = '';
  final textcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void showCountryPicker2(BuildContext context) {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          countrycode = country.phoneCode;
        });
      },
    );
  }

  void _send() {
    if (_formKey.currentState!.validate()) {
      String ph = '+$countrycode${textcontroller.text}';
      sendPhoneNumberHospital(ph, context);
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    } else if (!(value.length == 10)) {
      return 'Please enter a valid phone number';
    } else if (countrycode == '') {
      return 'Please select a Country Code';
    }
    return null; // Return null if the input is valid
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Hospital login',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => showCountryPicker2(context),
              child: Container(
                height: 68,
                width: size.width * 0.81,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: appBarColor, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Pick a Country',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.15,
                  height: 65,
                  decoration: BoxDecoration(
                    border: Border.all(color: appBarColor, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text('+$countrycode'),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: appBarColor, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: size.width * 0.65,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: textcontroller,
                      validator: _validatePhoneNumber,
                      obscureText: false,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: appBarColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                        ),
                        hintText: "Phone Number",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
                text: "Next",
                onPressed: _send,
                width: size.width * 0.8,
                color: appBarColor),
          ],
        ),
      ),
    );
  }
}
