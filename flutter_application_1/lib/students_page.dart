// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// // import 'package:file_picker/file_picker.dart';
// import 'dart:io';
//
// class StudentsPage extends StatefulWidget {
//   const StudentsPage({Key? key}) : super(key: key);
//
//   @override
//   State<StudentsPage> createState() => _StudentsPageState();
// }
//
// class _StudentsPageState extends State<StudentsPage> {
//   List students = [];
//   bool isLoading = true;
//
//   final List<String> departments = [
//     'AIDS',
//     'AIMl',
//     'CSE',
//     'VLSI',
//     'IIOT',
//     'CSE-CS',
//     'CSE-AM',
//   ];
//   final List<String> years = ['1st', '2nd', '3rd', '4th'];
//   final String baseUrl = 'http://10.0.2.2:8000/api/students';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchStudents();
//   }
//
//   Future<void> fetchStudents() async {
//     final response = await http.get(Uri.parse(baseUrl));
//     if (response.statusCode == 200) {
//       setState(() {
//         students = jsonDecode(response.body);
//         isLoading = false;
//       });
//     } else {
//       print('Failed to load students');
//     }
//   }
//
//   Future<void> deleteStudent(int id) async {
//     final response = await http.delete(Uri.parse('$baseUrl/$id/'));
//     if (response.statusCode == 204) {
//       fetchStudents();
//     } else {
//       print('Delete failed');
//     }
//   }
//
//   Future<void> updateStudent(int id, Map<String, dynamic> updatedData) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/$id/'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(updatedData),
//     );
//     if (response.statusCode == 200) {
//       fetchStudents();
//     } else {
//       print('Update failed');
//     }
//   }
//
//   void showEditDialog(int index) {
//     final student = students[index];
//
//     final nameController = TextEditingController(text: student['name']);
//     final rollController = TextEditingController(text: student['roll']);
//     final emailController = TextEditingController(text: student['email']);
//
//     String selectedDepartment =
//         departments.contains(student['department'])
//             ? student['department']
//             : departments.first;
//     String selectedYear =
//         years.contains(student['year']) ? student['year'] : years.first;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           title: const Text('Edit Student'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 _customTextField('Name', nameController),
//                 _customTextField('Enrollment No', rollController),
//                 _customTextField('Email', emailController),
//                 const SizedBox(height: 12),
//                 DropdownButtonFormField<String>(
//                   value: selectedDepartment,
//                   decoration: const InputDecoration(
//                     labelText: 'Department',
//                     border: OutlineInputBorder(),
//                   ),
//                   items:
//                       departments.map((dept) {
//                         return DropdownMenuItem(value: dept, child: Text(dept));
//                       }).toList(),
//                   onChanged: (value) {
//                     selectedDepartment = value ?? selectedDepartment;
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 DropdownButtonFormField<String>(
//                   value: selectedYear,
//                   decoration: const InputDecoration(
//                     labelText: 'Year',
//                     border: OutlineInputBorder(),
//                   ),
//                   items:
//                       years.map((yr) {
//                         return DropdownMenuItem(value: yr, child: Text(yr));
//                       }).toList(),
//                   onChanged: (value) {
//                     selectedYear = value ?? selectedYear;
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 updateStudent(student['id'], {
//                   'name': nameController.text,
//                   'roll': rollController.text,
//                   'email': emailController.text,
//                   'department': selectedDepartment,
//                   'year': selectedYear,
//                 });
//                 Navigator.pop(context);
//               },
//               child: const Text(
//                 'Save',
//                 style: TextStyle(color: Colors.deepPurple),
//               ),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void showAddInternshipDialog(int studentId) {
//     final companyController = TextEditingController();
//     final titleController = TextEditingController();
//     final descriptionController = TextEditingController();
//     final durationController = TextEditingController();
//     DateTime? startDate;
//     DateTime? endDate;
//     File? selectedFile;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Add Internship"),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 _customTextField('Company Name', companyController),
//                 _customTextField('Position/Title', titleController),
//                 _customTextField(
//                   'Duration (e.g. 3 months)',
//                   durationController,
//                 ),
//                 _customTextField('Description', descriptionController),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () async {
//                     startDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2010),
//                       lastDate: DateTime(2100),
//                     );
//                     setState(() {});
//                   },
//                   child: Text(
//                     startDate == null
//                         ? "Select Start Date"
//                         : "Start: ${startDate!.toLocal()}".split(' ')[0],
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     endDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2010),
//                       lastDate: DateTime(2100),
//                     );
//                     setState(() {});
//                   },
//                   child: Text(
//                     endDate == null
//                         ? "Select End Date"
//                         : "End: ${endDate!.toLocal()}".split(' ')[0],
//                   ),
//                 ),
//                 // ElevatedButton.icon(
//                 //   icon: const Icon(Icons.upload_file),
//                 //   label: const Text("Upload Certificate"),
//                 //   onPressed: () async {
//                 //     final result = await FilePicker.platform.pickFiles(
//                 //       type: FileType.custom,
//                 //       allowedExtensions: ['pdf', 'jpg', 'png'],
//                 //     );
//                 //     if (result != null) {
//                 //       selectedFile = File(result.files.single.path!);
//                 //     }
//                 //   },
//                 // ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 final uri = Uri.parse(
//                   'http://10.0.2.2:8000/api/students/$studentId/add-internship/',
//                 );
//                 var request = http.MultipartRequest('POST', uri);
//                 request.fields['company_name'] = companyController.text;
//                 request.fields['position'] = titleController.text;
//                 request.fields['description'] = descriptionController.text;
//                 request.fields['duration'] = durationController.text;
//                 request.fields['start_date'] =
//                     startDate?.toIso8601String() ?? '';
//                 request.fields['end_date'] = endDate?.toIso8601String() ?? '';
//                 if (selectedFile != null) {
//                   request.files.add(
//                     await http.MultipartFile.fromPath(
//                       'certificate',
//                       selectedFile!.path,
//                     ),
//                   );
//                 }
//                 var response = await request.send();
//                 if (response.statusCode == 201) {
//                   Navigator.pop(context);
//                   fetchStudents();
//                 } else {
//                   print("Internship upload failed");
//                 }
//               },
//               child: const Text("Save"),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void showAddProjectDialog(int studentId) {
//     final titleController = TextEditingController();
//     final descriptionController = TextEditingController();
//     final githubController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Add Project"),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 _customTextField("Project Title", titleController),
//                 _customTextField("Description", descriptionController),
//                 _customTextField("GitHub Link", githubController),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 final response = await http.post(
//                   Uri.parse(
//                     'http://10.0.2.2:8000/api/students/$studentId/add-project/',
//                   ),
//                   headers: {"Content-Type": "application/json"},
//                   body: jsonEncode({
//                     'title': titleController.text,
//                     'description': descriptionController.text,
//                     'github_link': githubController.text,
//                   }),
//                 );
//                 if (response.statusCode == 201) {
//                   Navigator.pop(context);
//                   fetchStudents();
//                 } else {
//                   print("Project submission failed");
//                 }
//               },
//               child: const Text("Save"),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void showStudentDetailsDialog(Map<String, dynamic> student) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(student['name']),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Enrollment No: ${student['roll']}"),
//                 Text("Email: ${student['email']}"),
//                 Text("Department: ${student['department']}"),
//                 Text("Year: ${student['year']}"),
//                 const SizedBox(height: 12),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.school, color: Colors.white),
//                   label: const Text(
//                     "Add Internship",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     showAddInternshipDialog(student['id']);
//                   },
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.code, color: Colors.white),
//                   label: const Text(
//                     "Add Project",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     showAddProjectDialog(student['id']);
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Internships",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 6),
//                 ...List<Widget>.from(
//                   (student['internships'] ?? []).map((internship) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "- ${internship['company_name']} (${internship['position']})",
//                           ),
//                           Text("  Duration: ${internship['duration']}"),
//                           Text(
//                             "  From: ${internship['start_date']} To: ${internship['end_date']}",
//                           ),
//                           if ((internship['description'] ?? "").isNotEmpty)
//                             Text("  Description: ${internship['description']}"),
//                           if (internship['certificate'] != null)
//                             TextButton(
//                               onPressed: () {
//                                 // Open certificate link if needed
//                               },
//                               child: const Text("View Certificate"),
//                             ),
//                         ],
//                       ),
//                     );
//                   }),
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   "Projects",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 6),
//                 ...List<Widget>.from(
//                   (student['projects'] ?? []).map((project) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("- ${project['title']}"),
//                           if ((project['description'] ?? "").isNotEmpty)
//                             Text("  Description: ${project['description']}"),
//                           if ((project['github_link'] ?? "").isNotEmpty)
//                             Text("  GitHub: ${project['github_link']}"),
//                         ],
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Close"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _customTextField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Student List',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.deepPurple,
//         elevation: 4,
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : students.isEmpty
//               ? const Center(child: Text('No students found.'))
//               : Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: ListView.separated(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: students.length,
//                   separatorBuilder: (_, __) => const SizedBox(height: 12),
//                   itemBuilder: (context, index) {
//                     final student = students[index];
//                     return Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       elevation: 6,
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(16),
//                         title: Text(
//                           student['name'] ?? '',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle: Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Enrollment No: ${student['roll'] ?? 'N/A'}',
//                               ),
//                               Text('Email: ${student['email'] ?? 'N/A'}'),
//                               Text(
//                                 'Department: ${student['department'] ?? 'N/A'}',
//                               ),
//                               Text('Year: ${student['year'] ?? 'N/A'}'),
//                             ],
//                           ),
//                         ),
//                         onTap: () => showStudentDetailsDialog(student),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.edit, color: Colors.blue),
//                               onPressed: () => showEditDialog(index),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () => deleteStudent(student['id']),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.deepPurple,
//         onPressed: () {
//           Navigator.pushNamed(
//             context,
//             '/add-student',
//           ).then((_) => fetchStudents());
//         },
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }





