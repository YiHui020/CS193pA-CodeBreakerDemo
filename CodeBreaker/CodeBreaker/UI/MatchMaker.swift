//
//  MatchMaker.swift
//  Apptest
//
//  Created by YiHui020 on 2026/4/8.
//

import SwiftUI

enum Match {
    case noMatch // 透明/不显示：代表没对上
    case exact // 实心圆：代表位置和颜色都对
    case inexact // 空心圆：代表颜色对但位置不对
}


struct MatchMakers : View {
    // MARK: Data In
    let matches: [Match]

    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                matchMaker(peg: 0)
                matchMaker(peg: 1)
            }
            HStack {
                matchMaker(peg: 2)
                matchMaker(peg: 3)
            }
        }
    }
    
    func matchMaker (peg: Int) -> some View { // 返回matchMaker的View
        let exactCount = matches.count { $0 == .exact }
        let foundCount = matches.count { $0 != .noMatch }
        
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear ,lineWidth: 2)
            .aspectRatio(1 ,contentMode: .fit)
        
    }
}

#Preview {
    MatchMakers(matches: [.exact, .exact, .inexact, .noMatch])
}
