import Foundation

class RecorderViewModel {
    
    private let repository: NoteRepository
    
    private let currentRecordingName = "current.m4a"
    
    private let recognizer: SpeechRecognizer
    
    init(noteRepository: NoteRepository, recognizer: SpeechRecognizer) {
        self.repository = noteRepository
        self.recognizer = recognizer
    }
    
    func save(recordingText: String) {
        
        let noteID = repository.listAll().count + 1
        
        let note = Note(id: noteID, text: recordingText)
        
        repository.insert(note: note)
    }
    
    var temporaryFileURL: URL {
        
        return getDocumentsDirectory().appendingPathComponent(currentRecordingName)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func recognizeAudioFrom(url: URL, completion: @escaping (String, Error?) -> ()) {
        
        recognizer.audioToText(url: url) { text, error in
            completion(text, error)
        }
    }
}
