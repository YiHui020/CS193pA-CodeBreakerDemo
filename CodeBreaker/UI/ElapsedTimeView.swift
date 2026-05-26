//
//  ElapsedTime.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/12.
//

import SwiftUI

struct ElapsedTimeView: View {
    // MARK: Data in
    let startTime: Date?
    let endTime: Date?
    let elapsedTime: TimeInterval
    
    var format:SystemFormatStyle.DateOffset {
        .offset(to: startTime! - elapsedTime, allowedFields: [.minute, .second])
    }
    
    
    
    // MARK: - body
    var body: some View {
        
        if startTime != nil {
            if let endTime { // if let endTime = endTime
                Text(endTime, format: format)
            } else {
                Text(TimeDataSource<Date>.currentDate, format: format)
            }
        }
        else {
            Image(systemName: "pause")
        }
        
    }
}

