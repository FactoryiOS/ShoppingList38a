//
//  BaseTextField.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 14.09.2026.
//

import SwiftUI

struct BaseTextField: View {
    @FocusState.Binding var isFocused: Bool
    
    let placeholder: String
    @Binding var text: String
    let errorMessage: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField(
                    placeholder,
                    text: $text,
                    prompt: Text(placeholder)
                        .foregroundStyle(.hintGrey)
                )
                .font(AppFont.regular17)
                .foregroundStyle(.primaryText)
                .focused($isFocused)
                
                if !text.isEmpty && isFocused {
                    Button(
                        action: { text = "" },
                        label: {
                            Image(systemName: AppSystemIcon.xmarkCircleFill)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.clearIconForeground, .hintGrey)
                        }
                    )
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color(.baseElementsBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        errorMessage != nil ? Color(.systemsRed) : Color.clear,
                        lineWidth: 0.5
                    )
            )
            
            if let errorMessage {
                Text(errorMessage)
                    .font(AppFont.regular13)
                    .foregroundColor(Color(.systemsRed))
                    .padding(.horizontal, 8)
            }
        }
    }
}

#Preview {
    @Previewable @State var text = "Новый год"
    @FocusState var isFocused: Bool
    
    let currentError = text == "Новый год"
    ? "Это название уже используется, пожалуйста, измените его."
    : nil
    
    BaseTextField(
        isFocused: $isFocused,
        placeholder: "Введите название",
        text: $text,
        errorMessage: currentError
    )
    .padding()
    .background(Color(.primaryBackground))
}
