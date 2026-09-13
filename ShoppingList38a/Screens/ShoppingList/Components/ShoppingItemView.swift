//
//  ShoppingItemView.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 13.09.2026.
//

import SwiftUI

struct ShoppingItemView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let shoppingItem: ShoppingItem
    let onTogglePurchased: () -> Void
    
    private var textColor: Color {
        if shoppingItem.isPurchased {
            return colorScheme == .light ? .listGrey : .hintGrey
        }
        
        return .primaryText
    }
    
    private var checkboxColor: Color {
        colorScheme == .light ? .listGrey : .primaryText
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                onTogglePurchased()
            } label: {
                if shoppingItem.isPurchased {
                    Image(systemName: AppSystemIcon.checkmarkSquareFill)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .turquoise)
                } else {
                    Image(systemName: AppSystemIcon.square)
                        .foregroundStyle(checkboxColor)
                }
            }
            .buttonStyle(.plain)
            .font(AppFont.regular24)
            .frame(width: 44, height: 44)
            
            Text(shoppingItem.title)
                .font(AppFont.regular17)
                .foregroundStyle(textColor)
            
            Spacer()
            
            Text("\(shoppingItem.count) \(shoppingItem.unit.rawValue)")
                .font(AppFont.regular17)
                .foregroundStyle(textColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .frame(minHeight: 52)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 0) {
        ShoppingItemView(
            shoppingItem: .mockUnpurchased,
            onTogglePurchased: {}
        )
        
        ShoppingItemView(
            shoppingItem: .mockPurchased,
            onTogglePurchased: {}
        )
    }
    .background(.primaryBackground)
}
