//
//  ContentView.swift
//  toDoListApp
//
//  Created by Daniel Barretta on 17/03/2022.
//

import SwiftUI

struct ContentView: View {
    @State var descriptionNote: String = ""
    @StateObject var notesViewModel = NotesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Añade una tarea")
                    .underline()
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                TextEditor(text: $descriptionNote)
                    .foregroundColor(.gray)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(.green, lineWidth: 2)
                    )
                    .padding(.horizontal, 12)
                    .cornerRadius(3.0)
                Button("Crear") {
                    notesViewModel.saveNote(description: descriptionNote)
                    descriptionNote = ""
                }
                .buttonStyle(.bordered)
                .tint(.green)
                Spacer()
                List {
                    ForEach($notesViewModel.notes, id: \.id) { $note in
                        HStack {
                            if note.isFavorited {
                                Text("⭐️")
                            }
                            Text(note.description)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                notesViewModel.updateFavoriteNote(note: $note)
                            } label : {
                                Label("Favorito", systemImage: "star.fill")
                            }
                            .tint(.yellow)
                        }
                        .swipeActions(edge: .leading) {
                        Button {
                            notesViewModel.removeNote(withId: note.id)
                        } label : {
                            Label("borrar", systemImage: "trash.fill")
                        }
                        .tint(.red)
                    }
                    }
                }
            }
            .navigationTitle("TODO")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Text(notesViewModel.getNumberOfNotes())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
