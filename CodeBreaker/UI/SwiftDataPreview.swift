//
//  SwiftDataPreview.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/30.
//

import SwiftUI
import SwiftData
struct SwiftDataPreview: PreviewModifier {
    
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: CodeBreaker.self, // @Model 的模型
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        // maybe load up some sample data into container.mainContext
        return container
    }
    
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait<Preview.ViewTraits> {
    @MainActor static var swiftData: Self = .modifier(SwiftDataPreview())
}


