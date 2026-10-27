import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'database_service.dart'; // Now contains DataService
import 'asset.dart';
import 'edit_asset_screen.dart';

class AssetDetailScreen extends StatefulWidget {
  final String assetId;

  const AssetDetailScreen({super.key, required this.assetId});

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  final DataService _dataService = DataService(); // Corrected service name

  void _deleteAsset() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus aset ini dari database?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await _dataService.deleteAsset(widget.assetId);
        Navigator.of(context).pop(); // Go back to the list screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aset berhasil dihapus.'), backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _navigateToEdit(Asset asset) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditAssetScreen(asset: asset), // Pass the whole asset object
      ),
    ).then((_) => setState(() {})); // Refresh details after editing
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Asset?>(
      future: _dataService.getAsset(widget.assetId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Aset tidak ditemukan. Error: ${snapshot.error}')),
          );
        }

        final asset = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(asset.name),
            actions: [
              IconButton(icon: const Icon(Icons.edit), tooltip: 'Edit', onPressed: () => _navigateToEdit(asset)),
              IconButton(icon: const Icon(Icons.delete), tooltip: 'Hapus', onPressed: _deleteAsset),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Kode Aset', asset.code),
                _buildDetailRow('Nama Aset', asset.name),
                // TODO: In the future, we will fetch the actual names from these IDs
                _buildDetailRow('Kategori', asset.categoryId ?? '-'),
                _buildDetailRow('Unit Kerja', asset.workUnitId ?? '-'),
                _buildDetailRow('Lokasi', asset.locationId ?? '-'),
                _buildDetailRow('Tanggal Diterima', asset.receivedAt != null ? DateFormat.yMMMMd().format(asset.receivedAt!) : '-'),
                _buildDetailRow('Nilai Awal', 'Rp ${asset.initialValue?.toStringAsFixed(0) ?? '0'}'),
                _buildDetailRow('Kondisi', asset.condition ?? '-'),
                if (asset.notes != null && asset.notes!.isNotEmpty) _buildDetailRow('Catatan', asset.notes!),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Divider(),
        ],
      ),
    );
  }
}
