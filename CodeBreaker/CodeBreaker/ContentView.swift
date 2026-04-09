//
//  ContentView.swift
//  Apptest
//
//  Created by YiHui020 on 2026/4/6.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
            VStack {
                pegs(colors: [.blue, .green, .purple, .pink])
                pegs(colors: [.yellow, .gray, .green, .primary])
                pegs(colors: [.yellow, .green, .purple, .red])
            }.padding(10)
    }
    
    func pegs(colors: [Color]) -> some View {
        return HStack {
            MatchMakers(matches: [.exact, .exact, .inexact, .noMatch])
            ForEach(colors.indices, id: \.self , /*后面是content的闭包*/) { index in
                Circle()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(colors[index])}
        }
    }
    
    
}


#Preview {
    ContentView()
}
