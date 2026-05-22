import SwiftUI // SwiftUI 本身就已经导入 Foundation

struct Code {
    var kind: Kind // 代码种类
    var pegs: [Peg] = Array(repeating: Code.missingPeg, count: 4)// 构成代码的颜色
    
    static let missingPeg = Color.clear
    
    enum Kind : Equatable {
        case master
        case guess
        case attempt([Match])
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    mutating func randomCode(from pegChoices: [Peg]) {
        for index in pegChoices.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
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