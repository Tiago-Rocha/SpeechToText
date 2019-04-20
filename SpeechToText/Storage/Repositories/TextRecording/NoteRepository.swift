import Foundation

protocol NoteRepository {
  
    func insert(note: Note)
    
    func get(id: Int) -> Note?
    
    func delete(id: Int)
    
    func listAll() -> [Note]
}
