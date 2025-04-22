// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// class UserManagementTable extends StatefulWidget {
//   const UserManagementTable({super.key});

//   @override
//   State<UserManagementTable> createState() => _UserManagementTableState();
// }

// class _UserManagementTableState extends State<UserManagementTable> {
//   List<Map<String, dynamic>> _users = [];
//   bool _isLoading = true;
//   String? _error;

//   final Dio _dio = Dio();
//   final String baseUrl = 'http://127.0.0.1:5566/admin/get-users'; // Replace with your actual API URL

//   @override
//   void initState() {
//     super.initState();
//     _loadUsers();
//   }

// Future<void> _loadUsers() async {
//   try {
//     final response = await _dio.get('$baseUrl'); // Update path if needed
//     if (response.statusCode == 200 && response.data['retCode'] == '200') {
//       setState(() {
//         _users = List<Map<String, dynamic>>.from(response.data['data']);
//         _isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load users');
//     }
//   } catch (e) {
//     setState(() {
//       _error = e.toString();
//       _isLoading = false;
//     });
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_error != null) {
//       return Center(child: Text('Error: $_error'));
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(padding: EdgeInsets.all(16.0)),
//         _buildTableHeader(),
//         Expanded(
//           child: ListView.builder(
//             itemCount: _users.length,
//             itemBuilder: (context, index) {
//               final user = _users[index];
//               return _buildUserCard(user);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTableHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         children: [
//           _buildHeaderText('User ID'),
//           _buildHeaderText('Name'),
//           _buildHeaderText('Email'),
//           _buildHeaderText('Program'),
//           _buildHeaderText('Year Level'),
//           _buildHeaderText('Contact Number'),
//           _buildHeaderText('Actions', isAction: true),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserCard(Map<String, dynamic> user) {
//     return Card(
//       color: const Color.fromARGB(255, 251, 251, 251),
//       margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       elevation: 5,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: DefaultTextStyle(
//           style: const TextStyle(color: Colors.black),
//           child: Row(
//             children: [
//               Expanded(child: Text('${user['user_id']}')),
//               Expanded(child: Text('${user['name']}')),
//               Expanded(child: Text('${user['email']}')),
//               Expanded(child: Text('${user['program']}')),
//               Expanded(child: Text('${user['year_level']}')),
//               Expanded(child: Text('${user['contact_number']}')),
//               SizedBox(
//                 width: 180,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text('View', style: TextStyle(fontSize: 12, color: Colors.blue)),
//                     ),
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text('Edit', style: TextStyle(fontSize: 12, color: Colors.orange)),
//                     ),
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text('Delete', style: TextStyle(fontSize: 12, color: Colors.red)),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderText(String text, {bool isAction = false}) {
//     final headerContent = Container(
//       color: Colors.blueGrey[700],
//       padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 12,
//           color: Colors.white,
//         ),
//         textAlign: TextAlign.left,
//       ),
//     );

//     return isAction
//         ? SizedBox(width: 180, child: headerContent)
//         : Expanded(child: headerContent);
//   }
// }
