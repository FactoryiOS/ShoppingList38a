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
                .foregroundColor(isActive ? Color(.white) : Color(.hintGrey))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isActive ? Color(.turquoise) : Color(.buttonGrey))
                .cornerRadius(100)
        }
        .disabled(!isActive)
    }
}

#Preview {
    VStack(spacing: 16) {
        BaseButton(
            title: .create,
            isActive: false, // неактивная кнопка
            action: {}
        )
        
        BaseButton(
            title: .create,
            isActive: true, // активная кнопка
            action: {}
        )
    }
    .padding()
    .background(Color(.primaryBackground))
}
