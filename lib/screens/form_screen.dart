import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/employee.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee;

  EmployeeFormScreen({this.employee});

  @override
  _EmployeeFormScreenState createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _basicSalaryController;
  late TextEditingController _allowanceController;
  late TextEditingController _deductionController;

  double _totalSalary = 0.0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _positionController = TextEditingController(text: widget.employee?.position ?? '');
    _basicSalaryController = TextEditingController(text: widget.employee?.basicSalary.toString() ?? '');
    _allowanceController = TextEditingController(text: widget.employee?.allowance.toString() ?? '');
    _deductionController = TextEditingController(text: widget.employee?.deduction.toString() ?? '');
    _calculateTotalSalary();
  }

  void _calculateTotalSalary() {
    double basicSalary = double.tryParse(_basicSalaryController.text) ?? 0.0;
    double allowance = double.tryParse(_allowanceController.text) ?? 0.0;
    double deduction = double.tryParse(_deductionController.text) ?? 0.0;
    setState(() {
      _totalSalary = basicSalary + allowance - deduction;
    });
  }

  void _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      Employee employee = Employee(
        id: widget.employee?.id,
        name: _nameController.text,
        position: _positionController.text,
        basicSalary: double.parse(_basicSalaryController.text),
        allowance: double.parse(_allowanceController.text),
        deduction: double.parse(_deductionController.text),
      );
      employee.calculateTotalSalary();

      if (widget.employee == null) {
        await _dbHelper.insertEmployee(employee);
      } else {
        await _dbHelper.updateEmployee(employee);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? 'Tambah Karyawan' : 'Edit Karyawan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Karyawan'),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(labelText: 'Jabatan'),
                validator: (value) => value!.isEmpty ? 'Jabatan tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _basicSalaryController,
                decoration: InputDecoration(labelText: 'Gaji Pokok'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _calculateTotalSalary(),
                validator: (value) => value!.isEmpty ? 'Gaji Pokok tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _allowanceController,
                decoration: InputDecoration(labelText: 'Tunjangan'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _calculateTotalSalary(),
                validator: (value) => value!.isEmpty ? 'Tunjangan tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _deductionController,
                decoration: InputDecoration(labelText: 'Potongan'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _calculateTotalSalary(),
                validator: (value) => value!.isEmpty ? 'Potongan tidak boleh kosong' : null,
              ),
              SizedBox(height: 20),
              Text('Total Gaji: Rp ${_totalSalary.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEmployee,
                child: Text(widget.employee == null ? 'Simpan' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
