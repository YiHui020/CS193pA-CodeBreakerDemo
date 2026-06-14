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
    var gameSummarySize: GameSummary.Size {
        staticSummarySize * dynamicSummarySizeMagnification
    }
    @State private var staticSummarySize: GameSummary.Size = .large
    @State private var dynamicSummarySizeMagnification: CGFloat = 1.0
    
    // MARK: Data Shared by Me
    @Binding var selection: CodeBreaker?
    @State var sortBy: GameList.SortOption = .name
    @Query private var games: [CodeBreaker]
    // @Query(filter: #Predicate { $0.name != nil }) ...
    //@Query 会持续查询
    
    
    init (selection: Binding<CodeBreaker?>,
          sortBy: GameList.SortOption = .name,
          searchBy: String = ""
    ) {
        let lowercaseSearchString = searchBy.lowercased()
        let predicate = #Predicate<CodeBreaker> { game in
            searchBy.isEmpty || game.lowercasedName.contains(lowercaseSearchString)
        }
        
        
        let completedPredicate = #Predicate<CodeBreaker> { game in
            (searchBy.isEmpty || game.lowercasedName.contains(lowercaseSearchString))
            && game.isCompleted
        }
        _selection = selection // _selction 是 selection 的 getter 和 setter 即包装器
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \.name) // 按名字升序排序
        case .recent: _games = Query(filter: predicate, sort: \.lastPlayedTime, order: .reverse) // 按最后一次玩的时间降序排序
        case .completed: _games = Query(filter: completedPredicate, sort: \.name) // 按完成状态降序排序
        }
    }
    
    
    // MARK: Body -
    var body: some View {
        let _ = print("games array: \(games.count)")
        List (selection: $selection){
            ForEach (games) { game in
                Section {
                    NavigationLink(value: game) {
                        GameSummary(game: game, size: gameSummarySize)
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
        .highPriorityGesture(summarySizeMagnifier())
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
                print("onAppear called")
                do {
                    let fetchDescriptor = FetchDescriptor<CodeBreaker>(predicate: .true)
                    let results = try modelContext.fetchCount(fetchDescriptor)
                    print("fetch count: \(results)")
                    if results == 0 {
                        modelContext.insert(CodeBreaker(name: "EnterGrade", pegChoices: [.red, .green, .blue]))
                        modelContext.insert(CodeBreaker(name: "NormalGrade", pegChoices: [.indigo, .cyan, .mint, .teal]))
                        modelContext.insert(CodeBreaker(name: "MasterGrade", pegChoices: [.orange, .yellow, .pink, .brown, .gray]))
                        print("inserted 3 games")
                        print("games count after insert: \(games.count)")
                    } else {
                        print("already has \(results) games")
                    }
                } catch {
                    print("error: \(error)")
                }
            }

    }
    
    enum SortOption :CaseIterable {
        case name
        case recent
        case completed
        var title: String {
            switch self {
            case .name:  return "Name"
            case .recent:  return "Recent"
            case .completed: return "Completed"
            }
        }
    }
    
    func summarySizeMagnifier() -> some Gesture {
        MagnifyGesture()
            .onChanged {value in
                dynamicSummarySizeMagnification = value.magnification
            }
            .onEnded { value in
                staticSummarySize = staticSummarySize * value.magnification
                
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

#Preview(traits: .swiftData) {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}

extension GameSummary.Size {
    static func *(lhs: Self, rhs: CGFloat) -> Self{
        switch rhs {
        case 2.0...: lhs.larger.larger
        case 1.5...: lhs.larger
        case ...0.6: lhs.smaller
        case ...0.35: lhs.smaller.smaller
        default: lhs
        }
    }
}

