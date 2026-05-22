//
//  GameEditer.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/19.
//

import SwiftUI

struct GameEditor: View {
    @Bindable var game: CodeBreaker
    var body: some View {
        VStack{
            Form {
                Section ("Name"){
                    TextField("Name", text: $game.name)
                }
                Section ("Pegs"){
                    PegChoicesPicker(pegChoices: $game.pegChoices)
                }
            }
        }
    }
}

#Preview {
    @Previewable var game = CodeBreaker(name: "Preview", pegChoices: [.red, .blue, .yellow, .purple])
    GameEditor(game: game)
        .onChange(of: game.name) {
            print("Game Name Changed! Currently Name: \(game.name)")
        }
        .onChange(of: game.pegChoices) {
            print("Game PegChoices Changed! Currently Choices: \(game.pegChoices)")
        }
}
