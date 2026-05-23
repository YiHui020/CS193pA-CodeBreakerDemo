//
//  GameList.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/18.
//

import SwiftUI

struct GameList: View {
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    @State var gameToEdit: CodeBreaker?
    
    
    // MARK: Data Shared by Me
    @Binding var selection: CodeBreaker?
    
    
    // MARK: Body -
    var body: some View {
        List (selection: $selection){
            ForEach (games) { game in
                Section {
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    .contextMenu {
                        let tempGame = CodeBreaker(name: game.name, pegChoices: game.pegChoices)
                        // let 只是锁定了引用本身
                        editButton(for: tempGame) // edit game
                        DeleteButton(for: game)
                    }
//                        NavigationLink(value: game.masterCode.pegs) {
//                            Text("Cheat")
//                        }
                }
            }
            
            .onDelete { indexSet in
                games.remove(atOffsets: indexSet)
            }
            .onMove { offsets,destination in
                games.move(fromOffsets: offsets, toOffset: destination)
            }
        }
        .animation(.easeInOut, value: games.count)
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .navigationTitle("CodeBreaker")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: [Peg].self) { masterCode in
            PegChooser(choices: masterCode).padding()
        }
        .listStyle(.sidebar)
        //MARK: Toolbar -
        // toolBar
        .toolbar {
            EditButton() // edit the list
            AddButton()
            
        }
        // MARK: Toolbar End -
        
        .onAppear {
            if games.isEmpty {
                selection = games.first
                games.append(CodeBreaker(
                    name: "EnterGrade",
                    pegChoices: [.red, .green, .blue]))
                games.append(CodeBreaker(
                    name: "NormalGrade",
                    pegChoices: [.indigo, .cyan, .mint, .teal]))
                games.append(CodeBreaker(
                    name: "MasterGrade",
                    pegChoices: [.orange, .yellow, .pink, .brown, .gray]))
            }
        }

    }
    
    func DeleteButton(for game: CodeBreaker) -> some View {
        Button ("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll(where:{ $0 == game})
            }
        }
    }
    
    func AddButton() -> some View {
        Button("",systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [.red, .blue,.purple,.indigo])
        }
        .sheet(item: $gameToEdit) { game in // 这里的 game 是解包的参数 保证item非空才会出现Sheet
            NavigationStack {
                GameEditor(game: game) {
                    submit(game: game)
                } dismiss: {
                    dismiss()
                }
            }
        }
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
                gameToEdit = game
        }
    }
    
    func dismiss() {
        gameToEdit = nil
    }
    
    func submit(game: CodeBreaker) {
        if let index = games.firstIndex(where: { $0.name == game.name }) {
                games[index] = game
        } else {
            games.insert(game, at: 0)
        }
            
    }
    
    
}

#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}

