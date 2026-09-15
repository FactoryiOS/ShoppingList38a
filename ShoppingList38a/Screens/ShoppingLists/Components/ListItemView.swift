//
//  ListItemView.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 14.09.2026.
//

import SwiftUI

struct ListItemView: View {
    let listItem: ListItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(listItem.icon.rawValue)
                .frame(width: 48, height: 48)
                .foregroundStyle(.black)
                .background(listItem.color.color, in: Circle())
            
            Text(listItem.title)
                .font(AppFont.medium20)
                .foregroundStyle(.primaryText)
            
            Spacer()
            
            HStack(spacing: 0) {
                Text("\(listItem.purchasedCount)/")
                    .font(AppFont.regular17)
                    .foregroundStyle(.primaryText)
                
                Text("\(listItem.totalCount)")
                    .font(AppFont.medium17)
                    .foregroundStyle(.primaryText)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 84)
        .background(.baseElementsBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}

#Preview {
    ListItemView(listItem: .mock)
}
