import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/employee.dart';
import 'form_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<Employee> _employees = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  void _loadEmployees() async {
    List<Employee> employees = await _dbHelper.getEmployees();
    setState(() {
      _employees = employees;
    });
  }

  void _deleteEmployee(int id) async {
    await _dbHelper.deleteEmployee(id);
    _loadEmployees();
  }

  void _navigateToForm({Employee? employee}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeFormScreen(employee: employee),
      ),
    );
    if (result == true) {
      _loadEmployees();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistem Penggajian Mobile'),
      ),
      body: _employees.isEmpty
          ? Center(child: Text('Tidak ada data karyawan'))
          : ListView.builder(
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                Employee employee = _employees[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(employee.name),
                    subtitle: Text('${employee.position} - Total Gaji: Rp ${employee.totalSalary.toStringAsFixed(0)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _navigateToForm(employee: employee),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteEmployee(employee.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: Icon(Icons.add),
        tooltip: 'Tambah Karyawan',
      ),
    );
  }
}
