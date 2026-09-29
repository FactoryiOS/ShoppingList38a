//
//  BaseTextField.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 14.09.2026.
//

import SwiftUI

struct BaseTextField: View {
    @Binding var text: String

    @FocusState.Binding var isFocused: Bool

    let placeholder: LocalizedStringResource
    let errorMessage: LocalizedStringResource?

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
            .background(.baseElementsBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        errorMessage != nil ? .systemsRed : .clear,
                        lineWidth: 0.5
                    )
            )

            if let errorMessage {
                Text(errorMessage)
                    .font(AppFont.regular13)
                    .foregroundStyle(.systemsRed)
                    .padding(.horizontal, 8)
                    .transition(
                        .opacity.combined(
                            with: .offset(y: -4)
                        )
                    )
            }
        }
        .animation(
            .easeInOut(duration: 0.2),
            value: errorMessage != nil
        )
    }
}

#Preview {
    @Previewable @State var text = "Новый год"
    @FocusState var isFocused: Bool

    let currentError: LocalizedStringResource? = text == "Новый год"
        ? .shoppingListDuplicateNameError
        : nil

    BaseTextField(
        text: $text,
        isFocused: $isFocused,
        placeholder: .shoppingListNamePlaceholder,
        errorMessage: currentError
    )
    .padding()
    .background(.primaryBackground)
}
