//
//  GameEditer.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/19.
//

import SwiftUI

struct GameEditor: View {
    // MARK: Data Shared by Me
    @Bindable var game: CodeBreaker
    @State private var showInvalidGameAlert: Bool = false
    
    
    // MARK: Action Function
    let submit: (() -> Void)
    let dismiss: (() -> Void)
     
    
    // MARK: Body -
    var body: some View {
        VStack{
            Form {
                Section ("Name"){
                    TextField("Name", text: $game.name)
                        .autocapitalization(.words)
                        .autocorrectionDisabled(false)
                        .onSubmit {
                            print("Game Name Submitted! Currently Name: \(game.name)")
                            submit()
                            dismiss()
                        }
                }
                Section ("Pegs"){
                    PegChoicesPicker(pegChoices: $game.pegChoices)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    done()
                }
                .alert("Invalid Game", isPresented: $showInvalidGameAlert) {
                    Button("OK") {
                        showInvalidGameAlert = false
                    }
                } message: {
                     Text("A Game must have a name and different pegs more than two")
                }
            }
        }
    }
    
    func done() {
        if !game.isExist() {
            showInvalidGameAlert = true
            return
        }
        submit()
        dismiss()
    }
    
    
    
}





#Preview {
    @Previewable var game = CodeBreaker(name: "Preview", pegChoices: [.red, .blue, .yellow, .purple])
    GameEditor(game: game) {
        
    } dismiss: {
        
    }
        .onChange(of: game.name) {
            print("Game Name Changed! Currently Name: \(game.name)")
        }
        .onChange(of: game.pegChoices) {
            print("Game PegChoices Changed! Currently Choices: \(game.pegChoices)")
        }
}
