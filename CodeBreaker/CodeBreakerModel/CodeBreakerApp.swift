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
            GeometryReader { geometry in
                GameChooser()
                    .environment(\.sceneFrame, geometry.frame(in: .global))
            }
        }
        .modelContainer(for: CodeBreaker.self)
    }
}


extension EnvironmentValues {
    @Entry var sceneFrame: CGRect = ({
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return scene.screen.bounds
        }
        return .zero
    }())
}
