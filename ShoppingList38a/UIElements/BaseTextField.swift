//
//  BaseTextField.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 14.09.2026.
//

import SwiftUI

struct BaseTextField: View {
    let placeholder: String
    @Binding var text: String
    let errorMessage: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField(placeholder, text: $text)
                    .font(AppFont.regular17)
                
                if !text.isEmpty {
                    Button(
                        action: { text = "" },
                        label: {
                            Image(systemName: AppSystemIcon.xmarkCircleFill)
                                .foregroundColor(Color(.hintGrey))
                        }
                    )
                }
            }
            .padding()
            .background(Color(.baseTextFieldBackground))
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
                    .font(.system(size: 12))
                    .foregroundColor(Color(.systemsRed))
                    .padding(.horizontal, 4)
            }
        }
    }
}

#Preview { // дефолтное состояние с ошибкой дубля
    @Previewable @State var text = "Новый год"
    
    let currentError = text == "Новый год"
    ? "Это название уже используется, пожалуйста, измените его."
    : nil
    
    BaseTextField(
        placeholder: "Введите название",
        text: $text,
        errorMessage: currentError
    )
    .padding()
    .background(Color(.primaryBackground))
}
