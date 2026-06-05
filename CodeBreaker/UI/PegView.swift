//
//  PegView.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/4/22.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg

    // MARK: - Body
    let pegShape = CustomShape()
    var body: some View {
        pegShape
            .contentShape(pegShape)
            .aspectRatio(1,contentMode: .fit)
            .foregroundStyle(Color(from: peg) ?? .clear)
            .overlay {
                if peg == Code.missingPeg {
                    pegShape
//                        .strokeBorder(.primary, lineWidth: 0.3)
                }
            }
    }
}

#Preview {
    PegView(peg: Color.blue.toHexString())
    
}
