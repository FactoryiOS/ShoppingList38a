//
//  BaseButton.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 14.09.2026.
//

import SwiftUI

struct BaseButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.medium17)
                .foregroundColor(isActive ? Color(.white) : Color(.hintGrey))
                .frame(maxWidth: .infinity)
                .padding()
                .background(isActive ? Color(.turquoise) : Color(.buttonGrey))
                .cornerRadius(100)
        }
        .disabled(!isActive)
    }
}

#Preview {
    VStack(spacing: 16) {
        BaseButton(
            title: "Создать",
            isActive: false, // неактивная кнопка
            action: {}
        )
        
        BaseButton(
            title: "Создать",
            isActive: true, // активная кнопка
            action: {}
        )
    }
    .padding()
    .background(Color(.primaryBackground))
}
