import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restapi/data/model/hewan_model.dart';
import 'package:restapi/data/providers/storage_provider.dart';

class HewanRepository {
  final String baseUrl = "https://ternak-be-production.up.railway.app/api/v1";
  final StorageProvider storage = StorageProvider();

  Future<List<HewanModel>> getAllHewan()async{
    final token = await storage.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/hewan"),
      headers: {"Authorization": 'Bearer $token','Accept': 'application/json'},
    );

    if (response.statusCode == 200){
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => HewanModel.fromJson(item)).toList();
    }else {
      throw Exception("Gagal mengambil data Hewan");
    }
  }
  Future<void> createHewan(Map<String, dynamic> hewanData) async

}