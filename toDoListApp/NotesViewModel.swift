//
//  NotesViewModel.swift
//  toDoListApp
//
//  Created by Daniel Barretta on 17/03/2022.
//

import Foundation
import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [NoteModel] = []
    
    init() {
        notes = getAllNotes()
    }
    
    func saveNote(description: String) {
        let newNote = NoteModel(description: description)
        notes.insert(newNote, at: 0)
        encodeAndSaveAllNotes()
    }
    
    private func encodeAndSaveAllNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
    func getAllNotes() -> [NoteModel] {
        if let notesData = UserDefaults.standard.object(forKey: "notes") as? Data {
            if let notes = try? JSONDecoder().decode([NoteModel].self, from: notesData) {
                return notes
            }
        }
        return []
    }
    
    func removeNote(withId id:String) {
        notes.removeAll(where: { $0.id == id })
        encodeAndSaveAllNotes()
    }
    
    func updateFavoriteNote(note: Binding<NoteModel>) {
        note.wrappedValue.isFavorited = !note.wrappedValue.isFavorited
        encodeAndSaveAllNotes()
    }
    
    func getNumberOfNotes() -> String {
        "\(notes.count)"
    }
}
