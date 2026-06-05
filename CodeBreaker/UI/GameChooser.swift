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
    @State private var sortOption: GameList.SortOption = .name
    @State private var searchString: String = ""
    
    // MARK: Body -
    var body: some View {
        NavigationSplitView {
            Picker("Sort By", selection: $sortOption.animation(.default)) {
                ForEach(GameList.SortOption.allCases, id: \.self) { option in
                    Text(option.title)
                        .tag(option) // Picker值 改为option
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            GameList(selection: $selection, sortBy: sortOption,searchBy: searchString)
                .searchable(text: $searchString, prompt: "Search Games")
            
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

#Preview(traits: .swiftData) {
    GameChooser()
}


//  14 51:21
