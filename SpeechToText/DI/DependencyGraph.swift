import Foundation
import Speech

class DependencyGraph {
    
    private var noteRepository: NoteRepository?
    
    static let shared = DependencyGraph()
    
    func getRecorderViewModel() -> RecorderViewModel {
    
        return RecorderViewModel(noteRepository: getMemoryNoteRepository(), recognizer: getiOSSpeechRecognizer())
    }
    
    func getMemoryNoteRepository() -> NoteRepository {
        
        guard let _noteRepository = noteRepository else {
            noteRepository = MemoryNotesRepository()
            return noteRepository!
        }
        return _noteRepository
    }
    
    func getiOSSpeechRecognizer() -> SpeechRecognizer {
        
        return SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    }
}
