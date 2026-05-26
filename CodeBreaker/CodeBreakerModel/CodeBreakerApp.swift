//
//  CodeBreakerApp.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/4/10.
//

import SwiftUI
import SwiftData

@main
struct CodeBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: CodeBreaker.self)
        }
    }
}
