//
//  Kind.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/26.
//


enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])

        // 转成 String 存储
        var rawString: String {
            switch self {
            case .master(let isHidden): return "master:\(isHidden)"
            case .guess:                return "guess"
            case .attempt(let matches):
                let encoded = matches.map { m -> String in
                    switch m {
                    case .noMatch: return "0"
                    case .exact:   return "1"
                    case .inexact: return "2"
                    }
                }.joined(separator: ",")
                return "attempt:\(encoded)"
            }
        }

        // 从 String 还原
        init?(rawString: String) {
            if rawString == "guess" {
                self = .guess
            } else if rawString.hasPrefix("master:") {
                let isHidden = rawString.hasSuffix("true")
                self = .master(isHidden: isHidden)
            } else if rawString.hasPrefix("attempt:") {
                let part = rawString.dropFirst("attempt:".count)
                let matches = part.split(separator: ",").map { c -> Match in
                    switch c {
                    case "1": return .exact
                    case "2": return .inexact
                    default:  return .noMatch
                    }
                }
                self = .attempt(matches)
            } else {
                return nil
            }
        }
    }