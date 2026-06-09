//
//  Code.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/4/22.
//


import SwiftUI // SwiftUI 本身就已经导入 Foundation
import SwiftData


enum Match : String, Codable, Sendable, Equatable {
    case noMatch // 透明/不显示：代表没对上
    case exact // 实心圆：代表位置和颜色都对
    case inexact // 空心圆：代表颜色对但位置不对
}

@Model
class Code {
    var _kind: String// 代码种类
    var pegs: [Peg] // 构成代码的颜色
    var kind: Kind {
        get { Kind(rawString: _kind) ?? .guess }
        set { _kind = newValue.rawString }
    }
    var timeStamp = Date.now // 记录生成时间，方便排序
    
    static let missingPeg: String = "clear"
    
    init(kind: Kind, pegs: [Peg] = Array(repeating: missingPeg, count: 4)) {
        self.pegs = pegs
        self._kind = kind.rawString
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
    
    func randomCode(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
    }
    
    func resetPegs() {
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




