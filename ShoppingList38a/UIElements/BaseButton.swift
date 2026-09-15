//
//  BaseButton.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 14.09.2026.
//

import SwiftUI

struct BaseButton: View {
    let baseButtonModel: BaseButtonModel
    
    var body: some View {
        Button(action: baseButtonModel.action) {
            Text(baseButtonModel.title)
                .font(AppFont.medium17)
                .foregroundColor(baseButtonModel.isActive ? Color(.white) : Color(.hintGrey))
                .frame(maxWidth: .infinity)
                .padding()
                .background(baseButtonModel.isActive ? Color(.turquoise) : Color(.buttonGrey))
                .cornerRadius(100)
        }
        .disabled(!baseButtonModel.isActive)
    }
}

#Preview {
    VStack(spacing: 16) {
        ForEach(BaseButtonModel.mocks) { buttonModel in
            BaseButton(baseButtonModel: buttonModel)
        }
    }
    .padding()
    .background(Color(.primaryBackground))
}
