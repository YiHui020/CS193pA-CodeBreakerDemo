//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/14.
//

import SwiftUI

struct GameSummary: View {
    enum Size {
        case compact
        case regular
        case large
        
        var larger:Size {
            switch self {
            case .compact: .regular
            default: .large
            }
        }
        
        var smaller:Size {
            switch self {
            case .large: .regular
            default: .compact
            }
        }
    }
    
    let game: CodeBreaker
    var size: Size = .regular
    var fontSize: Font{
        switch (size) {
        case .compact: return .title3
        case .regular: return .title
        case .large: return .title
        }
    }
    var pegSize: CGFloat {
        switch (size) {
        case .compact: return 30
        case .regular: return 50
        case .large: return 50
        }
    }
    
    var body: some View {
        let layout = (size == .compact ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(alignment: .leading))) // 类型擦除
        layout{
            Text(game.name)
                .monospaced(true)
                .font(fontSize)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: pegSize)
            if size == .large {
                Text("^[\(game.attempts.count) attempts](inflect: true)")
            }
        }
        .animation(.easeInOut, value: size)
    }
}

#Preview(traits: .swiftData){
    GameSummary(game: CodeBreaker(pegChoices: [Color.red, .green, .blue].map { $0.gameString }))
}
