import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vv/api/login_api.dart';
import 'package:vv/widgets/backbutton.dart';

import 'package:vv/widgets/background.dart';

class ViewProfile extends StatefulWidget {
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _relationalityController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _distanceController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  Future<void> _fetchUserData() async {
    try {
      var response = await DioService().dio.get(
          'https://electronicmindofalzheimerpatients.azurewebsites.net/api/Family/GetPatientProfile');
      if (response.statusCode == 200) {
        setState(() {
          _fullNameController.text = response.data['fullName'];
          _emailController.text = response.data['email'];
          _phoneController.text = response.data['phoneNumber'];
          _ageController.text = response.data['age'].toString();
          _relationalityController.text = response.data['relationality'];
          _selectedDate =
              DateFormat('dd/MM/yyyy').parse(response.data['diagnosisDate']);
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> updateUserProfile() async {
    String apiUrl =
        'https://electronicmindofalzheimerpatients.azurewebsites.net/api/Family/UpdatePatientProfile';

    Map<String, dynamic> requestBody = {
      'phoneNumber': _phoneController.text,
      'age': int.parse(_ageController.text),
      'diagnosisDate': _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : null,
      'maximumDistance': _distanceController.text,
    };

    try {
      Response response = await DioService().dio.put(
        apiUrl,
        data: requestBody,
        options: Options(
          contentType: 'application/json; charset=UTF-8',
        ),
      );

      if (response.statusCode == 200) {
        print('User profile updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: const Text('User profile updated successfully'),
          ),
        );
      } else {
        print(
            'Failed to update user profile. Status code: ${response.statusCode}');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to update user profile. Status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (error) {
      print('An error occurred: $error');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        SingleChildScrollView: null,
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    backbutton(),
                    // SizedBox(
                    //   height: 40,
                    // ),
                    Text(
                      'Manage Patient',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(fontSize: 30),
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(90, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: const TextStyle(color: Color(0xFFa7a7a7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        suffixIcon: const Icon(Icons.account_circle,
                            size: 25, color: Color(0xFFD0D0D0)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12),
                      ),
                      readOnly: true,
                      controller: _fullNameController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Color(0xFFa7a7a7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        suffixIcon: const Icon(Icons.email,
                            size: 25, color: Color(0xFFD0D0D0)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12),
                      ),
                      readOnly: true,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: const TextStyle(color: Color(0xFFa7a7a7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        suffixIcon: const Icon(Icons.phone,
                            size: 25, color: Color(0xFFD0D0D0)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12),
                      ),
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Age',
                        labelStyle: const TextStyle(color: Color(0xFFa7a7a7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        suffixIcon: const Icon(Icons.calendar_today,
                            size: 25, color: Color(0xFFD0D0D0)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12),
                      ),
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Relationality',
                        labelStyle: const TextStyle(color: Color(0xFFa7a7a7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        suffixIcon: const Icon(Icons.person,
                            size: 25, color: Color(0xFFD0D0D0)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12),
                      ),
                      readOnly: true,
                      controller: _relationalityController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Diagnosis Date',
                        labelStyle: const TextStyle(color: Color(0xFFa7a7a7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        suffixIcon: const Icon(Icons.calendar_today,
                            size: 25, color: Color(0xFFD0D0D0)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12),
                      ),
                      controller: TextEditingController(
                        text: _selectedDate == null
                            ? ''
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      ),
                      readOnly: true,
                      onTap: _presentDatePicker,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Maximum Distance',
                        labelStyle: const TextStyle(color: Color(0xFFa7a7a7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        suffixIcon: const Icon(Icons.location_on,
                            size: 25, color: Color(0xFFD0D0D0)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12),
                      ),
                      controller: _distanceController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () async {
                        // Call the method to update user profile
                        await updateUserProfile();
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}