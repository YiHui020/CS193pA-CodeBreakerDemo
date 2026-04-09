//
//  CodeBreaker.swift
//  Apptest
//
//  Created by YiHui020 on 2026/4/9.
//


import SwiftUI // SwiftUI 本身就已经导入 Foundation


// Storage for CodeBreaker

struct CodeBreaker {
    var masterCode: Code // 答案  
    var guess: Code // 输入的guess
    var attempts: Code // 输入后和答案比对的 attempt
    var pegChoices: [Peg] // 用户可选的颜色
    
}

struct Code {
    var pegs: [Peg] // 构成代码的颜色
    var kind: Kind // 代码种类 
    
    enum Kind {
        case master
        case guess
        case attempt
    }
}

typealias Peg = Color
