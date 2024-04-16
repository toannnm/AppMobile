class Package {
  final int id;
  final String packageName;
  final int numberOfDays;
  final int numberOfSessions;
  final double packagePrice;
  final String type;
  final double price;
  final int status;
  final List<Map<String, dynamic>> schedules; 
  final DateTime? startDate;
  final DateTime? endDate;

  Package({
    required this.id,
    required this.packageName,
    required this.numberOfDays,
    required this.numberOfSessions,
    required this.packagePrice,
    required this.type,
    required this.price,
    required this.status,
    required this.schedules,
    this.startDate,
    this.endDate,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      packageName: json['packageName'],
      numberOfDays: json['numberOfDays'],
      numberOfSessions: json['numberOfSessions'],
      packagePrice: json['packagePrice'],
      type: json['type'],
      price: json['price'],
      status: json['status'],
      schedules: List<Map<String, dynamic>>.from(json['schedules'].map((schedule) => {
        'day': schedule['day'],
        'time': schedule['time'],
      })),
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }
}
