//
//  CodeBreaker.swift
//  Apptest
//
//  Created by YiHui020 on 2026/4/9.
//


import SwiftUI
import SwiftData


typealias Peg = String

@Model class CodeBreaker {
    var name: String
    var lowercasedName: String
    @Relationship(deleteRule: .cascade) var masterCode: Code = Code(kind: .master(isHidden: true))
    @Relationship(deleteRule: .cascade) var guessCode: Code  = Code(kind: .guess)// 输入的guess // 1
    @Relationship(deleteRule: .cascade) var _attempts: [Code] = [] // 输入后和答案比对的 attempt // 1
    var attempts: [Code] {
        get { _attempts.sorted(by: { $0.timeStamp > $1.timeStamp })}
        set { _attempts = newValue }
    }
    var lastPlayedTime: Date? = Date.now
    var pegChoices: [Peg]// 用户可选的颜色 // 1
    @Transient var startTime: Date? // 游戏开始时间
    var endTime: Date? 
    var elapsedTime: TimeInterval = 0 // 游戏时长
    
    
    var isGameOver: Bool {
        guard let firstAttemptCodePegs =  attempts.first?.pegs else { return false }
        if firstAttemptCodePegs == masterCode.pegs {
            isCompleted = true
            return true
        }
        else {
            return false
        }
    }
    var isCompleted: Bool = false // 标记游戏是否完成
    
    
    
    
    init(name: String = "CodeBreaker", pegChoices: [Peg]) {
        // 先把传入的 pegChoices 保存到实例属性，再用它来生成 masterCode
        self.pegChoices = pegChoices
        self.name = name
        self.lowercasedName = name.lowercased()
        self.lastPlayedTime = nil
        
        masterCode.randomCode(from: self.pegChoices)
        print("Master code: \(masterCode.pegs)")
    }
    
    func restart() {
        guessCode = Code(kind: .guess)
        attempts = []
        masterCode = Code(kind:.master(isHidden: true))
        masterCode.randomCode(from: pegChoices)
//        guessCode.resetPegs()
//        attempts.removeAll()
        startTime = Date.now    // 让 onAppear 的 startTimer() 来负责启动
        endTime = nil
        elapsedTime = 0
        print("Master code: \(masterCode.pegs)")
    }
    
    
    func changeGuessPeg(at index: Int) { // 选择下一个颜色
        if index >= 0 && index < guessCode.pegs.count {
            let existingPeg = guessCode.pegs[index]
            if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
                let nextIndex = (indexOfExistingPegInPegChoices + 1) % pegChoices.count
                guessCode.pegs[index] = pegChoices[nextIndex]
            } else {
                guessCode.pegs[index] = pegChoices.first ?? Code.missingPeg
            }
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guessCode.pegs.indices.contains(index) else { return }
        guessCode.pegs[index] = peg
    }
    
    func commitGuess() {
        guard !attempts.contains(where: { $0.pegs == guessCode.pegs }) else {
            print("You cant commit the same guess twice!")
            return
        }
        // guard <条件> else { <退出代码> }
        print("Committing guess: \(guessCode.pegs)")
        let codeToInsert = Code(
            kind: .attempt(
                guessCode.getMatch(
                    guessCode: guessCode,
                    masterCode: masterCode
                )
            ),
            pegs: guessCode.pegs
        )
        attempts.insert(codeToInsert, at: 0)
        guessCode.resetPegs()
        if isGameOver {
            masterCode.kind = .master(isHidden: false)
            print("GameOver! YouWin!")
            endTime = Date.now
            pauseTimer()
            return
        }
    }
    
    func startTimer() {
        if startTime == nil, !isGameOver {
            startTime = Date.now
            elapsedTime += 0.00001
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    func updateElapsedTime() {
        pauseTimer()
        startTimer()
    }
    
}





// Model 已经包含
//extension CodeBreaker: Hashable, Identifiable, Equatable {
//    static func == (lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