import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  List students = [];
  bool isLoading = true;

  final List<String> departments = [
    'AIDS',
    'AIMl',
    'CSE',
    'VLSI',
    'IIOT',
    'CSE-CS',
    'CSE-AM',
  ];
  final List<String> years = ['1st', '2nd', '3rd', '4th'];
  final String baseUrl = 'http://10.0.2.2:8000/api/students';

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      setState(() {
        students = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      print('Failed to load students');
    }
  }

  Future<void> deleteStudent(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id/'));
    if (response.statusCode == 204) {
      fetchStudents();
    } else {
      print('Delete failed');
    }
  }

  Future<void> updateStudent(int id, Map<String, dynamic> updatedData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );
    if (response.statusCode == 200) {
      fetchStudents();
    } else {
      print('Update failed');
    }
  }

  void showEditDialog(int index) {
    final student = students[index];

    final nameController = TextEditingController(text: student['name']);
    final rollController = TextEditingController(text: student['roll']);
    final emailController = TextEditingController(text: student['email']);

    String selectedDepartment = departments.contains(student['department'])
        ? student['department']
        : departments.first;
    String selectedYear =
    years.contains(student['year']) ? student['year'] : years.first;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Edit Student',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6A1B9A),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _customTextField('Name', nameController),
                _customTextField('Enrollment No', rollController),
                _customTextField('Email', emailController),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedDepartment,
                  decoration: InputDecoration(
                    labelText: 'Department',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    labelStyle: TextStyle(color: Colors.deepPurple[700]),
                  ),
                  items: departments.map((dept) {
                    return DropdownMenuItem(value: dept, child: Text(dept));
                  }).toList(),
                  onChanged: (value) {
                    selectedDepartment = value ?? selectedDepartment;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedYear,
                  decoration: InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    labelStyle: TextStyle(color: Colors.deepPurple[700]),
                  ),
                  items: years.map((yr) {
                    return DropdownMenuItem(value: yr, child: Text(yr));
                  }).toList(),
                  onChanged: (value) {
                    selectedYear = value ?? selectedYear;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                updateStudent(student['id'], {
                  'name': nameController.text,
                  'roll': rollController.text,
                  'email': emailController.text,
                  'department': selectedDepartment,
                  'year': selectedYear,
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // void showAddInternshipDialog(int studentId) {
  //   final companyController = TextEditingController();
  //   final titleController = TextEditingController();
  //   final descriptionController = TextEditingController();
  //   final durationController = TextEditingController();
  //   DateTime? startDate;
  //   DateTime? endDate;
  //   File? selectedFile;
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         title: const Text(
  //           "Add Internship",
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             color: Color(0xFF6A1B9A),
  //           ),
  //         ),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               _customTextField('Company Name', companyController),
  //               _customTextField('Position/Title', titleController),
  //               _customTextField(
  //                 'Duration (e.g. 3 months)',
  //                 durationController,
  //               ),
  //               _customTextField('Description', descriptionController, maxLines: 3),
  //               const SizedBox(height: 16),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: ElevatedButton.icon(
  //                       icon: const Icon(Icons.calendar_today, size: 18),
  //                       label: Text(
  //                         startDate == null
  //                             ? "Start Date"
  //                             : "${startDate!.day}/${startDate!.month}/${startDate!.year}",
  //                         style: const TextStyle(fontSize: 14),
  //                       ),
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.deepPurple[100],
  //                         foregroundColor: Colors.deepPurple[800],
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(vertical: 12),
  //                       ),
  //                       onPressed: () async {
  //                         startDate = await showDatePicker(
  //                           context: context,
  //                           initialDate: DateTime.now(),
  //                           firstDate: DateTime(2010),
  //                           lastDate: DateTime(2100),
  //                           builder: (context, child) {
  //                             return Theme(
  //                               data: Theme.of(context).copyWith(
  //                                 colorScheme: ColorScheme.light(
  //                                   primary: Colors.deepPurple[400]!,
  //                                 ),
  //                               ),
  //                               child: child!,
  //                             );
  //                           },
  //                         );
  //                         setState(() {});
  //                       },
  //                     ),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   Expanded(
  //                     child: ElevatedButton.icon(
  //                       icon: const Icon(Icons.calendar_today, size: 18),
  //                       label: Text(
  //                         endDate == null
  //                             ? "End Date"
  //                             : "${endDate!.day}/${endDate!.month}/${endDate!.year}",
  //                         style: const TextStyle(fontSize: 14),
  //                       ),
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.deepPurple[100],
  //                         foregroundColor: Colors.deepPurple[800],
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(vertical: 12),
  //                       ),
  //                       onPressed: () async {
  //                         endDate = await showDatePicker(
  //                           context: context,
  //                           initialDate: DateTime.now(),
  //                           firstDate: DateTime(2010),
  //                           lastDate: DateTime(2100),
  //                           builder: (context, child) {
  //                             return Theme(
  //                               data: Theme.of(context).copyWith(
  //                                 colorScheme: ColorScheme.light(
  //                                   primary: Colors.deepPurple[400]!,
  //                                 ),
  //                               ),
  //                               child: child!,
  //                             );
  //                           },
  //                         );
  //                         setState(() {});
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 16),
  //               // Commented out as in original code
  //               ElevatedButton.icon(
  //                 icon: const Icon(Icons.upload_file),
  //                 label: const Text("Upload Certificate"),
  //                 onPressed: () async {
  //                   final result = await FilePicker.platform.pickFiles(
  //                     type: FileType.custom,
  //                     allowedExtensions: ['pdf', 'jpg', 'png'],
  //                   );
  //                   if (result != null) {
  //                     selectedFile = File(result.files.single.path!);
  //                   }
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text(
  //               'Cancel',
  //               style: TextStyle(color: Colors.grey[700]),
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               final uri = Uri.parse(
  //                 'http://10.0.2.2:8000/api/students/$studentId/add-internship/',
  //               );
  //               var request = http.MultipartRequest('POST', uri);
  //               request.fields['company_name'] = companyController.text;
  //               request.fields['position'] = titleController.text;
  //               request.fields['description'] = descriptionController.text;
  //               request.fields['duration'] = durationController.text;
  //               request.fields['start_date'] = startDate?.toIso8601String() ?? '';
  //               request.fields['end_date'] = endDate?.toIso8601String() ?? '';
  //               if (selectedFile != null) {
  //                 request.files.add(
  //                   await http.MultipartFile.fromPath(
  //                     'certificate',
  //                     selectedFile!.path,
  //                   ),
  //                 );
  //               }
  //               var response = await request.send();
  //               if (response.statusCode == 201) {
  //                 Navigator.pop(context);
  //                 fetchStudents();
  //               } else {
  //                 print("Internship upload failed");
  //               }
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.deepPurple,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //             ),
  //             child: const Text(
  //               "Save",
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  void showAddInternshipDialog(int studentId) {
    final companyController = TextEditingController();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final durationController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;
    File? selectedFile;
    String? fileName;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                "Add Internship",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    _customTextField('Company Name', companyController),
                    _customTextField('Position/Title', titleController),
                    _customTextField('Duration (e.g. 3 months)', durationController),
                    _customTextField('Description', descriptionController, maxLines: 3),
                    const SizedBox(height: 16),

                    // Start & End Date Pickers
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.calendar_today, size: 18),
                            label: Text(
                              startDate == null
                                  ? "Start Date"
                                  : "${startDate!.day}/${startDate!.month}/${startDate!.year}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple[100],
                              foregroundColor: Colors.deepPurple[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2010),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Colors.deepPurple[400]!,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() => startDate = picked);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.calendar_today, size: 18),
                            label: Text(
                              endDate == null
                                  ? "End Date"
                                  : "${endDate!.day}/${endDate!.month}/${endDate!.year}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple[100],
                              foregroundColor: Colors.deepPurple[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2010),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Colors.deepPurple[400]!,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() => endDate = picked);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // File Upload Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: Text(fileName ?? "Upload Certificate"),
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'jpg', 'png'],
                        );
                        if (result != null && result.files.single.path != null) {
                          setState(() {
                            selectedFile = File(result.files.single.path!);
                            fileName = result.files.single.name;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (companyController.text.isEmpty ||
                        titleController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        durationController.text.isEmpty ||
                        startDate == null ||
                        endDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    final uri = Uri.parse('http://10.0.2.2:8000/api/students/$studentId/add-internship/');
                    var request = http.MultipartRequest('POST', uri);
                    request.fields['company_name'] = companyController.text;
                    request.fields['position'] = titleController.text;
                    request.fields['description'] = descriptionController.text;
                    request.fields['duration'] = durationController.text;
                    request.fields['start_date'] = startDate!.toIso8601String();
                    request.fields['end_date'] = endDate!.toIso8601String();
                    if (selectedFile != null) {
                      request.files.add(await http.MultipartFile.fromPath(
                        'certificate',
                        selectedFile!.path,
                      ));
                    }

                    var response = await request.send();
                    if (response.statusCode == 201) {
                      Navigator.pop(context);
                      fetchStudents();
                    } else {
                      print("Internship upload failed");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to add internship")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void showAddProjectDialog(int studentId) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final githubController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Add Project",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6A1B9A),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _customTextField("Project Title", titleController),
                _customTextField("Description", descriptionController, maxLines: 3),
                _customTextField("GitHub Link", githubController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse(
                    'http://10.0.2.2:8000/api/students/$studentId/add-project/',
                  ),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'github_link': githubController.text,
                  }),
                );
                if (response.statusCode == 201) {
                  Navigator.pop(context);
                  fetchStudents();
                } else {
                  print("Project submission failed");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void showStudentDetailsDialog(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.deepPurple[100],
                child: Text(
                  student['name'][0] ?? 'S',
                  style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  student['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _infoTile("Enrollment No", student['roll'] ?? 'N/A', Icons.numbers),
                _infoTile("Email", student['email'] ?? 'N/A', Icons.email),
                _infoTile("Department", student['department'] ?? 'N/A', Icons.school),
                _infoTile("Year", student['year'] ?? 'N/A', Icons.calendar_today),
                const Divider(),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.work, size: 18),
                        label: const Text("Add Internship"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showAddInternshipDialog(student['id']);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.code, size: 18),
                        label: const Text("Add Project"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showAddProjectDialog(student['id']);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                _sectionHeader("Internships", Icons.work),
                const Divider(),
                (student['internships'] ?? []).isEmpty
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "No internships added yet",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
                    : Column(
                  children: List<Widget>.from(
                    (student['internships'] ?? []).map((internship) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.business, color: Colors.deepPurple[400], size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${internship['company_name']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Position: ${internship['position']}",
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text("Duration: ${internship['duration']}"),
                              Text(
                                "Period: ${internship['start_date']?.split('T')[0] ?? 'N/A'} to ${internship['end_date']?.split('T')[0] ?? 'N/A'}",
                              ),
                              if ((internship['description'] ?? "").isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text("Description: ${internship['description']}"),
                                ),
                              if (internship['certificate'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.visibility, size: 16),
                                    label: const Text("View Certificate"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple[100],
                                      foregroundColor: Colors.deepPurple[800],
                                      minimumSize: const Size(0, 36),
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                    ),
                                    onPressed: () {
                                      // Open certificate link if needed
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 24),
                _sectionHeader("Projects", Icons.code),
                const Divider(),
                (student['projects'] ?? []).isEmpty
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "No projects added yet",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
                    : Column(
                  children: List<Widget>.from(
                    (student['projects'] ?? []).map((project) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.code, color: Colors.deepPurple[400], size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      project['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if ((project['description'] ?? "").isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text("Description: ${project['description']}"),
                                ),
                              if ((project['github_link'] ?? "").isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.link, size: 16, color: Colors.blue[700]),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          project['github_link'],
                                          style: TextStyle(
                                            color: Colors.blue[700],
                                            decoration: TextDecoration.underline,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.deepPurple[400]),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple[700], size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.deepPurple[800],
          ),
        ),
      ],
    );
  }

  Widget _customTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.deepPurple[700]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple[400]!, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text(
        'Student List',
        style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
    ),
    ),
    backgroundColor: Colors.deepPurple,
    elevation: 0,
    shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
    bottom: Radius.circular(16),
    ),
    ),
    actions: [
    IconButton(
    icon: const Icon(Icons.refresh, color: Colors.white),
    onPressed: fetchStudents,
    ),
    ],
    ),
    body: isLoading
    ? Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
    ),
    const SizedBox(height: 16),
    Text(
    'Loading students...',
    style: TextStyle(
    color: Colors.grey[700],
    fontWeight: FontWeight.w500,
    ),
    ),
    ],
    ),
    )
        : students.isEmpty
    ? Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(
    Icons.person_search,
    size: 80,
    color: Colors.grey[400],
    ),
    const SizedBox(height: 16),
    Text(
    'No students found',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.grey[700],
    ),
    ),
    const SizedBox(height: 8),
    Text(
    'Add a new student to get started',
    style: TextStyle(
    fontSize: 14,
    color: Colors.grey[600],
    ),
    ),
    const SizedBox(height: 24),
    ElevatedButton.icon(
    icon: const Icon(Icons.add),
    label: const Text('Add Student'),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.deepPurple,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    onPressed: () {
    Navigator.pushNamed(
    context,
    '/add-student',
    ).then((_) => fetchStudents());
    },
    ),
    ],
    ),
    )
        : Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [
    const Color(0xFFE0C3FC).withOpacity(0.7),
    const Color(0xFF8EC5FC).withOpacity(0.7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
    child: ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: students.length,
    itemBuilder: (context, index) {
    final student = students[index];
    return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 10,
    offset: const Offset(0, 4),
    ),
    ],
    ),
    child: Card(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0,
    child: ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Material(
    color: Colors.white,
    child: InkWell(
    onTap: () => showStudentDetailsDialog(student),
    splashColor: Colors.deepPurple.withOpacity(0.1),
    highlightColor: Colors.deepPurple.withOpacity(0.05),
    child: Column(
    children: [
    Container(
    decoration: const BoxDecoration(
    color: Colors.deepPurple,
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(4),
    topRight: Radius.circular(4),
    ),
    ),
    height: 8,
    ),
    Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
    children: [
    CircleAvatar(
    radius: 28,
    backgroundColor: Colors.deepPurple[100],
    child: Text(
    student['name']?[0] ?? 'S',
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
      color: Colors.deepPurple[800],
      // fontWeight: FontWeight.bold,
      // fontSize: 24,
    ),
    ),
    ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student['name'] ?? 'Unknown',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.numbers, size: 14, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Text(
                  student['roll'] ?? 'N/A',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.school, size: 14, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Text(
                  '${student['department'] ?? 'N/A'} - ${student['year'] ?? 'N/A'} Year',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Column(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue[700]),
            onPressed: () => showEditDialog(index),
            iconSize: 22,
            tooltip: 'Edit Student',
            splashRadius: 24,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red[700]),
            onPressed: () => _showDeleteConfirmation(student),
            iconSize: 22,
            tooltip: 'Delete Student',
            splashRadius: 24,
          ),
        ],
      ),
    ],
    ),
    ),
      Row(
        children: [
          Expanded(
            child: _infoChip(
              'Internships',
              (student['internships'] ?? []).length.toString(),
              Icons.work,
              Colors.amber[700]!,
            ),
          ),
          Expanded(
            child: _infoChip(
              'Projects',
              (student['projects'] ?? []).length.toString(),
              Icons.code,
              Colors.teal[700]!,
            ),
          ),
        ],
      ),
    ],
    ),
    ),
    ),
    ),
    ),
    );
    },
    ),
    ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          'Add Student',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add-student',
          ).then((_) => fetchStudents());
        },
      ),
    );
  }

  Widget _infoChip(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Confirm Delete',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A1B9A),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete ${student['name']}?',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              deleteStudent(student['id']);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}