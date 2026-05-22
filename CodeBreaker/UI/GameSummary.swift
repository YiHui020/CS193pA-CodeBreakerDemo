//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/14.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    var body: some View {
        VStack( alignment: .leading){
            Text(game.name)
                .monospaced(true)
                .font(.title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempts](inflect: true)")
            
        }
    }
}

#Preview {
    GameSummary(game: CodeBreaker(pegChoices: [.red, .green, .blue]))
}
