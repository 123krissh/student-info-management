// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_application_1/constants.dart'; // update if path is different
//
// class AddStudentPage extends StatefulWidget {
//   const AddStudentPage({Key? key}) : super(key: key);
//
//   @override
//   State<AddStudentPage> createState() => _AddStudentPageState();
// }
//
// class _AddStudentPageState extends State<AddStudentPage> {
//   final _formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final rollController = TextEditingController();
//   final emailController = TextEditingController();
//
//   String? selectedDept;
//   String? selectedYear;
//
//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final student = {
//         'name': nameController.text,
//         'roll': rollController.text,
//         'email': emailController.text,
//         'department': selectedDept,
//         'year': selectedYear,
//       };
//
//       try {
//         final response = await http.post(
//           Uri.parse(baseUrl),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode(student),
//         );
//
//         print("⬆️ Sent student: $student");
//         print("🔄 Response status: ${response.statusCode}");
//         print("📩 Response body: ${response.body}");
//
//         if (response.statusCode == 201) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('🎉 Student added successfully!')),
//           );
//           Navigator.pop(context);
//         } else {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text('❌ Failed: ${response.body}')));
//         }
//       } catch (e) {
//         print("🔥 Exception: $e");
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error: $e')));
//       }
//     }
//   }
//
//   Widget _buildTextField({
//     required String label,
//     required IconData icon,
//     required TextEditingController controller,
//     required String? Function(String?) validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: Colors.deepPurple),
//           filled: true,
//           fillColor: Colors.white.withOpacity(0.95),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: Colors.grey),
//           ),
//           labelStyle: const TextStyle(fontWeight: FontWeight.w500),
//         ),
//         validator: validator,
//       ),
//     );
//   }
//
//   Widget _buildDropdown<T>({
//     required String label,
//     required IconData icon,
//     required List<T> items,
//     required T? value,
//     required Function(T?) onChanged,
//     required String? Function(T?) validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: DropdownButtonFormField<T>(
//         value: value,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: Colors.deepPurple),
//           filled: true,
//           fillColor: Colors.white.withOpacity(0.95),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//         ),
//         icon: const Icon(Icons.arrow_drop_down),
//         items:
//             items
//                 .map(
//                   (item) => DropdownMenuItem<T>(
//                     value: item,
//                     child: Text(item.toString()),
//                   ),
//                 )
//                 .toList(),
//         onChanged: onChanged,
//         validator: validator,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Student', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.deepPurple,
//         elevation: 0,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(16),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Card(
//                 color: Colors.white.withOpacity(0.9),
//                 elevation: 10,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 30,
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'Enter Student Details',
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.deepPurple,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         _buildTextField(
//                           label: 'Full Name',
//                           icon: Icons.person,
//                           controller: nameController,
//                           validator:
//                               (value) =>
//                                   value!.isEmpty ? 'Please enter name' : null,
//                         ),
//                         _buildTextField(
//                           label: 'Enrollment No',
//                           icon: Icons.confirmation_number,
//                           controller: rollController,
//                           validator:
//                               (value) =>
//                                   value!.isEmpty
//                                       ? 'Please enter roll number'
//                                       : null,
//                         ),
//                         _buildTextField(
//                           label: 'Email',
//                           icon: Icons.email,
//                           controller: emailController,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Enter email';
//                             }
//                             final emailRegex = RegExp(
//                               r'^[\w\.-]+@[\w\.-]+\.\w+$',
//                             );
//                             if (!emailRegex.hasMatch(value)) {
//                               return 'Enter valid email';
//                             }
//                             return null;
//                           },
//                         ),
//                         _buildDropdown<String>(
//                           label: 'Department',
//                           icon: Icons.apartment,
//                           items: const [
//                             'AIDS',
//                             'AIMl',
//                             'CSE',
//                             'VLSI',
//                             'IIOT',
//                             'CSE-CS',
//                             'CSE-AM',
//                           ],
//                           value: selectedDept,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedDept = value;
//                             });
//                           },
//                           validator:
//                               (value) =>
//                                   value == null
//                                       ? 'Please select department'
//                                       : null,
//                         ),
//                         _buildDropdown<String>(
//                           label: 'Year',
//                           icon: Icons.calendar_today,
//                           items: const ['1st', '2nd', '3rd', '4th'],
//                           value: selectedYear,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedYear = value;
//                             });
//                           },
//                           validator:
//                               (value) =>
//                                   value == null ? 'Please select year' : null,
//                         ),
//                         const SizedBox(height: 30),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             onPressed: _submitForm,
//                             icon: const Icon(
//                               Icons.check_circle_outline,
//                               color: Colors.white,
//                             ),
//                             label: const Text(
//                               'Add Student',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               backgroundColor: Colors.deepPurple,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               textStyle: const TextStyle(fontSize: 18),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/constants.dart'; // update if path is different

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final emailController = TextEditingController();

  String? selectedDept;
  String? selectedYear;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final student = {
        'name': nameController.text,
        'roll': rollController.text,
        'email': emailController.text,
        'department': selectedDept,
        'year': selectedYear,
      };

      try {
        final response = await http.post(
          Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(student),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Student added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Failed: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required List<T> items,
    required T? value,
    required Function(T?) onChanged,
    required String? Function(T?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString()),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Add Student', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                shadowColor: Colors.deepPurple.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Enter Student Details',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: 'Full Name',
                          icon: Icons.person,
                          controller: nameController,
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter name' : null,
                        ),
                        _buildTextField(
                          label: 'Enrollment No',
                          icon: Icons.confirmation_number,
                          controller: rollController,
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter roll number' : null,
                        ),
                        _buildTextField(
                          label: 'Email',
                          icon: Icons.email,
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter email';
                            }
                            final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),
                        _buildDropdown<String>(
                          label: 'Department',
                          icon: Icons.apartment,
                          items: const [
                            'AIDS',
                            'AIMl',
                            'CSE',
                            'VLSI',
                            'IIOT',
                            'CSE-CS',
                            'CSE-AM',
                          ],
                          value: selectedDept,
                          onChanged: (value) {
                            setState(() {
                              selectedDept = value;
                            });
                          },
                          validator: (value) =>
                          value == null ? 'Please select department' : null,
                        ),
                        _buildDropdown<String>(
                          label: 'Year',
                          icon: Icons.calendar_today,
                          items: const ['1st', '2nd', '3rd', '4th'],
                          value: selectedYear,
                          onChanged: (value) {
                            setState(() {
                              selectedYear = value;
                            });
                          },
                          validator: (value) =>
                          value == null ? 'Please select year' : null,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _submitForm,
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text('Add Student', style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(fontSize: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 5,
                              shadowColor: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
