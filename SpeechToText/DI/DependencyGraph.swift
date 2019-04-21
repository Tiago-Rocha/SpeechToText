import Foundation
import Speech

class DependencyGraph {
    
    private var noteRepository: NoteRepository?
    
    func getRecorderViewModel() -> RecorderViewModel {
    
        return RecorderViewModel(noteRepository: getMemoryNoteRepository(), recognizer: getiOSSpeechRecognizer())
    }
    
    func getMemoryNoteRepository() -> NoteRepository {
        
        guard let _noteRepository = noteRepository else {
            return MemoryNotesRepository()
        }
        return _noteRepository
    }
    
    func getiOSSpeechRecognizer() -> SpeechRecognizer {
        
        return SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    }
}
