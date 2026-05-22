//
//  Code.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/4/22.
//


import SwiftUI // SwiftUI 本身就已经导入 Foundation



// 简单来说就是给attempt类型加上了一个[Match]的属性，这样我们就可以在ContentView里直接访问code.matches来展示每一个attempt的匹配情况了。
// 然后在提交Guess的时候直接调用getMatch来计算每一个attempt的匹配情况，并把结果保存在attempt的kind属性里，这样我们就不需要在ContentView里每次都计算一次匹配情况。


struct Code : Equatable{
    var kind: Kind // 代码种类
    var pegs: [Peg] = Array(repeating: Code.missingPeg, count: 4)// 构成代码的颜色
    
    static let missingPeg = Color.clear
    
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let hidden): return hidden
        default: return false
        }
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    mutating func randomCode(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
    }
    
    mutating func resetPegs() {
        pegs = Array(repeating: Code.missingPeg,count: pegs.count)
    }

    // 现在我们要返回当前 Code 的匹配情况。
    // 比较 masterCode 和 guees, 返回一个 Match 数组，表示每一个位置的匹配情况
    func getMatch(guessCode: Code, masterCode: Code) -> [Match] {
        var result : [Match] = Array(repeating: .noMatch, count: pegs.count)
        let guessPegs = guessCode.pegs
        var ansPegs = masterCode.pegs
        // 第一次找 exact
        for index in guessPegs.indices.reversed() {
            if guessCode.pegs[index] == ansPegs[index] {
                result[index] = .exact
                ansPegs.remove(at: index)
            }
        }
        // 2次找 inexact
        for index in guessPegs.indices {
            if result[index] == .noMatch {
                if let foundIndex = ansPegs.firstIndex(of: guessPegs[index]) {
                    result[index] = .inexact
                    ansPegs.remove(at: foundIndex)
                }
            }
        }
        return result
    }
}
