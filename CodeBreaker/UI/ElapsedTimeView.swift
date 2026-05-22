//
//  ElapsedTime.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/12.
//

import SwiftUI

struct ElapsedTimeView: View {
    // MARK: Data in
    let startTime: Date
    let endTime: Date?
    
    
    // MARK: - body
    var body: some View {
        if let endTime { // if let endTime = endTime
            Text(endTime, format: .offset(to: startTime, allowedFields: [.minute, .second]))
        } else {
            Text(TimeDataSource<Date>.currentDate, format: .offset(to: startTime, allowedFields: [.minute, .second]))
        }
        
    }
}

