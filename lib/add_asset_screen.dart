import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'database_service.dart'; // Now contains DataService
import 'asset.dart';
import 'main.dart'; // For the global supabase client

class AddAssetScreen extends StatefulWidget {
  const AddAssetScreen({super.key});

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dataService = DataService(); // Corrected service name
  final _uuid = const Uuid();
  bool _isLoading = false;

  // ... (All controllers and state variables are here)
  final _nameController = TextEditingController();
  final _sourceController = TextEditingController();
  final _initialValueController = TextEditingController();
  final _unitSukController = TextEditingController();
  final _lifeYearsController = TextEditingController();
  final _notesController = TextEditingController();
  final _stockSistemController = TextEditingController(text: '0');
  final _stockFisikController = TextEditingController(text: '0');

  String? _selectedCategory;
  String? _selectedType;
  String? _selectedWorkUnit;
  String? _selectedLocation;
  String? _selectedCondition;
  DateTime? _selectedReceivedAt;
  String _generatedAssetCode = '';
  
  final List<String> _categories = ['Elektronik', 'Mebel', 'Kendaraan'];
  final List<String> _types = ['Laptop', 'Meja', 'Mobil'];
  final List<String> _workUnits = ['Unit IT', 'Unit Umum', 'Unit Transportasi'];
  final List<String> _locations = ['Gedung A', 'Gedung B', 'Gudang'];
  final List<String> _conditions = ['Baik', 'Rusak Ringan', 'Rusak Berat'];

  @override
  void initState() {
    super.initState();
    _generateAssetCode();
  }

  void _generateAssetCode() {
    final now = DateTime.now();
    final datePart = DateFormat('yyyyMMdd').format(now);
    final randomPart = (1000 + (DateTime.now().millisecond % 9000)).toString();
    setState(() {
      _generatedAssetCode = 'AST-$datePart-$randomPart';
    });
  }

  Future<void> _saveAsset() async {
    // ... (save asset logic is here, no changes needed from last version)
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedReceivedAt ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedReceivedAt) {
      setState(() => _selectedReceivedAt = picked);
    }
  }

  Widget _buildDropdown({required String label, required String? value, required List<String> items, required ValueChanged<String?> onChanged, required FormFieldValidator<String> validator}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Aset Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Kode Aset: $_generatedAssetCode', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ElevatedButton.icon(onPressed: _generateAssetCode, icon: const Icon(Icons.refresh), label: const Text('Generate Ulang Kode')),
              const SizedBox(height: 24),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Aset', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
              const SizedBox(height: 16),
              _buildDropdown(label: 'Kategori', value: _selectedCategory, items: _categories, onChanged: (v) => setState(() => _selectedCategory = v), validator: (v) => v == null ? 'Wajib dipilih' : null),
              const SizedBox(height: 16),
               _buildDropdown(label: 'Tipe', value: _selectedType, items: _types, onChanged: (v) => setState(() => _selectedType = v), validator: (v) => v == null ? 'Wajib dipilih' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _sourceController, decoration: const InputDecoration(labelText: 'Sumber', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
              const SizedBox(height: 16),
              FormField<DateTime>(
                validator: (value) => _selectedReceivedAt == null ? 'Tanggal harus diisi' : null,
                builder: (state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputDecorator(
                        decoration: InputDecoration(labelText: 'Tanggal Diterima', border: const OutlineInputBorder(), errorText: state.errorText),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_selectedReceivedAt == null ? 'Pilih tanggal...' : DateFormat.yMMMMd().format(_selectedReceivedAt!)),
                            IconButton(icon: const Icon(Icons.calendar_today), onPressed: () => _selectDate(context)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
               const SizedBox(height: 16),
              TextFormField(controller: _initialValueController, decoration: const InputDecoration(labelText: 'Nilai Awal', border: OutlineInputBorder(), prefixText: 'Rp '), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
               const SizedBox(height: 16),
              TextFormField(controller: _unitSukController, decoration: const InputDecoration(labelText: 'Unit SUK', border: OutlineInputBorder())),
               const SizedBox(height: 16),
              TextFormField(controller: _lifeYearsController, decoration: const InputDecoration(labelText: 'Masa Pakai (Tahun)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
               const SizedBox(height: 16),
               _buildDropdown(label: 'Unit Kerja', value: _selectedWorkUnit, items: _workUnits, onChanged: (v) => setState(() => _selectedWorkUnit = v), validator: (v) => v == null ? 'Wajib dipilih' : null),
               const SizedBox(height: 16),
               _buildDropdown(label: 'Lokasi', value: _selectedLocation, items: _locations, onChanged: (v) => setState(() => _selectedLocation = v), validator: (v) => v == null ? 'Wajib dipilih' : null),
               const SizedBox(height: 16),
               _buildDropdown(label: 'Kondisi', value: _selectedCondition, items: _conditions, onChanged: (v) => setState(() => _selectedCondition = v), validator: (v) => v == null ? 'Wajib dipilih' : null),
               const SizedBox(height: 16),
              TextFormField(controller: _notesController, decoration: const InputDecoration(labelText: 'Catatan', border: OutlineInputBorder()), maxLines: 3),
               const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _stockSistemController, decoration: const InputDecoration(labelText: 'Stok Sistem', border: OutlineInputBorder()), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null)),
                  const SizedBox(width: 16),
                  Expanded(child: TextFormField(controller: _stockFisikController, decoration: const InputDecoration(labelText: 'Stok Fisik', border: OutlineInputBorder()), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null)),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: _isLoading ? null : _saveAsset,
          icon: _isLoading ? const SizedBox.shrink() : const Icon(Icons.save),
          label: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Simpan Aset'),
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
        ),
      ),
    );
  }
}
