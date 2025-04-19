// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class ViewOpportunitiesPage extends StatefulWidget {
//   @override
//   _ViewOpportunitiesPageState createState() => _ViewOpportunitiesPageState();
// }
//
// class _ViewOpportunitiesPageState extends State<ViewOpportunitiesPage> {
//   List<dynamic> opportunities = [];
//   bool isLoading = true;
//   String errorMessage = '';
//
//   Future<void> fetchOpportunities() async {
//     final url = Uri.parse('http://127.0.0.1:8000/api/opportunities/'); // Ensure your API URL is correct.
//     try {
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         setState(() {
//           opportunities = jsonDecode(response.body); // Assuming the response is an array
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Failed to load opportunities. Status code: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'An error occurred: $e';
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchOpportunities();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upcoming Opportunities', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.deepPurple,
//         elevation: 0,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(16),
//           ),
//         ),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())  // Loading indicator
//           : errorMessage.isNotEmpty
//           ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))  // Error message
//           : opportunities.isEmpty
//           ? Center(child: Text('No opportunities available.'))  // No opportunities available message
//           : ListView.builder(
//         itemCount: opportunities.length,
//         itemBuilder: (context, index) {
//           final opp = opportunities[index];
//           return Card(
//             margin: EdgeInsets.all(10),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 5,
//             child: ListTile(
//               contentPadding: EdgeInsets.all(16),
//               title: Text(
//                 opp['title'] ?? 'No title available',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               subtitle: Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Company: ${opp['company_name'] ?? 'No company name available'}',
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Type: ${opp['opportunity_type'] ?? 'No type available'}',
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Deadline: ${opp['deadline'] ?? 'No deadline available'}',
//                       style: TextStyle(color: Colors.redAccent),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Model to represent the Opportunity
class Opportunity {
  final int id;
  final String title;
  final String description;
  final String companyName;
  final String opportunityType;
  final String deadline;

  Opportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.companyName,
    required this.opportunityType,
    required this.deadline,
  });

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      companyName: json['company_name'],
      opportunityType: json['opportunity_type'],
      deadline: json['deadline'],
    );
  }
}

// Service to fetch the opportunities from Django API
class OpportunityService {
  static const String apiUrl = 'http://10.0.2.2:8000/api/opportunities/';

  Future<List<Opportunity>> fetchOpportunities() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Opportunity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load opportunities');
    }
  }
}

// Flutter page to display the opportunities
class OpportunityPage extends StatefulWidget {
  @override
  _OpportunityPageState createState() => _OpportunityPageState();
}

class _OpportunityPageState extends State<OpportunityPage> {
  late Future<List<Opportunity>> opportunities;
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    opportunities = OpportunityService().fetchOpportunities();
  }

  // Get color based on opportunity type
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'internship':
        return Colors.blue;
      case 'placement':
        return Colors.green;
      case 'volunteer':
        return Colors.purple;
      case 'event':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opportunities', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                opportunities = OpportunityService().fetchOpportunities();
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'All', child: Text('All Types')),
                  PopupMenuItem(
                    value: 'Internship',
                    child: Text('Internships'),
                  ),
                  PopupMenuItem(value: 'Placement', child: Text('Placement')),
                  PopupMenuItem(value: 'Volunteer', child: Text('Volunteer')),
                  PopupMenuItem(value: 'Event', child: Text('Events')),
                ],
            icon: Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFe0c3fc), // Light purple
              Color(0xFF8ec5fc), // Light blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Opportunity>>(
          future: opportunities,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading opportunities...',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          opportunities =
                              OpportunityService().fetchOpportunities();
                        });
                      },
                      child: Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No opportunities available.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            } else {
              final allOpportunities = snapshot.data!;
              final filteredOpportunities =
                  _filter == 'All'
                      ? allOpportunities
                      : allOpportunities
                          .where(
                            (opp) =>
                                opp.opportunityType.toLowerCase() ==
                                _filter.toLowerCase(),
                          )
                          .toList();

              if (filteredOpportunities.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.filter_alt_off, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No $_filter opportunities available.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      TextButton.icon(
                        icon: Icon(Icons.clear),
                        label: Text('Clear Filter'),
                        onPressed: () {
                          setState(() {
                            _filter = 'All';
                          });
                        },
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      _filter == 'All'
                          ? 'All Opportunities (${filteredOpportunities.length})'
                          : '$_filter Opportunities (${filteredOpportunities.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: filteredOpportunities.length,
                      itemBuilder: (context, index) {
                        final opportunity = filteredOpportunities[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              _showOpportunityDetails(context, opportunity);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          opportunity.title,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getTypeColor(
                                            opportunity.opportunityType,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          opportunity.opportunityType,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.business,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        opportunity.companyName,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Deadline: ${opportunity.deadline}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    opportunity.description.length > 100
                                        ? '${opportunity.description.substring(0, 100)}...'
                                        : opportunity.description,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      icon: Icon(Icons.arrow_forward),
                                      label: Text('View Details'),
                                      onPressed: () {
                                        _showOpportunityDetails(
                                          context,
                                          opportunity,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.bookmark_add, color: Colors.white),
        label: const Text(
          'Add Opportunity',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          Navigator.pushNamed(context, '/add-opportunity');
        },
      ),
    );
  }

  void _showOpportunityDetails(BuildContext context, Opportunity opportunity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder:
                (_, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                opportunity.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getTypeColor(
                                  opportunity.opportunityType,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                opportunity.opportunityType,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailRow(
                                Icons.business,
                                'Company',
                                opportunity.companyName,
                              ),
                              SizedBox(height: 12),
                              _detailRow(
                                Icons.calendar_today,
                                'Application Deadline',
                                opportunity.deadline,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          opportunity.description,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: Icon(Icons.send),
                                label: Text('Apply Now'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Application feature coming soon',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: Icon(Icons.bookmark_border),
                              label: Text('Save'),
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Saved to favorites')),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
          ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
