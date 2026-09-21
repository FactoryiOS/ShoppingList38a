//
//  ShoppingListView.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 19.09.2026.
//

import SwiftUI

struct ShoppingListView: View {
    
    private enum ShoppingListTexts {
        static let searchPlaceholder = "Поиск"
        static let addButtonTitle = "Добавить товар"
    }
    
    @Environment(\.dismiss) private var dismiss
    
    let listTitle: String
    
    @State private var observed = Observed()
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: 8) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: AppSystemIcon.chevronLeft)
                        .foregroundStyle(.titleText)
                        .frame(width: 28, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Text(listTitle)
                    .font(AppFont.medium17)
                    .foregroundStyle(.titleText)
                    .fixedSize()
                
                Spacer()
                
                Button {
                    // Экшен для троеточия
                } label: {
                    Image(systemName: AppSystemIcon.ellipsisCircle)
                        .foregroundStyle(.titleText)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
            }
            .frame(height: 44)
            .padding(.horizontal, 16)
            .background(.primaryBackground)
            
            customSearchBar
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .background(.primaryBackground)
            
            productsList
            
            Spacer()
            
            addButton
        }
        .background(.primaryBackground)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    private var customSearchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField(ShoppingListTexts.searchPlaceholder, text: $observed.searchText)
                .font(AppFont.regular17)
                .foregroundStyle(.primaryText)
        }
        .padding(.horizontal, 8)
        .frame(height: 38)
        .background(.searchBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
    
    private var productsList: some View {
        List(observed.products) { item in
            VStack(spacing: .zero) {
                ShoppingItemView(
                    shoppingItem: item,
                    onTogglePurchased: {
                        observed.handleToggleCheck(for: item.id)
                    }
                )
                
                Divider()
                    .background(.borderGrey)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(.zero))
            .contentShape(Rectangle())
            .onTapGesture {
                observed.handleToggleCheck(for: item.id)
            }
            .swipeActions(allowsFullSwipe: false) {
                swipeButtons(for: item.id)
            }
        }
        .padding(.horizontal, 8)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
    }
    
    private func swipeButtons(for id: UUID) -> some View {
        Group {
            Button(role: .destructive) {
                observed.handleDeleteProduct(for: id)
            } label: {
                Image(systemName: AppSystemIcon.trash)
                    .environment(\.symbolVariants, .none)
            }
            .tint(.systemsRed)
            
            Button {
                observed.handleEditProduct(for: id)
            } label: {
                Image(systemName: AppSystemIcon.squareAndPencil)
                    .environment(\.symbolVariants, .none)
            }
            .tint(.systemsGrey)
        }
    }
    
    private var addButton: some View {
        BaseButton(
            title: ShoppingListTexts.addButtonTitle,
            isActive: true,
            action: {
                observed.handleAddProductTap()
            }
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
}

#Preview("Светлая тема") {
    @Previewable @State var appState = AppState()
    
    NavigationStack {
        ShoppingListView(listTitle: "Новый год")
    }
    .environment(appState)
    .preferredColorScheme(.light)
}

#Preview("Темная тема") {
    @Previewable @State var appState = AppState()
    
    NavigationStack {
        ShoppingListView(listTitle: "Новый год")
    }
    .environment(appState)
    .preferredColorScheme(.dark)
}
