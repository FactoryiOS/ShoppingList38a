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
        static let emptyStateTitle = "Давайте спланируем покупки!"
        static let emptyStateSubTitle = "Начните добавлять товары"
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var observed = Observed()
    
    private let shoppingListId: UUID
    
    init(shoppingListId: UUID) {
        self.shoppingListId = shoppingListId
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            customSearchBar
                .padding([.horizontal, .bottom], 16)
                .padding(.top, 4)
                .background(.primaryBackground)
            Group {
                if observed.products.isEmpty {
                    emptyState
                } else {
                    productsListState
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.primaryBackground
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            addButton
        }
        .toolbar {
            titleToolbar
            trailingToolbar
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            observed.fetchShoppingList(by: shoppingListId)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 0) {
            Spacer()
            PlaceholderView(
                image: AppImage.emptyShoppingList,
                title: ShoppingListTexts.emptyStateTitle,
                subtitle: ShoppingListTexts.emptyStateSubTitle
            )
            Spacer()
        }
        .padding(.bottom, 64)
    }
    
    private var productsListState: some View {
        VStack(spacing: .zero) {
            productsList
        }
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
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .swipeActions(allowsFullSwipe: false) {
                swipeButtons(for: item.id)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .contentMargins(.bottom, 86, for: .scrollContent)
    }
    
    private var customSearchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: AppSystemIcon.magnifyingGlass)
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
    
    @ToolbarContentBuilder
    private var titleToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: AppSystemIcon.chevronLeft)
                    .foregroundStyle(.titleText)
                    .frame(width: 28, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            Text(observed.listTitle)
                .font(AppFont.medium17)
                .foregroundStyle(.titleText)
        }
    }
    
    @ToolbarContentBuilder
    private var trailingToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                // Экшен для троеточия
            } label: {
                Image(systemName: AppSystemIcon.ellipsisCircle)
                    .foregroundStyle(.titleText)
                    .frame(width: 44, height: 44)
            }
        }
    }
}

#Preview("Empty") {
    @Previewable @State var appState = AppState()
    NavigationStack {
        ShoppingListView(shoppingListId: UUID())
    }
    .environment(appState)
    .preferredColorScheme(.light)
}

#Preview("Data") {
    @Previewable @State var appState = AppState()
    NavigationStack {
        ShoppingListView(shoppingListId: ListItem.mocks.first?.id ?? UUID())
    }
    .environment(appState)
    .preferredColorScheme(.light)
}
