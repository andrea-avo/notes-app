class NoteModel {
  final String id;
  final String judul;
  final String isi;

  NoteModel({required this.id, required this.judul, required this.isi});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'].toString(),
      // Mapping: 'title' dari MockAPI --> 'judul' di aplikasi
      judul: json['title'] ?? 'Tanpa Judul',
      // Mapping: 'content' dari MockAPI --> 'isi' di aplikasi
      isi: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': judul, 'content': isi};
  }
}
