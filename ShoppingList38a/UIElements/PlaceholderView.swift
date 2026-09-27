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
        VStack(spacing: 28) {
            Image(image)
            
            VStack(spacing: 4) {
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
    }
}

#Preview {
    PlaceholderView(
        image: AppImage.emptyShoppingLists,
        title: String(localized: "Let's plan your shopping!"),
        subtitle: String(localized: "Create your first list")
    )
    
    PlaceholderView(
        image: AppImage.emptyShoppingList,
        title: String(localized: "Let's plan your shopping!"),
        subtitle: String(localized: "Start adding items")
    )
}
