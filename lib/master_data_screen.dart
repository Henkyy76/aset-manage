import 'package:flutter/material.dart';
import 'generic_master_list_screen.dart'; // Import the generic screen

class MasterDataScreen extends StatelessWidget {
  const MasterDataScreen({super.key});

  void _navigateToMasterList(BuildContext context, {required String title, required MasterDataType type}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GenericMasterListScreen(title: title, type: type)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Data Master'),
      ),
      body: ListView(
        children: <Widget>[
          _buildMasterDataItem(
            context,
            icon: Icons.category,
            title: 'Kategori',
            subtitle: 'Kelola semua kategori aset',
            type: MasterDataType.categories, // Corrected from .category
          ),
          _buildMasterDataItem(
            context,
            icon: Icons.style,
            title: 'Tipe Aset',
            subtitle: 'Kelola semua tipe aset',
            type: MasterDataType.asset_types, // Corrected from .assetType
          ),
          _buildMasterDataItem(
            context,
            icon: Icons.business,
            title: 'Unit Kerja',
            subtitle: 'Kelola semua unit kerja',
            type: MasterDataType.work_units, // Corrected from .workUnit
          ),
          _buildMasterDataItem(
            context,
            icon: Icons.location_on,
            title: 'Lokasi',
            subtitle: 'Kelola semua lokasi penyimpanan aset',
            type: MasterDataType.locations, // Corrected from .location
          ),
        ],
      ),
    );
  }

  Widget _buildMasterDataItem(BuildContext context, {required IconData icon, required String title, required String subtitle, required MasterDataType type}) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(icon),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _navigateToMasterList(context, title: title, type: type),
    );
  }
}
