import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'database_service.dart'; // Now contains DataService

// Represents a generic master data item for the UI
class MasterItem {
  final String id;
  final String name;

  MasterItem({required this.id, required this.name});

  factory MasterItem.fromJson(Map<String, dynamic> json) {
    return MasterItem(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

// This enum MUST exactly match your Supabase table names
enum MasterDataType { categories, asset_types, work_units, locations }

class GenericMasterListScreen extends StatefulWidget {
  final MasterDataType type;
  final String title;

  const GenericMasterListScreen({super.key, required this.type, required this.title});

  @override
  State<GenericMasterListScreen> createState() => _GenericMasterListScreenState();
}

class _GenericMasterListScreenState extends State<GenericMasterListScreen> {
  final DataService _dataService = DataService(); // Corrected service
  final Uuid _uuid = const Uuid();
  late final Stream<List<MasterItem>> _itemsStream;
  late final String _tableName;

  @override
  void initState() {
    super.initState();
    _tableName = widget.type.name;
    _itemsStream = _dataService.getMasterDataStream(_tableName)
        .map((snapshots) => snapshots.map((json) => MasterItem.fromJson(json)).toList());
  }

  Future<void> _upsertItem({MasterItem? item, required String name}) async {
    if (name.isEmpty) return;

    final data = {
      'id': item?.id ?? _uuid.v4(),
      'name': name,
    };

    try {
      await _dataService.upsertMasterDataItem(_tableName, data);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteItem(MasterItem item) async {
    try {
      await _dataService.deleteMasterDataItem(_tableName, item.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: StreamBuilder<List<MasterItem>>(
        stream: _itemsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada data. Tekan + untuk menambah.'));
          }
          return _buildListView(items);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Tambah ${widget.title}',
      ),
    );
  }

  Widget _buildListView(List<MasterItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: () => _showAddEditDialog(item: item)),
              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmDeleteItem(item)),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteItem(MasterItem item) {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus \"${item.name}\"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              _deleteItem(item);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog({MasterItem? item}) {
    final textController = TextEditingController(text: item?.name);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Tambah ${widget.title}' : 'Edit ${widget.title}'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Nama', border: OutlineInputBorder()),
              autofocus: true,
              validator: (value) => (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null,
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _upsertItem(item: item, name: textController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
