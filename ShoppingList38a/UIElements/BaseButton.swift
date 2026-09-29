//
//  BaseButton.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 14.09.2026.
//

import SwiftUI

struct BaseButton: View {
    let title: LocalizedStringResource
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.medium17)
                .foregroundStyle(isActive ? .white : .hintGrey)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isActive ? .turquoise : .buttonGrey)
                .cornerRadius(100)
        }
        .disabled(!isActive)
    }
}

#Preview {
    VStack(spacing: 16) {
        BaseButton(
            title: .create,
            isActive: false,
            action: {}
        )

        BaseButton(
            title: .create,
            isActive: true,
            action: {}
        )
    }
    .padding()
    .background(.primaryBackground)
}
