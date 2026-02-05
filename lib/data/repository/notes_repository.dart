import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/notes_model.dart';

class NoteRepository {
  final String _baseUrl = 'https://6982efb49c3efeb892a3be86.mockapi.io/notes';

  Future<List<NoteModel>> getNotes() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => NoteModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal ambil data');
    }
  }

  Future<bool> tambahNote(String judul, String isi) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': judul, 'content': isi}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> updateNote(String id, String judul, String isi) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': judul, 'content': isi}),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteNote(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    return response.statusCode == 200;
  }
}
