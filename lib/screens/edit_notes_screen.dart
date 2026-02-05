import 'dart:async';
import 'package:flutter/material.dart';
import '../data/model/notes_model.dart';
import '../data/repository/notes_repository.dart';

class EditNoteScreen extends StatefulWidget {
  // Ganti EditMenuScreen jadi EditNoteScreen
  final NoteModel note;
  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final NoteRepository repository = NoteRepository();
  late TextEditingController _judulController;
  late TextEditingController _isiController;

  Timer? _debounce;
  String _saveStatus = "Saved";

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.note.judul);
    _isiController = TextEditingController(text: widget.note.isi);

    _judulController.addListener(_onUserTyping);
    _isiController.addListener(_onUserTyping);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _judulController.removeListener(_onUserTyping);
    _isiController.removeListener(_onUserTyping);
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  void _onUserTyping() {
    if (_saveStatus != "Typing...") {
      setState(() => _saveStatus = "Typing...");
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () {
      _autoSave();
    });
  }

  void _autoSave() async {
    if (!mounted) return;
    setState(() => _saveStatus = "Saving...");

    try {
      bool success = await repository.updateNote(
        widget.note.id,
        _judulController.text,
        _isiController.text,
      );

      if (mounted) {
        setState(
          () =>
              _saveStatus = success ? "Auto Save" : "Failed to save",
        );
      }
    } catch (e) {
      if (mounted) setState(() => _saveStatus = "Failed to save");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: TextField(
          controller: _judulController,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'Note title',
            border: InputBorder.none,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                _saveStatus,
                style: TextStyle(
                  color: _saveStatus.contains("Failed")
                      ? Colors.red
                      : Colors.black,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(height: 1, color: Colors.grey[200]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10,
              ),
              child: TextField(
                controller: _isiController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(fontSize: 16, height: 1.6),
                decoration: InputDecoration(
                  hintText: 'Write something...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
