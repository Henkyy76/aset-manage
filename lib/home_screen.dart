import 'package:flutter/material.dart';

import 'database_service.dart'; // Now contains AuthService and DataService
import 'asset.dart';
import 'master_data_screen.dart';
import 'add_asset_screen.dart';
import 'asset_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataService _dataService = DataService();
  final AuthService _authService = AuthService();
  late final Stream<List<Asset>> _assetsStream;

  @override
  void initState() {
    super.initState();
    _assetsStream = _dataService.getAssetsStream();
  }

  void _navigateToMasterData(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const MasterDataScreen()),
    );
  }

  void _navigateToAddAsset(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddAssetScreen()),
    );
  }

  void _navigateToDetail(BuildContext context, Asset asset) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AssetDetailScreen(assetId: asset.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_copy), // Corrected Icon
            tooltip: 'Data Master',
            onPressed: () => _navigateToMasterData(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async => await _authService.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDashboardSummary(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Aset Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Asset>>(
              stream: _assetsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                }
                final assets = snapshot.data;
                if (assets == null || assets.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada aset.\nTekan tombol + untuk memulai.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return _buildAssetListView(assets);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddAsset(context),
        label: const Text('Tambah Aset'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDashboardSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FutureBuilder<int>(
        future: _dataService.getAssetsCount(),
        builder: (context, snapshot) {
          final count = snapshot.data ?? 0;
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildSummaryCard('Total Aset', count.toString(), Icons.inventory_2, Colors.blue),
              _buildSummaryCard('Kategori', '--', Icons.category, Colors.orange), // Placeholder
              _buildSummaryCard('Kondisi Baik', '--', Icons.check_circle, Colors.green), // Placeholder
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetListView(List<Asset> assets) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 90), // Space for FAB
      itemCount: assets.length > 5 ? 5 : assets.length, // Show max 5 recent
      itemBuilder: (context, index) {
        final asset = assets[index];
        return ListTile(
          leading: const Icon(Icons.computer_outlined, color: Colors.grey),
          title: Text(asset.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(asset.code),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _navigateToDetail(context, asset),
        );
      },
    );
  }
}
