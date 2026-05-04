import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../services/data_service.dart';
import 'app_session_provider.dart';

class NoteState {
  final List<Note> notes;
  final bool isLoading;
  final String? error;
  final DateTime lastFetched;

  NoteState({
    this.notes = const [],
    this.isLoading = false,
    this.error,
    DateTime? lastFetched,
  }) : lastFetched = lastFetched ?? DateTime.fromMillisecondsSinceEpoch(0);

  NoteState copyWith({
    List<Note>? notes,
    bool? isLoading,
    String? error,
    DateTime? lastFetched,
  }) {
    return NoteState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastFetched: lastFetched ?? this.lastFetched,
    );
  }
}

final noteStateProvider = StateNotifierProvider<NoteStateNotifier, NoteState>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return NoteStateNotifier(ref, userAsync.valueOrNull?.id);
});

class NoteStateNotifier extends StateNotifier<NoteState> {
  final String? userId;

  NoteStateNotifier(Ref ref, this.userId) : super(NoteState()) {
    print('[NoteProvider] Created with userId: $userId');
    if (userId != null) {
      fetchNotes();
    }
  }

  Future<void> fetchNotes({bool force = false}) async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final notes = await DataService.getNotes();
      if (!mounted) return;
      state = state.copyWith(
        notes: notes,
        isLoading: false,
        lastFetched: DateTime.now(),
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addNote(String title, String? content) async {
    print('[NoteProvider] addNote called: title=$title, content=$content');
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempNote = Note(
      id: tempId,
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (!mounted) return;
    state = state.copyWith(notes: [tempNote, ...state.notes]);

    try {
      final result = await DataService.createNote(title, content);
      print('[NoteProvider] createNote result: $result');
      if (!mounted) return;
      if (result != null) {
        state = state.copyWith(
          notes: state.notes.map((n) => n.id == tempId ? result : n).toList(),
        );
      } else {
        print('[NoteProvider] createNote returned null - removing optimistic note');
        state = state.copyWith(
          notes: state.notes.where((n) => n.id != tempId).toList(),
          error: 'Failed to create note',
        );
      }
    } catch (e) {
      print('[NoteProvider] addNote error: $e');
      if (!mounted) return;
      state = state.copyWith(
        notes: state.notes.where((n) => n.id != tempId).toList(),
        error: e.toString(),
      );
    }
  }

  Future<void> updateNote(Note note) async {
    final noteIndex = state.notes.indexWhere((n) => n.id == note.id);
    if (noteIndex == -1) return;

    final oldNote = state.notes[noteIndex];

    if (!mounted) return;
    final updatedNotes = List<Note>.from(state.notes);
    updatedNotes[noteIndex] = note;
    state = state.copyWith(notes: updatedNotes);

    try {
      final success = await DataService.updateNote(note.id, note.title, note.content);
      if (!mounted) return;
      if (!success) throw Exception('Failed to update');
    } catch (e) {
      if (!mounted) return;
      final rollbackNotes = List<Note>.from(state.notes);
      rollbackNotes[noteIndex] = oldNote;
      state = state.copyWith(notes: rollbackNotes, error: 'Failed to update note');
    }
  }

  Future<void> deleteNote(String id) async {
    final noteIndex = state.notes.indexWhere((n) => n.id == id);
    if (noteIndex == -1) return;

    final oldNote = state.notes[noteIndex];

    if (!mounted) return;
    state = state.copyWith(
      notes: state.notes.where((n) => n.id != id).toList()
    );

    try {
      final success = await DataService.deleteNote(id);
      if (!mounted) return;
      if (!success) throw Exception('Failed to delete');
    } catch (e) {
      if (!mounted) return;
      final rollbackNotes = List<Note>.from(state.notes);
      rollbackNotes.insert(noteIndex, oldNote);
      state = state.copyWith(notes: rollbackNotes, error: 'Failed to delete note');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
