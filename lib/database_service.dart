import 'package:supabase_flutter/supabase_flutter.dart';

import 'main.dart'; // For the global supabase client
import 'asset.dart';

// Service for handling authentication
class AuthService {
  Future<void> signUp({required String email, required String password}) async {
    await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> login({required String email, required String password}) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Session? get currentSession => supabase.auth.currentSession;
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
}

// Service for handling database table operations
class DataService {
  Stream<List<Asset>> getAssetsStream() {
    return supabase
        .from('assets')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false) // Show newest first
        .map((listOfMaps) => listOfMaps.map((map) => Asset.fromJson(map)).toList());
  }

  Future<Asset> getAsset(String assetId) async {
    final response = await supabase
        .from('assets')
        .select()
        .eq('id', assetId)
        .single();
    return Asset.fromJson(response);
  }

  Future<void> addAsset(Asset asset) async {
    await supabase.from('assets').insert(asset.toJson());
  }

  Future<void> updateAsset(Asset asset) async {
    await supabase.from('assets').update(asset.toJson()).eq('id', asset.id);
  }

  Future<void> deleteAsset(String assetId) async {
    await supabase.from('assets').delete().eq('id', assetId);
  }

  /// Corrected method to get the total count of assets.
  Future<int> getAssetsCount() async {
    final response = await supabase.from('assets').count();
    return response;
  }

  // --- Master Data Methods ---
  Stream<List<Map<String, dynamic>>> getMasterDataStream(String tableName) {
    return supabase.from(tableName).stream(primaryKey: ['id']).order('name', ascending: true);
  }

  Future<void> upsertMasterDataItem(String tableName, Map<String, dynamic> data) async {
    await supabase.from(tableName).upsert(data);
  }

  Future<void> deleteMasterDataItem(String tableName, String id) async {
    await supabase.from(tableName).delete().eq('id', id);
  }
}
