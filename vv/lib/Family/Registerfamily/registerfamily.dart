import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vv/Family/LoginPageAll.dart';
import 'package:vv/Family/Registerfamily/profile/widgets/prof_pic.dart';
import 'package:vv/models/register.dart'; // Import your Register model
import 'package:vv/widgets/backbutton.dart';
import 'package:vv/widgets/custom_Textfield.dart';
import 'package:vv/widgets/pass_textField.dart';
import 'package:dio/dio.dart';
import 'package:vv/widgets/profile.dart';

class APIService {
  static final Dio _dio = Dio();

  static Future<dynamic> register(Register userData) async {
    try {
      Response response = await _dio.post(
        'https://electronicmindofalzheimerpatients.azurewebsites.net/api/Authentication/Register',
        data: {
          'fullName': userData.fullName,
          'email': userData.email,
          'password': userData.password,
          'role': userData.role,
          'phoneNumber': userData.phoneNumber,
          'age': userData.age,
        },
      );
      return response.statusCode == 200
          ? true
          : response.data != null && response.data['message'] != null
              ? response.data['message']
              : 'Registration failed with status code: ${response.statusCode}';
    } catch (error) {
      print('Registration failed: $error');
      return 'Registration failed: $error';
    }
  }
}

class RegisterFamily extends StatefulWidget {
  @override
  _RegisterFamilyState createState() => _RegisterFamilyState();
}

class _RegisterFamilyState extends State<RegisterFamily> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedRole = '';
  bool _isLoading = false;

  void _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_fullNameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty ||
          _phoneNumberController.text.isEmpty ||
          _ageController.text.isEmpty ||
          _selectedRole.isEmpty) {
        throw 'Please fill in all fields.';
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        throw 'Password and Confirm Password do not match.';
      }

      Register userData = Register(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole,
        phoneNumber: _phoneNumberController.text,
        age: int.parse(_ageController.text),
      );

      dynamic response = await APIService.register(userData);

      if (response == true) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registration Successful'),
            content: Text(
                'You have Successfully Registered. Please Confirm Email To Can Login.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPageAll()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw 'Registration failed. Please try again. Error: $response';
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registration Failed'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
   
          
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3B5998),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffFFFFFF), Color(0xff3B5998)],
              ),
            ),
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    backbutton(),
                    SizedBox(height: 0.5),
                    Text(
                      'Create Account',
                      style: TextStyle(fontSize: 40, fontFamily: 'Acme'),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 18),
                    ProfilePicture(),
                    
                    SizedBox(height: 18),
                    CustomTextField(
                      labelText: '  Full Name',
                      controller: _fullNameController,
                      suffixIcon: Icons.person_2_sharp,
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      labelText: '  Email Address',
                      controller: _emailController,
                      suffixIcon: Icons.email_outlined,
                    ),
                    SizedBox(height: 15),
                    PasswordTextField(
                      labelText: '  Password',
                      controller: _passwordController,
                      suffixIcon: Icons.password_outlined,
                    ),
                    SizedBox(height: 15),
                    PasswordTextField(
                      labelText: '  Confirm Password',
                      suffixIcon: Icons.password_outlined,
                      controller: _confirmPasswordController,
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _selectedRole.isNotEmpty ? _selectedRole : null,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        }
                      },
                      items: <String>['Family', 'Caregiver']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: '   You are...',
                        labelStyle: TextStyle(color: Color(0xFFa7a7a7)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '  Select Role',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12),
                      ),
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      labelText: '  Phone Number',
                      controller: _phoneNumberController,
                      suffixIcon: Icons.phone,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      labelText: '  Age',
                      controller: _ageController,
                      suffixIcon: Icons.date_range_rounded,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: Color(0xFF0386D0),
                        fixedSize: Size(151, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27.0),
                        ),
                      ),
                      child: Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xff3B5998),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );

  }
}