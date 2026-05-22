//
//  CodeBreaker.swift
//  Apptest
//
//  Created by YiHui020 on 2026/4/9.
//


import SwiftUI // SwiftUI 本身就已经导入 Foundation


struct CodeBreaker {
    var masterCode: Code = Code(kind: .master(isHidden: true)) // 答案
    var guess: Code  = Code(kind: .guess)// 输入的guess
    var attempts: [Code] = [] // 输入后和答案比对的 attempt
    var pegChoices: [Peg]  = [.green, .red, .blue, .yellow]// 用户可选的颜色
    var isGameOver: Bool {
        guard let lastAttemptCodePegs = attempts.last?.pegs else { return false }
        return lastAttemptCodePegs == masterCode.pegs
    }
    
    init(pegChoices: [Peg]) {
        // 先把传入的 pegChoices 保存到实例属性，再用它来生成 masterCode
        self.pegChoices = pegChoices
        masterCode.randomCode(from: self.pegChoices)
        print("Master code: \(masterCode.pegs)")
    }
    
    
    mutating func changeGuessPeg(at index: Int) { // 选择下一个颜色
        if index >= 0 && index < guess.pegs.count {
            let existingPeg = guess.pegs[index]
            if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
                let nextIndex = (indexOfExistingPegInPegChoices + 1) % pegChoices.count
                guess.pegs[index] = pegChoices[nextIndex]
            } else {
                guess.pegs[index] = pegChoices.first ?? Code.missingPeg
            }
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func commitGuess() {
        print("Committing guess: \(guess.pegs)")
        attempts.append(guess)
        attempts[attempts.count - 1].kind = .attempt(guess.getMatch(guessCode: guess, masterCode: masterCode))
        guess.resetPegs()
        if isGameOver {
            masterCode.kind = .master(isHidden: false)
            print("GameOver! YouWin!")
            return
        }
    }
}

typealias Peg = Color
