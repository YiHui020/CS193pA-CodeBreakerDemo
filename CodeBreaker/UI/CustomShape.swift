//
//  CustomShape.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/6/8.
//

import SwiftUI
 
struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path { // 底层是 rect 矩形
        return Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
//            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
//            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.width / 2,
                startAngle: .degrees(180),
                endAngle: .degrees(90),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.width / 2,
                startAngle: .degrees(180),
                endAngle: .degrees(90),
                clockwise: false
            )
            
            
        }
    }
    
    
}

#Preview {
    CustomShape()
        .stroke()
        .aspectRatio(1, contentMode: .fit)
}
