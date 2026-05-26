//
//  PegChoicesPicker.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/21.
//

import SwiftUI

struct PegChoicesPicker: View {
    @Binding var pegChoices: [Color]
    
    var body: some View {
        List {
            ForEach (pegChoices.indices, id: \.self) {index in
                ColorPicker (
                    selection: $pegChoices[index],
                    // 需要同时拿取和计算的值用 Binding ，否则直接调用
                    supportsOpacity: false
                ) {
                    EditButton("Peg \(index + 1)", systemImage: "minus.circle",color: .red) {
                        pegChoices.remove(at: index)
                    }
                    
                }
            }
            EditButton("Add Peg", systemImage: "plus.circle") {
                pegChoices.append(.white)
            }
        }
        
    }
    
    func EditButton(
        _ title: String,
        systemImage: String,
        color: Color? = nil,
        action: @escaping () -> Void // 接受一个闭包，传递下去需要写逃逸闭包
    ) -> some View{
        HStack {
            Button {
                withAnimation {
                    action()
                }
            } label: {
                Image(systemName: systemImage).tint(color)
            }
            Text(title)
        }
    }
    
}

#Preview {
    @Previewable @State var pegChoices: [Color] = [Color.red, .blue,.yellow]
    PegChoicesPicker(pegChoices: $pegChoices)
}
