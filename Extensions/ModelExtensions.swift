//
//  ModelExtensions.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/22.
//

extension CodeBreaker {
    func isExist() -> Bool {
        if Set(self.pegChoices).count >= 2, !self.name.isEmpty {
            return true
        }
        return false
    }
}
