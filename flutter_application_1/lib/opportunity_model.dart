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
