import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restapi/data/model/hewan_model.dart';
import 'package:restapi/data/providers/storage_provider.dart';

class HewanRepository {
  final String baseUrl = "https://ternak-be-production.up.railway.app/api/v1";
  final StorageProvider storage = StorageProvider();

  Future<List<HewanModel>> getAllHewan() async {
    final token = await storage.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/hewan"),
      headers: {"Authorization": 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => HewanModel.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil data Hewan");
    }
  }

  Future<void> createHewan(Map<String, dynamic> hewanData) async {
    final token = await storage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/hewan'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(hewanData),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception('Gagal menambahkan Hewan');
    }
  }

  Future<void> updateHewan(int id, Map<String, dynamic> hewanData) async {
    final token = await storage.getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/hewan/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(hewanData),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui Hewan');
    }
  }
  
}
