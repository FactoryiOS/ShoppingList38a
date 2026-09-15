//
//  BaseTextField.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 14.09.2026.
//

import SwiftUI

struct BaseTextField: View {
    let baseTextFieldModel: BaseTextFieldModel
    @Binding var text: String
    
    private var currentErrorMessage: String? {
        baseTextFieldModel.errorMessage(for: text)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField(baseTextFieldModel.placeholder, text: $text)
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
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color(.baseElementsBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        currentErrorMessage != nil ? Color(.systemsRed) : Color.clear,
                        lineWidth: 0.5
                    )
            )
            
            if let currentErrorMessage {
                Text(currentErrorMessage)
                    .font(AppFont.regular13)
                    .foregroundColor(Color(.systemsRed))
                    .padding(.horizontal, 8)
            }
        }
    }
}

#Preview {
    @Previewable @State var text = BaseTextFieldModel.duplicateError.defaultText
    
    BaseTextField(
        baseTextFieldModel: .duplicateError,
        text: $text
    )
    .padding()
    .background(Color(.primaryBackground))
}
