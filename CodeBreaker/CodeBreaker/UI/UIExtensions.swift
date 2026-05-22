//
//  UIExtensions.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/2.
//

import SwiftUI

extension Animation {
    static let codeBreaker = Animation.bouncy
    static let guess = Animation.codeBreaker
    static let reStart = Animation.codeBreaker
    static let selectionAnimation = Animation.codeBreaker
}

extension AnyTransition {
    static let pegChooser = AnyTransition.offset(x: 0, y: 200)
    static func getAttemptsTransition(_ isGameOver: Bool) -> AnyTransition {
        AnyTransition.asymmetric (
            insertion: isGameOver ? .opacity : .move(edge: .top), // 插入动画
            removal: .move(edge: .trailing) // 删除动画)
        )
    }   
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

extension View {
    func flexibleSystemFont(minimumSize: CGFloat = 8, maximumSize: CGFloat = 80) -> some View {
        self
            .font(.system(size: maximumSize))
            .minimumScaleFactor(minimumSize / maximumSize)
    }
}
