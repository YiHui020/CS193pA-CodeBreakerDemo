//
//  gameChooser.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/13.
//

import SwiftUI
import SwiftData

struct GameChooser: View {
    // MARK: Data Owned by Me
    
    
    @State private var selection: CodeBreaker? = nil
    
    // MARK: Body -
    var body: some View {
        NavigationSplitView {
            GameList(selection: $selection)
        } detail: {
            if let selection {
                CodeBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
                    
            }
            else {
                 Text("Choose a Game !")
            }
        }
        .navigationSplitViewStyle(.automatic)
    
        
        
    }
}

#Preview {
    GameChooser()
        .modelContainer(for: CodeBreaker.self)
}
