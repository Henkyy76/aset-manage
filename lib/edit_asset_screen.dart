import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'database_service.dart'; // Now contains DataService
import 'asset.dart';

class EditAssetScreen extends StatefulWidget {
  final Asset asset;

  const EditAssetScreen({super.key, required this.asset});

  @override
  State<EditAssetScreen> createState() => _EditAssetScreenState();
}

class _EditAssetScreenState extends State<EditAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dataService = DataService(); // Corrected service name
  bool _isLoading = false;

  // Text Controllers
  late TextEditingController _nameController;
  late TextEditingController _sourceController;
  late TextEditingController _initialValueController;
  late TextEditingController _notesController;

  // Selected values
  String? _selectedCategory;
  String? _selectedLocation;
  String? _selectedCondition;
  // ... other fields

  // TODO: Fetch these from Supabase
  final List<String> _categories = ['Elektronik', 'Mebel', 'Kendaraan'];
  final List<String> _locations = ['Gedung A', 'Gedung B', 'Gudang'];
  final List<String> _conditions = ['Baik', 'Rusak Ringan', 'Rusak Berat'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.asset.name);
    _sourceController = TextEditingController(text: widget.asset.source);
    _initialValueController = TextEditingController(text: widget.asset.initialValue?.toStringAsFixed(0));
    _notesController = TextEditingController(text: widget.asset.notes);

    _selectedCategory = widget.asset.categoryId;
    _selectedLocation = widget.asset.locationId;
    _selectedCondition = widget.asset.condition;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sourceController.dispose();
    _initialValueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateAsset() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final updatedAsset = widget.asset.copyWith(
          name: _nameController.text,
          source: _sourceController.text,
          initialValue: double.tryParse(_initialValueController.text),
          notes: _notesController.text,
          categoryId: _selectedCategory,
          locationId: _selectedLocation,
          condition: _selectedCondition,
          updatedAt: DateTime.now(),
        );

        await _dataService.updateAsset(updatedAsset);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aset berhasil diperbarui!'), backgroundColor: Colors.green),
          );
          Navigator.of(context).pop(); // Go back to detail screen
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.asset.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Aset', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextFormField(controller: _sourceController, decoration: const InputDecoration(labelText: 'Sumber', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextFormField(controller: _initialValueController, decoration: const InputDecoration(labelText: 'Nilai Awal', border: OutlineInputBorder(), prefixText: 'Rp '), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                items: _locations.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: (val) => setState(() => _selectedLocation = val),
                decoration: const InputDecoration(labelText: 'Lokasi', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCondition,
                items: _conditions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _selectedCondition = val),
                decoration: const InputDecoration(labelText: 'Kondisi', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(controller: _notesController, decoration: const InputDecoration(labelText: 'Catatan', border: OutlineInputBorder()), maxLines: 3),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _updateAsset,
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Simpan Perubahan'),
        ),
      ),
    );
  }
}
