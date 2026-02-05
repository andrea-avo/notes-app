import 'package:flutter/material.dart';
import '../data/repository/notes_repository.dart';
import '../data/model/notes_model.dart';
import 'edit_notes_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteRepository repository = NoteRepository();

  List<NoteModel> _allNotes = [];
  List<NoteModel> _foundNotes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    setState(() => _isLoading = true);
    try {
      final data = await repository.getNotes();
      setState(() {
        _allNotes = data;
        _foundNotes = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _runFilter(String keyword) {
    List<NoteModel> results = [];
    if (keyword.isEmpty) {
      results = _allNotes;
    } else {
      results = _allNotes
          .where(
            (note) =>
                note.judul.toLowerCase().contains(keyword.toLowerCase()) ||
                note.isi.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    }
    setState(() {
      _foundNotes = results;
    });
  }

  void _deleteData(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Delete note?'),
        content: Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm) {
      await repository.deleteNote(id);
      _refreshData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note deleted'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.black))
                : _foundNotes.isEmpty
                ? Center(
                    child: Text(
                      "No notes",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: _foundNotes.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final note = _foundNotes[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            note.judul,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              note.isi,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              // Ganti EditMenuScreen jadi EditNoteScreen
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditNoteScreen(note: note),
                              ),
                            );
                            if (result == true) _refreshData();
                          },
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.grey[400],
                            ),
                            onPressed: () => _deleteData(note.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add-note');
          if (result == true) _refreshData();
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text("New note"),
        elevation: 2,
      ),
    );
  }
}
