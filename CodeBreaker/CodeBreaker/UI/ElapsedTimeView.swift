//
//  ElapsedTime.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/12.
//

import SwiftUI

struct ElapsedTimeView: View {
    // MARK: Data in
    var startTime: Date = .now
    var endTime: Date?
    
    
    // MARK: - body
    var body: some View {
        Text("0:10")
    }
}

#Preview {
    ElapsedTimeView()
}
