//
//  GameList.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/18.
//

import SwiftUI
import SwiftData


struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext // 连接到 SwiftData 的环境变量 让我们可以访问数据模型容器
    
    // MARK: Data Owned by Me
    @State var gameToEdit: CodeBreaker?
    
    
    // MARK: Data Shared by Me
    @Binding var selection: CodeBreaker?
    @Query(sort: \CodeBreaker.name, order: .forward) private var games: [CodeBreaker]
    // @Query(filter: #Predicate { $0.name != nil }) ...
    //@Query 会持续查询
    
    
    // MARK: Body -
    var body: some View {
        List (selection: $selection){
            ForEach (games) { game in
                Section {
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    .contextMenu {
                        editButton(for: game) // edit game
                        DeleteButton(for: game)
                    }
                    .swipeActions(edge: .leading) {
                        editButton(for: game)
                            .tint(.accentColor)
                    }
                }
            }
            
            .onDelete { indexSets in
                for indexSet in indexSets {
                    modelContext.delete(games[indexSet])
                }
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
        .listStyle(.plain)
        
        .sheet(item: $gameToEdit) { game in // 这里的 game 是解包的参数 保证item非空才会出现Sheet
            NavigationStack {
                GameEditor(game: game) {
                    submit(game: game)
                } dismiss: {
                    dismiss()
                }
            }
        }
        
        
        //MARK: Toolbar -
        // toolBar
        .toolbar {
            EditButton() // edit the list
            AddButton()
            
        }
        // MARK: Toolbar End -
        
        .onAppear {
            
            let fetchDescriptor = FetchDescriptor<CodeBreaker>(
                predicate: .true, // 这个谓词表示获取所有对象
//                sortBy: [.init(\.name)] // 返回结果按照 name 排序
            )
            let results = try? modelContext.fetchCount(fetchDescriptor)
            if let results, results == 0  {
                selection = games.first
                modelContext.insert(CodeBreaker(
                    name: "EnterGrade",
                    pegChoices: [.red, .green, .blue]))
                modelContext.insert(CodeBreaker(
                    name: "NormalGrade",
                    pegChoices: [.indigo, .cyan, .mint, .teal]))
                modelContext.insert(CodeBreaker(
                    name: "MasterGrade",
                    pegChoices: [.orange, .yellow, .pink, .brown, .gray]))
            } else {
                print("had Problem fetching CodeBreaker objects")
            }
            
            
        }

    }
    
    func DeleteButton(for game: CodeBreaker) -> some View {
        Button ("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                if let index = games.firstIndex(where:{ $0 == game}) {
                    modelContext.delete(games[index])
                }
            }
        }
    }
    
    func AddButton() -> some View {
        Button("",systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [.red, .blue,.purple,.indigo])
        }
        
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        let copyOfGame = CodeBreaker(name: game.name, pegChoices: game.pegChoices)
        // 我们用 init 进行值传递
        // let 只是锁定了引用本身

        return Button("Edit", systemImage: "pencil") {
                gameToEdit = copyOfGame
        }
    }
    
    func dismiss() {
        gameToEdit = nil
    }
    
    func submit(game: CodeBreaker) {
        if let index = games.firstIndex(where: { $0.name == game.name }) {
            modelContext.delete(games[index]) // 先删除原来的对象
        }
        modelContext.insert(game) // 直接插入新的
    }
    
    
}

#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}

