//
//  ContentView.swift
//  Apptest
//
//  Created by YiHui020 on 2026/4/6.
//




import SwiftUI

struct CodeBreakerView: View {
    //MARK: Data In
    @Environment(\.scenePhase) var scenePhase
    
    
    // MARK:  Data Owned by Me
    @State private var selection : Int = 0
    @State private var restarting: Bool = false
    @State private var showMatchMakers: Bool = false
    
    // MARK: Data Shared with Me
    let game: CodeBreaker // 列表更新数据要用到

    
    // MARK: - Body
    var body: some View {
        VStack {
//            Button ("RESTART",systemImage: "arrow.trianglehead.counterclockwise.rotate.90",action: reStartAnimation)
            PegCodeView(code: game.masterCode)
            ScrollView {
                // Guess Code Area
                if !game.isGameOver {
                    PegCodeView(code: game.guessCode,
                                selection: $selection
                    )
                        .animation(nil, value: game.attempts.count) // 取消guessCode的动画淡出
                        .opacity(restarting ? 0 : 1) // 重置时不显示guessCode
                }
                ForEach(game.attempts, id: \.pegs) { attempt in
                    // 这里我们可以在Code实现 Identiable 协议，直接用Peg作为id，但是为了以后区分其他属性，我们在ForEach局部使用pegs作为id
                    PegCodeView(code: attempt) {
                        let showMMakers = showMatchMakers || attempt.pegs != game.attempts.first?.pegs
                        //如果当前attempt不是第一个attempt，那么就一直显示它的Match情况，即index条件为false
                        // showMatchMakers 判断是否显示刚刚的guess的Match情况，即attempt条件为false，show条件为true                                                      而attempt判断则关联以往的Match情况，保证了在以后修改showMatchMakers的值时，之前的Match不会消失
                        if let matches = attempt.matches , showMMakers {
                            MatchMakers(matches: matches)
                        }
                    }
                    .transition (AnyTransition.getAttemptsTransition(game.isGameOver))
                    // 拿到Attempts的动画
                }
            }
            
            if !game.isGameOver {
                guessButton
                    .transition(.offset(x: 0, y: 200))
                PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                    .transition(.pegChooser)
                    .frame(maxHeight: 80)
                    
            }
                
        }
        .padding(10)
        
        
        .trackElapsedTime(in: game)
        // Time Compute
        
        .toolbar { // all ToolbarItem or all not
            ToolbarItem (placement: .primaryAction) {
                Button ("RESTART",systemImage: "arrow.trianglehead.counterclockwise.rotate.90",action: reStartAnimation)
            }
            ToolbarItem (placement: .automatic) {
                ElapsedTimeView(
                    startTime: game.startTime,
                    endTime: game.endTime,
                    elapsedTime: game.elapsedTime
                )
//                .flexibleSystemFont()
                .monospaced(true)
                .lineLimit(1)
            }
        }
        
    }

    
    
    
    
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.guessCode.pegs.count
    }
    
    var guessButton: some View {
        Button("Guess", action: guessAnimation)
        .flexibleSystemFont(minimumSize: GuessButton.minimumFontSize, maximumSize: GuessButton.maximumFontSize)
        .padding()
        .foregroundStyle(GuessButton.foregroundColor)
        .background(GuessButton.backgroundColor)
        .cornerRadius(GuessButton.cornerRadius)
    }
    
    func reStartAnimation() {
        withAnimation (.reStart) {
            restarting = game.isGameOver // 重置  插入guess Area
            game.restart()
            selection = 0

        } completion: { // 在动画完成后执行重置游戏的逻辑
            withAnimation(.reStart) { // 重置游戏的动画
                restarting = false
            }
        }
    }
    
    
    
    func guessAnimation() {
        withAnimation(Animation.guess) { // 提交guess的动画
            game.commitGuess()
            selection = 0
            showMatchMakers = false //先不显示刚提交的guess的Match情况
        } completion: {
            withAnimation(.guess){ // 显示刚提交的guess的Match情况的动画
                showMatchMakers = true // 完成后正常显示Match情况
            }
        }
    }
    
    
    struct GuessButton {
        static let maximumFontSize: CGFloat = 20
        static let minimumFontSize: CGFloat = 8
        static let scaleFactor: CGFloat = minimumFontSize / maximumFontSize
        static let backgroundColor: Color = .yellow
        static let cornerRadius: CGFloat = 10
        static let foregroundColor: Color = .primary
        struct font {
            static let size: CGFloat = 20
            static let weight: Font.Weight = .bold
        }
        
    }

    struct Selection {
        static let border : CGFloat = 5
        static let color: Color = .gray(0.9)
    }
    
}

extension View {
    func trackElapsedTime(in game: CodeBreaker) -> some View {
        self.modifier(ElapsedTimeTracker(game: game))
    }
}



struct ElapsedTimeTracker: ViewModifier {
    @Environment(\.scenePhase) var scenePhase
    let game: CodeBreaker
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                game.startTimer()
            }
            .onChange (of: game){ oldGame, newGame in
                oldGame.pauseTimer()
                newGame.startTimer()

            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active: game.startTimer()
                case .background: game.pauseTimer()
                default: break
                }
            }
            .onDisappear {
                game.pauseTimer()
            }
    }
}


extension CodeBreaker {
    convenience init(name: String = "CodeBreaker", pegChoices: [Color]) {
        self.init(name: name, pegChoices: pegChoices.map(\.gameString))
    }
    
    
    var pegColorChoices: [Color] {
        get {
            pegChoices.map { Color.fromGameString($0)  ?? .clear } // 翻译为 Color 数组供 UI 使用，如果转换失败则用 .clear 占位
        }
        set {
            pegChoices = newValue.map { $0.gameString } // 转换为 String 覆盖 CodeBreaker 的 pegChoices 数组
        }
    }
    
}


#Preview {
    @Previewable @State var game: CodeBreaker = CodeBreaker(name: "Test", pegChoices: [Color.brown, .gray, .pink, .cyan, .blue])
    
    NavigationStack {
        CodeBreakerView(game: game)
    }
}
