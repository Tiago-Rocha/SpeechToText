import Foundation

class MemoryNotesRepository: NoteRepository {
    
    private var notes = [Note]()
    
    func insert(note: Note) {
        
        notes.append(note)
    }
    
    func get(id: Int) -> Note? {
        
        return notes.filter { $0.id == id }.first
    }
    
    func delete(id: Int) {
        notes = notes.filter { $0.id != id }
    }
    
    func listAll() -> [Note] {
        return notes
    }
}
