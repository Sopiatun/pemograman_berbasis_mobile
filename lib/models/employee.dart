class Employee {
  int? id;
  String name;
  String position;
  double basicSalary;
  double allowance;
  double deduction;
  double totalSalary;

  Employee({
    this.id,
    required this.name,
    required this.position,
    required this.basicSalary,
    required this.allowance,
    required this.deduction,
  }) : totalSalary = basicSalary + allowance - deduction;

  void calculateTotalSalary() {
    totalSalary = basicSalary + allowance - deduction;
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      basicSalary: map['basicSalary'],
      allowance: map['allowance'],
      deduction: map['deduction'],
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'basicSalary': basicSalary,
      'allowance': allowance,
      'deduction': deduction,
      'totalSalary': totalSalary,
    };
  }
}
