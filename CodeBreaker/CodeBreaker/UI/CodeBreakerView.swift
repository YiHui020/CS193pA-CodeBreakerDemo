//
//  ContentView.swift
//  Apptest
//
//  Created by YiHui020 on 2026/4/6.
//






import SwiftUI

struct CodeBreakerView: View {
    // MARK: Initialize By Me
    @State private var game = CodeBreaker(pegChoices: [.brown, .gray, .pink, .cyan, .blue])
    @State private var selection : Int = 0
    @State private var restarting: Bool = false
    @State private var showMatchMakers: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            Button ("RESTART",systemImage: "arrow.trianglehead.counterclockwise.rotate.90",action: reStartAnimation)
            PegCodeView(code: game.masterCode)
            ScrollView {
                
                // Guess Code Area
                if !game.isGameOver || restarting{
                    PegCodeView(code: game.guessCode,
                                selection: $selection
                    )
                        .animation(nil, value: game.attempts.count) // 取消guessCode的动画淡出
                        .opacity(restarting ? 0 : 1) // 重置时不显示guessCode
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    PegCodeView(code: game.attempts[index]) {
                        let showMMakers = showMatchMakers || index != game.attempts.count - 1
                        // showMatchMakers 判断是否显示刚刚的guess的Match情况，即index条件为false，show条件为true 而index判断则关联以往的Match情况，保证了在以后修改showMatchMakers的值时，之前的Match不会消失，即 index条件为true
                        if let matches = game.attempts[index].matches , showMMakers {
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
                    
            }
                
            
             
            
        }.padding(10)
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
            restarting = true // 重置  插入guess Area
        } completion: { // 在动画完成后执行重置游戏的逻辑
            withAnimation(.reStart) { // 重置游戏的动画
                game.restart() // 系统重置
                selection = 0
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





#Preview {
    CodeBreakerView()
}
