// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:vv/Caregiver/mainpagecaregiver/AssignedPatients.dart';
// import 'package:vv/Family/mainpagefamily/mainpagefamily.dart';
// import 'package:vv/api/login_api.dart';
// import 'package:vv/page/assign_patient.dart';

// class AddPatientScreen extends StatefulWidget {
//   @override
//   _AddPatientScreenState createState() => _AddPatientScreenState();
// }

// class _AddPatientScreenState extends State<AddPatientScreen> {
//   String patientCode = 'Loading...';

//   @override
//   void initState() {
//     super.initState();
//     _fetchcaregiverCode();
//   }

//   Future<void> _fetchcaregiverCode() async {
//     try {
//       final response = await DioService().dio.get(
//           'https://electronicmindofalzheimerpatients.azurewebsites.net/Caregiver/GetCaregiverCode');
//       if (response.statusCode == 200) {
//         var responseData = response.data;
//         String code = responseData['code'];
//         setState(() {
//           patientCode = code;
//         });
//       } else {
//         _navigateToGetAssignedPatientsScreen(); // No patient code found, navigate directly
//       }
//     } catch (e) {
//       _navigateToGetAssignedPatientsScreen(); // Error occurred, navigate directly
//       print(e);
//     }
//   }

//   void _navigateToGetAssignedPatientsScreen() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   AssignedPatients()), // Ensure this is the correct class name for your Assign Patient Screen
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // If patientCode is still 'Loading...', we show a loading indicator instead of immediately building the UI
//     if (patientCode == 'Loading...') {
//       return Scaffold(
//         backgroundColor: Colors.grey.shade300,
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     // Once patientCode is fetched, or if an error occurs (and is handled), the below UI is built
//     return Scaffold(
//       backgroundColor: Colors.grey.shade300,
//       body: Center(
//         child: Container(
//           width: double.infinity,
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Colors.transparent, Colors.blue.shade900],
//             ),
//           ),
//           child: Align(
//             alignment: Alignment.center,
//             child: Container(
//               width: 300,
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 8.0,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Text(
//                     'Add Patient',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 24),
//                   TextField(
//                     decoration: InputDecoration(
//                       labelText: 'Patient ID',
//                       border: OutlineInputBorder(
//                         borderRadius:
//                             BorderRadius.circular(8.0), // Rounded corners
//                         borderSide: BorderSide(
//                           color: Colors.black, // Default border color
//                           width: 1.0, // Default border width
//                         ),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                           vertical: 20.0, horizontal: 10.0),
//                       suffixIcon: IconButton(
//                         icon: Icon(Icons.copy),
//                         onPressed: () {
//                           Clipboard.setData(ClipboardData(text: patientCode))
//                               .then((_) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content:
//                                     Text('Patient ID copied to clipboard!'),
//                                 duration: Duration(seconds: 2),
//                               ),
//                             );
//                           });
//                         },
//                       ),
//                     ),
//                     readOnly: true,
//                     controller: TextEditingController(text: patientCode),
//                     style: TextStyle(fontSize: 20),
//                     maxLines: null,
//                     keyboardType: TextInputType.multiline,
//                   ),
//                   SizedBox(height: 24),
//                   Text(
//                     'Please send it to anyone responsible for the patient',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.grey.shade600),
//                   ),
//                   SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 mainpagefamily()), // Ensure this is the correct class name for your Main Page Family
//                       );
//                     },
//                     child: Text(
//                       'Done',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       fixedSize: Size(150, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vv/Caregiver/mainpagecaregiver/mainpagecaregiver.dart';
import 'package:vv/api/login_api.dart';

class caregiverCode extends StatefulWidget {
  const caregiverCode({super.key});

  @override
  State<caregiverCode> createState() => _caregiverCodeState();
}

class _caregiverCodeState extends State<caregiverCode> {
  String caregiverCode = 'Loading...'.tr();
  @override
  void initState() {
    super.initState();
    fetchAndSetCaregiverCode();
  }

  Future<void> fetchAndSetCaregiverCode() async {
    try {
      final response = await DioService().dio.get(
          'https://electronicmindofalzheimerpatients.azurewebsites.net/Caregiver/GetCaregiverCode');
      if (response.statusCode == 200) {
        setState(() {
          caregiverCode = response
              .data; // Assuming the response data is the code as a String
        });
      } else {
        setState(() {
          caregiverCode =
              'Error loading ID'.tr(); // Set an error message or handle differently
        });
      }
    } catch (e) {
      setState(() {
        caregiverCode =
            'Error: $e'; // Set an error message with exception details
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (caregiverCode == 'Loading...'.tr()) {
      return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Once patientCode is fetched, or if an error occurs (and is handled), the below UI is built
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.blue.shade900],
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                   Text(
                    'Your ID'.tr(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Caregiver ID'.tr(),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                        borderSide: const BorderSide(
                          color: Colors.black, // Default border color
                          width: 1.0, // Default border width
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: caregiverCode))
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                content: Text('Your ID copied to clipboard'.tr()),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                    readOnly: true,
                    controller: TextEditingController(text: caregiverCode),
                    style: const TextStyle(fontSize: 20),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Please send it to the family'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const mainpagecaregiver()), // Ensure this is the correct class name for your Main Page Family
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      fixedSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child:  Text(
                      'Done'.tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
