//
//  PlaceholderView.swift
//  ShoppingList38a
//
//  Created by Kislov Vadim on 12.09.2026.
//

import SwiftUI

struct PlaceholderView: View {
    let image: ImageResource
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: AppSpacing.space28) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            
            VStack(spacing: AppSpacing.space4) {
                Text(title)
                    .font(AppFont.medium20)
                    .foregroundStyle(.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(AppFont.regular17)
                    .foregroundStyle(.primaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, AppSpacing.space16)
    }
}

#Preview {
    PlaceholderView(
        image: AppImage.emptyShoppingList,
        title: "Давайте спланируем покупки!",
        subtitle: "Создайте свой первый список")
}
