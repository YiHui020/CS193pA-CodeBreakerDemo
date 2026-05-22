//
//  pegCodeView.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/4/23.
//

import SwiftUI

struct PegCodeView<AncillaryView: View>: View {
    // MARK: Data in
    let code: Code
    // MARK: Data Shared by me
    @Binding var selection: Int
    @ViewBuilder let ancillaryView : () -> AncillaryView
    
    // MARK: Data Owned by me
    @Namespace private var selectionNamespace
    
    
    init(
        code: Code,
        selection: Binding<Int> = Binding<Int>.constant(-1),
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ){
        self.code = code
        self._selection = selection
        self.ancillaryView = ancillaryView
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            // MatchMaker Area
            Rectangle().foregroundStyle(.clear).aspectRatio(1, contentMode: .fit)
                .overlay {
                    ancillaryView()
                }
            // Pegs Area
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(peg: code.pegs[index])
                    .background { // selection highlight
                        Group {
                            if selection == index , code.kind == .guess {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(CodeBreakerView.Selection.color)
                                    .animation(.selectionAnimation, value: selection)
                                    .aspectRatio(1, contentMode: .fit)
                                    .padding(-4)
                                    .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                            }
                        }
                        .animation(.selectionAnimation, value: selection)
                    }
                    .overlay { // hidden code
                        Circle()
                            .foregroundStyle(code.isHidden ? Color.primary : .clear)
                            .transaction { transaction in
                                if code.isHidden {
                                    transaction.animation = nil
                                }
                            }
                    }
                    
                    .onTapGesture {
                        if (code.kind == .guess) {
                            selection = index
                        }
                        
                    }
                    .padding(3)
            }
            
        }
        
    }
}

